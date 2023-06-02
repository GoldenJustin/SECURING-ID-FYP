from django.db.models import Q # for queries
from rest_framework import serializers
from rest_framework.validators import UniqueValidator
from .models import Student, Staff
from django.core.exceptions import ValidationError
from uuid import uuid4


class StudentSerializer(serializers.ModelSerializer):
    email = serializers.EmailField(
        required=True,
        validators=[UniqueValidator(queryset=Student.objects.all())]
        )
    username = serializers.CharField(
        required=True,
        validators=[UniqueValidator(queryset=Student.objects.all())]
        )
    password = serializers.CharField(max_length=8)

    class Meta:
        model = Student
        fields = (
            'username',
            'email',
            'password'
        )


class StudentLoginSerializer(serializers.ModelSerializer):
    # to accept either username or email
    username = serializers.CharField()
    password = serializers.CharField()
    token = serializers.CharField(required=False, read_only=True)

    def validate(self, data):
        # user,email,password validator
        username = data.get("username", None)
        password = data.get("password", None)
        if not username and not password:
            raise ValidationError("Details not entered.")
        user = None
        # if the email has been passed
        if '@' in username:
            user = Student.objects.filter(
                Q(email=username) &
                Q(password=password)
                ).distinct()
            if not user.exists():
                raise ValidationError("User credentials are not correct.")
            user = Student.objects.get(email=username)
        else:
            user = Student.objects.filter(
                Q(username=username) &
                Q(password=password)
            ).distinct()
            if not user.exists():
                raise ValidationError("User credentials are not correct.")
            user = Student.objects.get(username=username)
        if user.ifLogged:
            raise ValidationError("User already logged in.")
        user.ifLogged = True
        data['token'] = uuid4()
        user.token = data['token']
        user.save()
        return data

    class Meta:
        model = Student
        fields = (
            'username',
            'password',
            'token',
        )

        read_only_fields = (
            'token',
        )


class StudentLogoutSerializer(serializers.ModelSerializer):
    token = serializers.CharField()
    status = serializers.CharField(required=False, read_only=True)

    def validate(self, data):
        token = data.get("token", None)
        print(token)
        user = None
        try:
            user = Student.objects.get(token=token)
            if not user.ifLogged:
                raise ValidationError("User is not logged in.")
        except Exception as e:
            raise ValidationError(str(e))
        user.ifLogged = False
        user.token = ""
        user.save()
        data['status'] = "User is logged out."
        return data

    class Meta:
        model = Student
        fields = (
            'token',
            'status',
        )
