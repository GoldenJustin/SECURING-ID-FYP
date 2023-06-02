
from django.shortcuts import render
from django.http import HttpResponse
from .models import QRModel
import time
import pyqrcode
from django.conf import settings
from cryptography.fernet import Fernet
import base64
import uuid
from django.http import JsonResponse


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
def save_qr_image(text, key):
    encrypted_text = encrypt_text(text, key)
    image = pyqrcode.create(encrypted_text)
    imagename = str(uuid.uuid4())  # Generate a UUID v4 for the image name
    image.png("./media/Qr-Images/{}.png".format(imagename), scale=10)
    return imagename

def Home(request):
    context = {"is_qr": False}
    if request.method == "POST":
        text = request.POST.get('comment')
        key = generate_keys()
        qr_image = "Qr-Images/{}.png".format(save_qr_image(text, key))
        encrypted_text = encrypt_text(text, key)
        data = QRModel.objects.create(text=text, qr_image=qr_image, encrypted_text=encrypted_text)
        context.update({"data": data, "is_qr": True, "public_key": base64.urlsafe_b64encode(key).decode()})
    elif request.method == "GET":
        encrypted_text = request.GET.get('encrypted_text')
        public_key = request.GET.get('public_key')
        if encrypted_text and public_key:
            key = base64.urlsafe_b64decode(public_key.encode())
            decrypted_text = decrypt_text(encrypted_text, key)
            context.update({"decrypted_text": decrypted_text})
    return render(request, 'qrgenerator/home.html', context=context)



def decrypt_text(request):
    encrypted_text = request.GET.get('encrypted_text')
    public_key = request.GET.get('public_key')

    # Perform decryption using the encrypted_text and public_key

    decrypted_text = "NIT STUDENT ID CARD, This card is valid for student only, For more information please contact, rector@nit.ac.tz or +255 22 2400148"  # Replace with your decrypted text

    return JsonResponse({'decrypted_text': decrypted_text})


 
    

