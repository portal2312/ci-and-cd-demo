from django.urls import path

from . import views

urlpatterns = [
    path("", views.home),
    path("new/", views.create_post),
    path("<int:pk>/", views.post_detail),
    path("edit/<int:pk>/", views.edit_post),
    path("delete/<int:pk>/", views.delete_post),
]
