from django.contrib.auth.hashers import check_password
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from django.views.decorators.csrf import csrf_exempt
from rest_framework.response import Response
from rest_framework import status
from .models import Person
from .serializers import PersonSerializer

@api_view(["POST"])
@permission_classes([AllowAny])
@csrf_exempt
def register_view(request):
    """
    Handles user registration in the Person model.
    """
    try:
        serializer = PersonSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()  # No need to hash again, handled in serializer
            return Response(
                {
                    "message": "Registration successful",
                    "data": PersonSerializer(user).data
                },
                status=status.HTTP_201_CREATED
            )
        else:
            return Response({"errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        return Response(
            {"error": "Something went wrong", "details": str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(["POST"])
@permission_classes([AllowAny])
@csrf_exempt
def login_view(request):
    """
    Handles user login using the Person model instead of auth_user.
    """
    try:
        username = request.data.get("username")
        password = request.data.get("password")

        if not username or not password:
            return Response({"error": "Username and password are required"}, status=status.HTTP_400_BAD_REQUEST)

        print(f"Received login request for username: {username}")  # Debugging

        try:
            user = Person.objects.get(username=username)
            print("User found in database:", user.username)  # Debugging
        except Person.DoesNotExist:
            print("Invalid credentials: User not found")  # Debugging
            return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

        if check_password(password, user.password):
            print("Password matched successfully")  # Debugging
            return Response(
                {
                    "message": "Login successful",
                    "username": user.username
                },
                status=status.HTTP_200_OK
            )
        else:
            print("Invalid credentials: Password mismatch")  # Debugging
            return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

    except Exception as e:
        print("Exception in login:", str(e))  # Debugging
        return Response(
            {"error": "Something went wrong, try again later", "details": str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['GET'])
def profile_view(request, username):
    try:
        user = User.objects.get(username=username)
        return Response({"username": user.username})
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=404)
