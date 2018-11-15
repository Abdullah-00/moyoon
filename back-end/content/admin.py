from django.contrib import admin
from .models import Category
from .models import Question

# Register your models here.

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'name_ar')

@admin.register(Question)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'name_ar')