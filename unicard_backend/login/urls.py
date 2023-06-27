from django.urls import path
from .views import (
    StudentAPIView,
    StaffAPIView,
    UserLoginAPIView,
    UserLogoutAPIView,
    index
)

urlpatterns = [
    path('addStudent/', StudentAPIView.as_view(), name="add_student"),
    path('addStaff/', StaffAPIView.as_view(), name="add_staff"),
    path('user/login/', UserLoginAPIView.as_view(), name="login_user"),
    path('user/logout/', UserLogoutAPIView.as_view(), name="logout_user"),
    path('', index, name="index"),
]
