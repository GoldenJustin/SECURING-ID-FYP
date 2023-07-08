from django.core.exceptions import ValidationError
from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from .models import Student, Staff
from uuid import uuid4

class StudentSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(
        required=True,
        validators=[UniqueValidator(queryset=Student.objects.all())]
    )
    student_code = serializers.CharField(
        required=True,
        validators=[UniqueValidator(queryset=Student.objects.all())]
    )
    password = serializers.CharField(max_length=8)

    class Meta:
        model = Student
        fields = ('student_code', 'email', 'password', 'first_name', 'middle_name', 'last_name', 'gender', 'expdate', 'programme', 'signature', 'avatar')

class StaffSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(
        required=True,
        validators=[UniqueValidator(queryset=Staff.objects.all())]
    )
    username = serializers.CharField(
        required=True,
        validators=[UniqueValidator(queryset=Staff.objects.all())]
    )
    password = serializers.CharField(max_length=8)

    class Meta:
        model = Staff
        fields = ('username', 'email', 'password')

class UserLoginSerializer(serializers.Serializer):
    username = serializers.CharField()
    password = serializers.CharField()

    def validate(self, data):
        username = data.get("username", None)
        password = data.get("password", None)
        if not username and not password:
            raise ValidationError("Details not entered.")
        student = Student.objects.filter(
            student_code=username,
            password=password
        ).first()
        staff = Staff.objects.filter(
            username=username,
            password=password
        ).first()
        if not student and not staff:
            raise ValidationError("User credentials are not correct.")
        if student and student.ifLogged:
            raise ValidationError("User already logged in.")
        if staff and staff.ifLogged:
            raise ValidationError("User already logged in.")
        if student:
            data['token'] = str(uuid4())
            data['role'] = 'student'  
            student.ifLogged = True
            student.token = data['token']
            student.save()
        else:
            data['token'] = str(uuid4())
            data['role'] = 'staff'  
            staff.ifLogged = True
            staff.token = data['token']
            staff.save()
        return data


class UserLogoutSerializer(serializers.Serializer):
    token = serializers.CharField()
    status = serializers.CharField(required=False, read_only=True)

    def validate(self, data):
        token = data.get("token", None)
        student = Student.objects.filter(token=token).first()
        staff = Staff.objects.filter(token=token).first()
        if not student and not staff:
            raise ValidationError("User is not logged in.")
        if student:
            student.ifLogged = False
            student.token = ""
            student.save()
        else:
            staff.ifLogged = False
            staff.token = ""
            staff.save()
        data['status'] = "User is logged out."
        return data
