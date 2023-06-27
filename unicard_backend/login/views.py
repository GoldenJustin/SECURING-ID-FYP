from django.http import HttpResponse
from django.shortcuts import redirect, get_object_or_404
from rest_framework import generics
from rest_framework.response import Response
from rest_framework.status import HTTP_200_OK, HTTP_400_BAD_REQUEST
from .models import Student, Staff
from .serializers import *
from rest_framework.decorators import api_view


class StudentAPIView(generics.CreateAPIView):
    queryset = Student.objects.all()
    serializer_class = StudentSerializer

class StaffAPIView(generics.CreateAPIView):
    queryset = Staff.objects.all()
    serializer_class = StaffSerializer

class UserLoginAPIView(generics.GenericAPIView):
    serializer_class = UserLoginSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(serializer.validated_data, status=HTTP_200_OK)

class UserLogoutAPIView(generics.GenericAPIView):
    serializer_class = UserLogoutSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        return Response(serializer.validated_data, status=HTTP_200_OK)

def index(request):
    return redirect('/api/login')


@api_view(['GET'])
def get_student_memory(request, student_code):
    student_code = student_code.replace('_', '/')  
    # Convert underscores back to slashes
    student = get_object_or_404(Student, student_code=student_code)
    data = {
        'programme': student.programme,
        'name': student.name(),
        'student_code': student.student_code.replace('/', '_'),  
        # Convert slashes to underscores
        'signature': student.signature,
        'exp_date': student.expdate.strftime('%Y-%m-%d')
    }
    return Response(data)



