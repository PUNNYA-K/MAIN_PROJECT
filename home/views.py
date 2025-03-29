from django.contrib.auth.hashers import make_password, check_password
from rest_framework.decorators import api_view, permission_classes,authentication_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from django.views.decorators.csrf import csrf_exempt
from rest_framework.response import Response
from rest_framework import status
from .models import Person, SearchHistory
from django.http import JsonResponse
from .serializers import PersonSerializer, CustomTokenObtainPairSerializer, SearchHistorySerializer, WordsSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework.views import APIView
import epitran
from rest_framework.response import Response
from rest_framework.decorators import api_view
import epitran
from indic_transliteration import sanscript
import logging
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework import viewsets, permissions
from rest_framework import generics
from .models import Words
from .serializers import WordSerializer
from .models import FavoriteWord
from .serializers import FavoriteWordSerializer








class CustomTokenObtainPairView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer

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
            user = serializer.save()
            return Response(
                {"message": "Registration successful", "data": PersonSerializer(user).data},
                status=status.HTTP_201_CREATED
            )
        return Response({"errors": serializer.errors}, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        return Response(
            {"error": "Something went wrong", "details": str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(["POST"])
@permission_classes([AllowAny])
def login_view(request):
    """
    Handles user login using the Person model and returns a JWT token.
    """
    try:
        username = request.data.get("username")
        password = request.data.get("password")

        if not username or not password:
            return Response({"error": "Username and password are required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            user = Person.objects.get(username=username)
        except Person.DoesNotExist:
            return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

        if check_password(password, user.password):
            refresh = RefreshToken.for_user(user)
            refresh["username"] = user.username
            refresh["email"] = user.email
            refresh["role"] = user.role  # Ensure role is returned

            return Response(
                {
                    "message": "Login successful",
                    "refresh": str(refresh),
                    "access": str(refresh.access_token),
                    "role": user.role,  # Send role back to Flutter
                },
                status=status.HTTP_200_OK
            )

        return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)

    except Exception as e:
        return Response(
            {"error": "Something went wrong, try again later", "details": str(e)},
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(["GET"])
def profile_view(request, username):
    try:
        user = Person.objects.get(username=username)
        return Response({"username": user.username, "email": user.email, "role": user.role})
    except Person.DoesNotExist:
        return Response({"error": "User not found"}, status=404)



@api_view(['GET'])
@permission_classes([AllowAny])  # This view does NOT require authentication
def person_list(request):
    users = Person.objects.exclude(role="ADMIN")
    serializer = PersonSerializer(users, many=True)
    return JsonResponse(serializer.data, safe=False)


logger = logging.getLogger(__name__)

epi = epitran.Epitran('mal-Mlym')

@api_view(['POST'])
def malayalam_to_ipa(request):
    try:
        mal_text = request.data.get('text', '').strip()

        if not mal_text:
            return Response({"error": "Text is required"}, status=400)

        # Validate if input is in Malayalam (basic check)
        if not all('\u0D00' <= char <= '\u0D7F' for char in mal_text):
            return Response({"error": "Invalid input. Only Malayalam text is allowed."}, status=400)

        # Convert to IPA
        ipa_text = epi.transliterate(mal_text)

        # Ensure conversion happened (fallback if needed)
        if not ipa_text.strip():
            logger.warning(f"Failed IPA conversion for: {mal_text}")
            return Response({"error": "Failed to convert to IPA"}, status=500)

        return Response({"ipa": ipa_text})

    except Exception as e:
        logger.error(f"Error in malayalam_to_ipa: {str(e)}")
        return Response({"error": "Internal Server Error"}, status=500)


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def user_profile(request):
    print("Authenticated User:", request.user)
    if not request.user or not request.user.is_authenticated:
        return Response({"error": "Unauthorized"}, status=401)
    
    return Response({"email": request.user.email})





class WordListView(generics.ListAPIView):
    queryset = Words.objects.all()
    serializer_class = WordSerializer

class WordDetailView(generics.RetrieveAPIView):
    queryset = Words.objects.all()
    serializer_class = WordSerializer
    lookup_field = 'word' 




@api_view(['POST'])
@permission_classes([IsAuthenticated])
def add_favorite(request):
    user = request.user
    word = request.data.get('word')
    meaning = request.data.get('meaning')

    if not word:
        return Response({"error": "Word is required"}, status=status.HTTP_400_BAD_REQUEST)

    favorite, created = FavoriteWord.objects.get_or_create(user=user, word=word, meaning=meaning)
    
    if created:
        return Response({"message": "Word added to favorites"}, status=status.HTTP_201_CREATED)
    return Response({"message": "Word is already in favorites"}, status=status.HTTP_200_OK)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def list_favorites(request):
    user = request.user
    favorites = FavoriteWord.objects.filter(user=user)
    serializer = FavoriteWordSerializer(favorites, many=True)
    return Response(serializer.data, status=status.HTTP_200_OK)

@api_view(['DELETE'])
@permission_classes([IsAuthenticated])
def remove_favorite(request):
    user = request.user
    word = request.data.get('word')

    try:
        favorite = FavoriteWord.objects.get(user=user, word=word)
        favorite.delete()
        return Response({"message": "Word removed from favorites"}, status=status.HTTP_200_OK)
    except FavoriteWord.DoesNotExist:
        return Response({"error": "Word not found in favorites"}, status=status.HTTP_404_NOT_FOUND)    


class SearchHistoryView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        user = request.user
        history = SearchHistory.objects.filter(user=user).order_by('-search_time')
        serializer = SearchHistorySerializer(history, many=True)
        return Response(serializer.data)
    


class WordCreateAPIView(APIView):
    def post(self, request):
        print("Received Data:", request.data)  # Debugging: Check received data
        
        data = request.data.copy()
        data.pop("transliteration", None)  # Ensure transliteration is not included

        serializer = WordsSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        
        print("Validation Errors:", serializer.errors)  # Debugging: Check validation errors
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) 