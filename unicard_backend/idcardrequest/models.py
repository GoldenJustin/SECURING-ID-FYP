from django.db import models

# Create your models here.
class IDCardRequest(models.Model):
    student_code = models.CharField(max_length=50)
    status = models.CharField(max_length=20, default='Pending')
    timestamp = models.DateTimeField(auto_now_add=True)