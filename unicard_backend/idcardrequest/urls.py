from django.urls import path
from .views import new_id_request

urlpatterns = [
    path('new-id-request/<str:student_code>/', new_id_request, name='new-id-request'),]
