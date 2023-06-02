
from django.contrib import admin
from django.urls import path, include
from login.views import index

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('login.urls')),
    path('', index, name="index"),
]
