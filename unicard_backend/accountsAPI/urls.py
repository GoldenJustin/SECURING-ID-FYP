from django.urls import path
from .views import Home, id_card_data, make_payment, universal_api
from .views import (
    StudentAPIView,
    StaffAPIView,
    UserLoginAPIView,
    UserLogoutAPIView,
    index,
    id_card_data
)

urlpatterns = [
    path('addStudent/', StudentAPIView.as_view(), name="add_student"),
    path('addStaff/', StaffAPIView.as_view(), name="add_staff"),
    path('user/login/', UserLoginAPIView.as_view(), name="login_user"),
    path('user/logout/', UserLogoutAPIView.as_view(), name="logout_user"),
    path('login/', index, name="index"),
    path('cardDetails/<str:student_code>/', id_card_data, name="card_data"),
    path('payment/<str:student_code>/', make_payment, name='make_payment'),
    path('universal/<str:student_code>/', universal_api, name='universal'),

    path('', Home, name='Home'),
    
]
