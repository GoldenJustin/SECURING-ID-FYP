from django.db import models
from accountsAPI.models import Student



def qr_image_upload_to(instance, filename):
    return f'Qr-Images/{instance.student_code.replace("/", "_")}.png'

class QRModel(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    qr_image = models.ImageField(upload_to=qr_image_upload_to)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.student.student_code


