from django.db import models
from django.dispatch import receiver
import os

from django.db import models
from accountsAPI.models import Student

def qr_image_upload_to(instance, filename):
    return f'Qr-Images/{instance.student.student_code.replace("/", "_")}.png'

class QRModel(models.Model):
    student = models.ForeignKey(Student, on_delete=models.CASCADE)
    qr_image = models.ImageField(upload_to=qr_image_upload_to)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"QR Code for {self.student.name()} ({self.student.student_code})"


@receiver(models.signals.post_delete, sender=QRModel)
def auto_delete_file_on_delete(sender, instance, **kwargs):
    if instance.qr_image:
        if os.path.isfile(instance.qr_image.path):
            os.remove(instance.qr_image.path)

@receiver(models.signals.pre_save, sender=QRModel)
def auto_delete_file_on_change(sender, instance, **kwargs):
    if not instance.pk:
        return False

    try:
        old_file = QRModel.objects.get(pk=instance.pk).qr_image
    except QRModel.DoesNotExist:
        return False

    new_file = instance.qr_image
    if not old_file == new_file:
        if os.path.isfile(old_file.path):
            os.remove(old_file.path)