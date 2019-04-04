from django.conf.urls import url
from django.urls import path
from . import views


urlpatterns = [
    url(r'^$', views.index, name='index'),
    path('create', views.create, name='create'),
    path('create/', views.create, name='create'),
    path('start/', views.start, name='start'),
    path('customSession.html/createCS/start/', views.start, name='start'),
    path('customSession.html/', views.customSession, name='customSession'),
    path('customSession.html/createCS/', views.createCS, name='createCS'),
]

