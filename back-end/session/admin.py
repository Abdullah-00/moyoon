from django.contrib import admin
from .models import Session
from .models import EnterSession


@admin.register(Session)
class SessionAdmin(admin.ModelAdmin):
    list_display = ('id', 'numOfPlayers', 'catagory_id', 'questions')


@admin.register(EnterSession)
class EnterSessionAdmin(admin.ModelAdmin):
    list_display = ('id',)



# Register your models here.
