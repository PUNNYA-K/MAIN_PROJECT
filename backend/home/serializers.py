from rest_framework import serializers

from .models import Person

class PersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = ["ad_id", "username", "email", "password", "role"]  # Replace "id" with "ad_id"
        extra_kwargs = {"password": {"write_only": True}}  # Hide password in response

    def create(self, validated_data):
        validated_data["password"] = validated_data["password"]
        return super().create(validated_data)

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(max_length=150)
    password = serializers.CharField(write_only=True)

    def validate(self, data):
        username = data.get("username")
        password = data.get("password")

        if not username or not password:
            raise serializers.ValidationError("Both username and password are required.")

        return data
