from django.urls import path
from .views import Home
from .views import decrypt_text


urlpatterns = [
    path('', Home),
    path('decrypt/', decrypt_text, name='decrypt_text'),

]