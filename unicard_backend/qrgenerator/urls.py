from django.urls import path
from .views import generate_qr, decrypt_text

app_name = 'qrgenerator'

urlpatterns = [
    path('generate/<str:student_code>/', generate_qr, name='generate_qr'),
    path('decrypt/', decrypt_text, name='decrypt_text'),
]
