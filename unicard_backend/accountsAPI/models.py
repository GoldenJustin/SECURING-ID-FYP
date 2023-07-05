from django.db import models
from django.utils import timezone
from PIL import Image

class Student(models.Model):
    student_code = models.CharField(max_length=100, unique=True)
    email = models.EmailField(max_length=255, unique=True)
    password = models.CharField(max_length=50)
    ifLogged = models.BooleanField(default=False)
    token = models.CharField(max_length=500, null=True, default="")
    first_name = models.CharField(max_length=250)
    middle_name = models.CharField(max_length=250, null=True, blank=True)
    last_name = models.CharField(max_length=250)
    gender = models.CharField(max_length=50, choices=(("Male","Male"), ("Female","Female")), default="Male")
    expdate = models.DateField()
    programme = models.TextField(null=True, blank=True)
    signature = models.TextField(null=True, blank=True)
    avatar = models.ImageField(upload_to="student-avatars/", null=True, blank=True)
    date_added = models.DateTimeField(default=timezone.now)
    date_created = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.student_code} - {self.first_name} " + (f"{self.middle_name} {self.last_name}" if self.middle_name else f"{self.last_name}")

    def name(self):
        return f"{self.first_name} " + (f"{self.middle_name} {self.last_name}" if self.middle_name else f"{self.last_name}")

    def save(self, *args, **kwargs):
        super(Student, self).save(*args, **kwargs)
        if self.avatar:
            imag = Image.open(self.avatar.path)
            if imag.width > 200 or imag.height > 200:
                output_size = (200, 200)
                imag.thumbnail(output_size)
                imag.save(self.avatar.path)

    @property
    def username(self):
        return self.student_code

class Staff(models.Model):
    username = models.CharField(max_length=255, unique=True)
    email = models.EmailField(max_length=255, unique=True)
    password = models.CharField(max_length=50)
    ifLogged = models.BooleanField(default=False)
    token = models.CharField(max_length=500, null=True, default="")

    def __str__(self):
        return f"{self.username} - {self.email}"