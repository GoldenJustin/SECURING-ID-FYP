
from django.contrib import admin
from django.urls import path, include
from accountsAPI.views import index
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('accountsAPI.urls')),
    path('qrcode/', include('qrgenerator.urls')),
]+static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
