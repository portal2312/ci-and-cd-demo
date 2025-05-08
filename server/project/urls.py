"""Root urls."""

from django.conf import settings
from django.contrib import admin
from django.contrib.auth import views as auth_views
from django.urls import include, path
from django.views.decorators.csrf import csrf_exempt
from strawberry.django.views import AsyncGraphQLView

from .schema import schema

urlpatterns = [
    path("admin/", admin.site.urls),
    path("", include("blog.urls")),
    path("accounts/login/", auth_views.LoginView.as_view(), name="login"),
    path("accounts/logout/", auth_views.LogoutView.as_view(), name="logout"),
]

if settings.DEBUG:
    urlpatterns += [
        path("graphql/", csrf_exempt(AsyncGraphQLView.as_view(schema=schema))),
    ]
else:
    urlpatterns += [
        path("graphql/", AsyncGraphQLView.as_view(schema=schema)),
    ]
