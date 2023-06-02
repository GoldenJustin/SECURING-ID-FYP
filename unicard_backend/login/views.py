from django.shortcuts import redirect
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_400_BAD_REQUEST
from .models import Student
from .serializers import StudentSerializer, StudentLoginSerializer, StudentLogoutSerializer


class Record(generics.ListCreateAPIView):
    # get method handler
    queryset = Student.objects.all()
    serializer_class = StudentSerializer


class Login(generics.GenericAPIView):
    # get method handler
    queryset = Student.objects.all()
    serializer_class = StudentLoginSerializer

    def post(self, request, *args, **kwargs):
        serializer_class = StudentLoginSerializer(data=request.data)
        if serializer_class.is_valid(raise_exception=True):
            return Response(serializer_class.data, status=HTTP_200_OK)
        return Response(serializer_class.errors, status=HTTP_400_BAD_REQUEST)


class Logout(generics.GenericAPIView):
    queryset = Student.objects.all()
    serializer_class = StudentLogoutSerializer

    def post(self, request, *args, **kwargs):
        serializer_class = StudentLogoutSerializer(data=request.data)
        if serializer_class.is_valid(raise_exception=True):
            return Response(serializer_class.data, status=HTTP_200_OK)
        return Response(serializer_class.errors, status=HTTP_400_BAD_REQUEST)


def index(request):
    return redirect('/api/login')