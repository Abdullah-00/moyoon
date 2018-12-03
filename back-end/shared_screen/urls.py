from django.conf.urls import url
from django.urls import path
from . import views


urlpatterns = [
    url(r'^$', views.index, name='index'),
    path('create', views.create, name='create'),
    path('create/', views.create, name='create'),
    path('start/', views.start, name='start'),
]