from django.urls import path
from .views import new_id_request, upload_file
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('new-id-request/<str:student_code>/', new_id_request, name='new-id-request'),
        path('upload/<str:student_code>/', upload_file, name='upload_file'),
] + static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)

