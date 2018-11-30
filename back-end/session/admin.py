from django.contrib import admin
from .models import Session

@admin.register(Session)
class SessionAdmin(admin.ModelAdmin):
    list_display = ('id', 'numOfPlayers', 'catagory_id', 'questions')


# Register your models here.
