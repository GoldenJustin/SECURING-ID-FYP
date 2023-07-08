from django.urls import path
from . import views

urlpatterns = [
    path('api/submit-id-card-request/', views.submit_id_card_request, name='submit_id_card_request'),
    path('api/review-id-card-requests/', views.review_id_card_requests, name='review_id_card_requests'),
    path('api/process-id-card-request/<int:request_id>/', views.process_id_card_request, name='process_id_card_request'),
    path('api/id-card-data/<str:student_code>/', views.id_card_data, name='id_card_data'),
]
