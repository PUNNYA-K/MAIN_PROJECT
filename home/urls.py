from django.urls import path
from .views import   SearchHistoryView, WordDetailView, WordCreateAPIView, add_favorite, list_favorites, login_view, person_list, profile_view, register_view, malayalam_to_ipa, remove_favorite, user_profile
from home import views



urlpatterns = [
    path("register/", register_view, name="register"), 
    path("login/", login_view, name="login"),
    path('profile/<str:username>/', profile_view, name='profile'),
    path('persons/', person_list, name='person_list'),
    path('convert-to-ipa/', malayalam_to_ipa, name='convert_to_ipa'),
    path('user/', user_profile, name='user_profile'),
    path('word/<str:word>/', WordDetailView.as_view(), name='word-detail'),
    path('words/', views.WordListView.as_view(), name='word-list'),
    path('words/<str:word>/', views.WordDetailView.as_view(), name='word-detail'),
    path('favorites/add/', add_favorite, name='add_favorite'),
    path('favorites/list/', list_favorites, name='list_favorites'),
    path('favorites/remove/', remove_favorite, name='remove_favorite'),
    path('search-history/', SearchHistoryView.as_view(), name='search-history'),
    path('add_words/', WordCreateAPIView.as_view(), name='word-create'),
   
]