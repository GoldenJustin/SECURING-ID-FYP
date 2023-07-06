from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from .views import decrypt_text

@csrf_exempt
def decrypt_api(request):
    if request.method == 'POST':
        encrypted_data = request.POST.get('encrypted_data')
        
        if encrypted_data:
            decrypted_data = decrypt_text(encrypted_data)

            response = {
                'decrypted_data': decrypted_data
            }
            return JsonResponse(response)

    response = {
        'error': 'Invalid request'
    }
    return JsonResponse(response)
