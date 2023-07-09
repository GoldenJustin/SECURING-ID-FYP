from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from accountsAPI.models import Student
from accountsAPI.serializers import StudentSerializer
from django.core.files.storage import default_storage
from django.conf import settings
from django.shortcuts import render


@api_view(['GET'])
def new_id_request(request, student_code):
    try:
        student = Student.objects.get(student_code=student_code.replace('_', '/'))
    except Student.DoesNotExist:
        return Response({'message': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)

    if student.status == '0':
        return Response({'message': 'ID request pending'}, status=status.HTTP_200_OK)
    elif student.status == '1':
        serializer = StudentSerializer(student)
        return Response(serializer.data, status=status.HTTP_200_OK)
    else:
        return Response({'message': 'Invalid payment status'}, status=status.HTTP_400_BAD_REQUEST)
    
    

@api_view(['POST'])


def upload_file(request, student_code):
    # Retrieve student and other information

    file_description = request.data.get('file_description')
    uploaded_file = request.FILES.get('file')

    # Save the uploaded file to a specific location
    file_path = f'media/uploads/{student_code}/{uploaded_file.name}'  # Set the desired file path
    saved_file_path = default_storage.save(file_path, uploaded_file)

    # Retrieve the URL of the saved file
    file_url = request.build_absolute_uri(saved_file_path)

    # Perform any necessary actions with the saved file URL
    # Update the student's information, create a database entry, etc.

    return Response({'message': 'File uploaded successfully'})


def view_uploaded_image(request):
    # Construct the URL based on the file path
    file_path = '/media/uploads/example.jpg'  # Replace with the actual file path
    image_url = settings.MEDIA_URL + file_path

    context = {'image_url': image_url}
    return render(request, 'index.html', context)


