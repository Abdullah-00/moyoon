"""untitled URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/2.1/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.contrib import admin
from django.urls import path
from session import views



urlpatterns = [
    path('admin/', admin.site.urls),
<<<<<<< HEAD
    # route on main page, calls index method on session.views class
    path('session/', views.index, name='index'),
    # ex: /session/5/
    path('<int:question_id>/', views.detail, name='detail'),
    # ex: /session/5/results/
    path('<int:question_id>/results/', views.results, name='results'),
    # ex: /session/5/vote/
    path('<int:question_id>/vote/', views.vote, name='vote'),
=======

>>>>>>> 0045e494d773529b01e0fecbe158f810ce0a7290
]
