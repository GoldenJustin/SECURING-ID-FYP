from django.urls import path
from .decryptAPI import decrypt_api

app_name = 'qrgenerator'

urlpatterns = [
    path('', decrypt_api, name='decrypt_api'),
]
