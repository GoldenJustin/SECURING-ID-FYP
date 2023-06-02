
from django.contrib import admin
from django.urls import path, include
from login.views import index
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('login.urls')),
    path('', include('qrgenerator.urls')),
    path('', index, name="index"),
]+static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
