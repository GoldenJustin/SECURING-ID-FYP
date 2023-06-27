from django.urls import path
from .views import get_student_memory
from .views import (
    StudentAPIView,
    StaffAPIView,
    UserLoginAPIView,
    UserLogoutAPIView,
    index,
    get_student_memory
)

urlpatterns = [
    path('addStudent/', StudentAPIView.as_view(), name="add_student"),
    path('addStaff/', StaffAPIView.as_view(), name="add_staff"),
    path('user/login/', UserLoginAPIView.as_view(), name="login_user"),
    path('user/logout/', UserLogoutAPIView.as_view(), name="logout_user"),
    path('', index, name="index"),
    path('student/memory/<str:student_code>/', get_student_memory, name="student_memory"),]
