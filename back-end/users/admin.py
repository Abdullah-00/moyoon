from django.contrib import admin
from .models import User
from .models import Player

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('id', 'nick_name', 'email')


@admin.register(Player)
class PlayerAdmin(admin.ModelAdmin):
    list_display = ('id', 'nick_name', 'email')


