from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from .models import QRModel
import time
import pyqrcode
from django.conf import settings
from cryptography.fernet import Fernet
import base64
import uuid
import os
from accountsAPI.models import Student

# Generate encryption keys
def generate_keys():
    key = Fernet.generate_key()
    return key

# Encrypt the text
def encrypt_text(text, key):
    cipher_suite = Fernet(key)
    encrypted_text = cipher_suite.encrypt(text.encode())
    return encrypted_text

# Decrypt the text
def decrypt_text(encrypted_text, key):
    cipher_suite = Fernet(key)
    decrypted_text = cipher_suite.decrypt(encrypted_text.encode())
    return decrypted_text.decode()

# Save QR image with encrypted text
def save_qr_image(text, key, student_code):
    encrypted_text = encrypt_text(text, key)
    imagename = '{}.png'.format(student_code.replace('/', '_'))
    image_path = os.path.join('qrgenerator/Qr-Images', imagename)
    if not os.path.exists(image_path):  
        # Check if the image already exists
        image = pyqrcode.create(encrypted_text)
        image.png(image_path, scale=10)
    return image_path

def generate_qr(student_code):
    try:
        # Retrieve student data from the 'accountsAPI' app using the student_code
        student = Student.objects.get(student_code=student_code.replace('_', '/'))

        # Get the data to be displayed in the QR code
        data = {
            'programme': student.programme,
            'name': student.name(),
            'student_code': student.student_code.replace('/', '_'),
            'signature': student.signature,
            'exp_date': student.expdate.strftime('%Y-%m-%d')
        }

        # Generate encryption keys
        key = generate_keys()

        # Encrypt the data
        encrypted_data = encrypt_text(str(data), key)

        # Save QR image with encrypted data
        qr_image_path = save_qr_image(str(encrypted_data), key, student.student_code)

        response = {
            'status': 'success',
            'qr_image_path': qr_image_path,
            'public_key': base64.urlsafe_b64encode(key).decode()
        }

    except Student.DoesNotExist:
        response = {
            'status': 'error',
            'message': 'Student data not found'
        }

    return JsonResponse(response)


def decrypt_text(request):
    encrypted_text = request.GET.get('encrypted_text')
    public_key = request.GET.get('public_key')

    if encrypted_text and public_key:
        # Decode the public key
        key = base64.urlsafe_b64decode(public_key.encode())

        # Decrypt the encrypted text
        decrypted_text = decrypt_text(encrypted_text, key)

        response = {
            'status': 'success',
            'decrypted_text': decrypted_text
        }
    else:
        response = {
            'status': 'error',
            'message': 'Invalid encrypted text or public key'
        }

    return JsonResponse(response)

