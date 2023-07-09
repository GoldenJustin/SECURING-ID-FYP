from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response
from accountsAPI.models import Student
from accountsAPI.serializers import StudentSerializer

# @api_view(['POST'])
# def new_id_request(request, student_code):
#     try:
#         student = Student.objects.get(student_code=student_code)
#     except Student.DoesNotExist:
#         return Response({'message': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)

#     serializer = StudentSerializer(student, data=request.data, partial=True)
#     if serializer.is_valid():
#         student = serializer.save()
#         if student.status == '1':
#             # Perform any additional actions here for ID approval
#             return Response({'message': 'ID request approved'}, status=status.HTTP_200_OK)
#         else:
#             return Response({'message': 'ID request submitted but not approved'}, status=status.HTTP_200_OK)
#     else:
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

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

