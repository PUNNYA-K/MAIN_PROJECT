import uuid
from django.db import models
from django.core.validators import MinLengthValidator
from django.contrib.auth.hashers import make_password
from django.contrib.auth.models import User
from django.contrib.auth import get_user_model
class Person(models.Model):
    class Types(models.TextChoices):
        PERSON = "USER", "User"
        OWNER = "ADMIN", "Admin"

    role = models.CharField(max_length=10, choices=Types.choices, default=Types.PERSON)
    username = models.CharField(max_length=300, unique=True)
    email = models.EmailField(unique=True, blank=True, null=True)  # Optional for Owner
    password = models.CharField(max_length=300, validators=[MinLengthValidator(8)])

    ad_id = models.AutoField(primary_key=True) 

    def __str__(self):
        return f"{self.username} ({self.role})"


class Words(models.Model):
    word = models.CharField(max_length=255, unique=True)
    grammatical_category = models.CharField(max_length=100, blank=True, null=True)  # e.g., noun, verb, adjective
    phonetics = models.CharField(max_length=255, blank=True, null=True)
    translation = models.CharField(max_length=255, blank=True, null=True)  # Tamil → Malayalam
    meaning = models.TextField(blank=True, null=True)
    example_sentence = models.TextField(blank=True, null=True)  # Usage in a sentence
    synonyms = models.TextField(blank=True, null=True)  # Comma-separated words
    antonyms = models.TextField(blank=True, null=True)
    # Additional Fields
    
    # pronunciation_audio = models.FileField(upload_to="pronunciations/", blank=True, null=True)  # Audio file for pronunciation
    transliteration = models.CharField(max_length=255, blank=True, null=True)
    added_on = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return self.word

class FavoriteWord(models.Model):
    user = models.ForeignKey(Person, on_delete=models.CASCADE)
    word = models.CharField(max_length=255)
    meaning = models.TextField()  # Store word meaning if needed
    created_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ('user', 'word')  # Prevent duplicate favorites

    def __str__(self):
        return f"{self.user.email} - {self.word}"


class SearchHistory(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)
    word = models.CharField(max_length=255)
    search_time = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f'{self.user.username} searched {self.word}'