from rest_framework import serializers
from idcardrequest.models import IDCardRequest

class IDCardRequestSerializer(serializers.ModelSerializer):
    class Meta:
        model = IDCardRequest
        fields = '__all__'