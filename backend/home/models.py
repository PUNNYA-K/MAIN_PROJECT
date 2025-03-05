from django.db import models
from django.core.validators import MinLengthValidator
from django.contrib.auth.hashers import make_password

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

    def save(self, *args, **kwargs):
        if not self.password.startswith("pbkdf2_") and not self.password.startswith("argon2$"):
            self.password = make_password(self.password)  # Ensuring hashing before saving
        super().save(*args, **kwargs)
