from django.shortcuts import get_object_or_404
from django.contrib.sites.shortcuts import get_current_site
from rest_framework.decorators import api_view
from rest_framework.response import Response
from accountsAPI.models import Student
from idcardrequest.models import IDCardRequest
from idcardrequest.serializers import IDCardRequestSerializer


def get_payment_status(student_code):
    student = Student.objects.get(student_code=student_code)
    return student.status  
# Assuming the payment status is stored in the 'status' field of the Student model


@api_view(['POST'])
def submit_id_card_request(request):
    student_code = request.data.get('student_code')
    payment_status = get_payment_status(student_code)  
    # Implement this function to get the payment status

    if payment_status == 1:
        id_card_request = IDCardRequest.objects.create(student_code=student_code)
        return Response({'message': 'ID card request submitted successfully'})
    else:
        return Response({'message': 'Payment status is not eligible for ID card request'})

@api_view(['GET'])
def review_id_card_requests(request):
    pending_requests = IDCardRequest.objects.filter(status='Pending')
    serialized_requests = IDCardRequestSerializer(pending_requests, many=True)
    return Response(serialized_requests.data)

@api_view(['POST'])
def process_id_card_request(request, request_id):
    id_card_request = get_object_or_404(IDCardRequest, id=request_id)
    id_card_request.status = request.data.get('status')
    id_card_request.save()
    return Response({'message': 'ID card request processed successfully'})

@api_view(['GET'])
def id_card_data(request, student_code):
    student_code = student_code.replace('_', '/')
    student = get_object_or_404(Student, student_code=student_code)
    
    if student.status == '1':
        id_card_request = IDCardRequest.objects.filter(student_code=student_code).first()

        if id_card_request and id_card_request.status != 'Pending':
            # Send the student's data to the frontend
            data = {
                'programme': student.programme,
                'name': student.name(),
                'student_code': student.student_code,
                'signature': student.signature,
                'exp_date': student.expdate.strftime('%Y-%m-%d'),
                'avatar_url': request.build_absolute_uri(student.avatar.url),
                'payment_status': 'Paid',
            }

            # Get the base URL of the media folder where QR code images are saved
            media_url = f"{request.scheme}://{get_current_site(request).domain}/media/"

            # Append the QR code image URL based on the student's student_code
            qrcode_filename = student.student_code.replace('/', '_') + '.png'
            qrcode_url = f"{media_url}Qr-Images/{qrcode_filename}"
            data['qrcode_url'] = qrcode_url

            return Response(data)
    
    return Response()
