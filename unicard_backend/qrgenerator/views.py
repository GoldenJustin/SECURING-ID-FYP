from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from .models import QRModel
from django.conf import settings
from cryptography.hazmat.backends import default_backend
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.primitives.asymmetric import padding, rsa 
import os, json, time, base64, pyqrcode
from accountsAPI.models import Student
from django.db import models
from accountsAPI.models import Student
from django.dispatch import receiver


# Generate RSA key pair
def generate_key_pair():
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )
    return private_key, private_key.public_key()

# Encrypt the text using recipient's public key


def encrypt_text(text, public_key):
    ciphertext = public_key.encrypt(
        text.encode(),
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return base64.urlsafe_b64encode(ciphertext).decode()


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
        qr_data = str(data)

        # Generate RSA key pair
        private_key, public_key = generate_key_pair()

        # Encrypt the QR code data using recipient's public key
        encrypted_data = encrypt_text(qr_data, public_key)

        qr_image_path = save_qr_image(encrypted_data, instance.student_code)

        # Create QRModel instance for the new student
        QRModel.objects.create(student=instance, qr_image=qr_image_path)


def generate_key_pair():
    private_key = rsa.generate_private_key(
        public_exponent=65537,
        key_size=2048,
        backend=default_backend()
    )
    return private_key, private_key.public_key()


def encrypt_text(text, public_key):
    ciphertext = public_key.encrypt(
        text.encode(),
        padding.OAEP(
            mgf=padding.MGF1(algorithm=hashes.SHA256()),
            algorithm=hashes.SHA256(),
            label=None
        )
    )
    return base64.urlsafe_b64encode(ciphertext).decode()


def decrypt_text(request):
    # Decrypt the encrypted text using the private key (server-side operation)
    # Ensure proper authentication and authorization before performing decryption

    encrypted_text = request.GET.get('encrypted_text')
    private_key = request.GET.get('private_key')

    if encrypted_text and private_key:
        try:
            # Decode the private key
            private_key_bytes = private_key.encode()
            private_key_obj = serialization.load_pem_private_key(
                private_key_bytes, password=None, backend=default_backend())

            # Decrypt the encrypted text using the private key
            ciphertext = base64.urlsafe_b64decode(encrypted_text.encode())
            plaintext = private_key_obj.decrypt(
                ciphertext,
                padding.OAEP(
                    mgf=padding.MGF1(algorithm=hashes.SHA256()),
                    algorithm=hashes.SHA256(),
                    label=None
                )
            )

            decrypted_data = plaintext.decode()

            response = {
                'status': 'success',
                'decrypted_text': decrypted_data
            }

        except (ValueError, TypeError, AttributeError):
            response = {
                'status': 'error',
                'message': 'Invalid encrypted text or private key'
            }
    else:
        response = {
            'status': 'error',
            'message': 'Invalid encrypted text or private key'
        }

    return JsonResponse(response)


def save_qr_image(encrypted_data, student_code):
    imagename = '{}.png'.format(student_code.replace('/', '_'))
    image_path = os.path.join('media', 'Qr-Images', imagename)
    if not os.path.exists(image_path):
        qr = pyqrcode.create(encrypted_data)

        # Save the encrypted QR code image
        qr.png(image_path, scale=10)

    return image_path


@receiver(models.signals.pre_delete, sender=QRModel)
def auto_delete_qr_image(sender, instance, **kwargs):
    # Delete the QR code image when the QRModel instance is deleted
    if instance.qr_image:
        if os.path.isfile(instance.qr_image.path):
            os.remove(instance.qr_image.path)
