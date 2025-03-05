from django.urls import path
from .views import   login_view, profile_view
from .views import register_view


urlpatterns = [
    path("register/", register_view, name="register"), 
    path("login/", login_view, name="login"),
    path('api/profile/<str:username>/', profile_view, name='profile'),
    # path("person/<int:pk>/", person_detail, name="person-detail")]
]