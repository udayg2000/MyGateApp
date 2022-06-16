from django.contrib import admin
from django.urls import path, include
# For setting up MEDIA ROOT
from django.conf import settings
from django.conf.urls.static import static
from rest_framework.authtoken import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include('api.urls')),
    path('api-token-auth/', views.obtain_auth_token, name='api-token-auth'),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL,document_root=settings.MEDIA_ROOT)
