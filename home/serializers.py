from pyparsing import Word
from rest_framework import serializers
from django.contrib.auth.hashers import make_password

from rest_framework_simplejwt.serializers import TokenObtainPairSerializer

from .models import FavoriteWord, SearchHistory, Words
from home.models import Person

class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token["username"] = user.username
        token["email"] = user.email
        token["role"] = user.role  # Ensure role exists in the model
        return token

class PersonSerializer(serializers.ModelSerializer):
    class Meta:
        model = Person
        fields = ["username", "email", "password", "role"]

    def create(self, validated_data):
        validated_data["password"] = make_password(validated_data["password"])  # Hash before saving
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
    

# class PersonSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = Person
#         fields = ['ad_id', 'username', 'email', 'role']



       

class WordSerializer(serializers.ModelSerializer):
    class Meta:
        model = Words
        fields = '__all__' 


class FavoriteWordSerializer(serializers.ModelSerializer):
    class Meta:
        model = FavoriteWord
        fields = ['word', 'meaning']





class SearchHistorySerializer(serializers.ModelSerializer):
    class Meta:
        model = SearchHistory
        fields = ['word', 'search_time']  


        
class WordsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Words
        fields = [
            "word", "grammatical_category", "phonetics", "translation",
            "meaning", "example_sentence", "synonyms", "antonyms",
            "added_on"  # Ensure all required fields are included
        ]

             