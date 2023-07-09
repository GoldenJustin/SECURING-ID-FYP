from rest_framework import serializers
from accountsAPI.models import Student

class IDCardRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = Student
        fields = '__all__'