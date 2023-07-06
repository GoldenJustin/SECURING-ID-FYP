from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .views import decrypt_text
from accountsAPI.models import Student

@csrf_exempt
def decrypt_api(request):
    if request.method == 'POST':
        encrypted_data = request.POST.get('encrypted_data')
        
        if encrypted_data:
            decrypted_data = decrypt_text(encrypted_data)

            # Convert the decrypted student code to the format used in the database
            student_code = decrypted_data.replace('_', '/')

            try:
                # Fetch student information from the database using the converted student code
                student = Student.objects.get(student_code=student_code)
                data = {
                    'programme': student.programme,
                    'name': student.name(),
                    'student_code': student.student_code,
                    'signature': student.signature,
                    'exp_date': student.expdate.strftime('%Y-%m-%d')
                }

                response = {
                    'data': data
                }
                return JsonResponse(response)
            except Student.DoesNotExist:
                response = {
                    'error': 'Student not found'
                }
                return JsonResponse(response)

    response = {
        'error': 'Invalid request'
    }
    return JsonResponse(response)
