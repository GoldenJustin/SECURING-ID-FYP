from django.shortcuts import render
from django.http import JsonResponse
from .models import QRModel
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.asymmetric import padding, rsa
import base64
import pyqrcode
import os
from django.core.files.uploadedfile import InMemoryUploadedFile
from accountsAPI.models import Student
from django.db import models
from django.dispatch import receiver

def generate_and_save_private_key():
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )

    # Serialize the private key to PEM format
    pem = private_key.private_bytes(
        encoding=serialization.Encoding.PEM,
        format=serialization.PrivateFormat.PKCS8,
        encryption_algorithm=serialization.NoEncryption()
    )

    with open('private_key.pem', 'wb') as key_file:
        key_file.write(pem)

    return private_key

def load_private_key():
    try:
        with open('private_key.pem', 'rb') as key_file:
            private_key = serialization.load_pem_private_key(
                key_file.read(),
                password=None,
                backend=default_backend()
            )
    except FileNotFoundError:
        # If the private key file doesn't exist, generate a new private key and save it
        private_key = generate_and_save_private_key()

    return private_key

def encrypt_text(text, public_key):
    public_key = load_private_key().public_key()

    # Encrypt the data
    ciphertext = public_key.encrypt(
        text.encode(),
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    encrypted_data = ciphertext.hex()

    return encrypted_data

def save_qr_image(encrypted_data, student_code):
    imagename = '{}.png'.format(student_code.replace('/', '_'))
    image_path = os.path.join('media', 'Qr-Images', imagename)
    if not os.path.exists(image_path):
        qr = pyqrcode.create(encrypted_data)

        # Save the encrypted QR code image
        qr.png(image_path, scale=2)

    return image_path

@receiver(models.signals.post_save, sender=Student)
def generate_qr(sender, instance, created, **kwargs):
    if created:
        # Generate QR code for the new student
        data = {
            'programme': instance.programme,
            'name': instance.name(),
            'student_code': instance.student_code.replace('/', '_'),
            'signature': instance.signature,
            'exp_date': instance.expdate.strftime('%Y-%m-%d')
        }
        qr_data = str(data['student_code'])

        # Generate RSA key pair
        private_key = load_private_key()
        public_key = private_key.public_key()

        # Encrypt the student code using recipient's public key
        encrypted_data = encrypt_text(qr_data, public_key)
        
         # Print the encrypted data to the console
        print("\n\n\nEncrypted Data:", encrypted_data)
        
        decrypted_data = decrypt_text(encrypted_data)
         # Print the decrypted data to the console
        print("\n\n\nDecrypted Data:", decrypted_data)

        qr_image_path = save_qr_image(encrypted_data, instance.student_code)

        # Create QRModel instance for the new student
        QRModel.objects.create(student=instance, qr_image=qr_image_path)


def decrypt_text(encrypted_text):
    # Decrypt the encrypted text using the private key (server-side operation)
    # Ensure proper authentication and authorization before performing decryption

    private_key = load_private_key()

    # Decrypt the data
    ciphertext = bytes.fromhex(encrypted_text)
    plaintext = private_key.decrypt(
        ciphertext,
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    decrypted_data = plaintext.decode()

    return decrypted_data


@receiver(models.signals.pre_delete, sender=QRModel)
def auto_delete_qr_image(sender, instance, **kwargs):
    # Delete the QR code image when the QRModel instance is deleted
    if instance.qr_image:
        if os.path.isfile(instance.qr_image.path):
            os.remove(instance.qr_image.path)