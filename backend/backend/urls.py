from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('home.urls')),
    



    # path('token/',TokenObtainPairView.as_view(),name='token_obtain_pair'),
    # path('token/refresh/',TokenRefreshView.as_view(),name='token_refresh'),


]