from django.contrib import admin
from .models import Category
from .models import Question
#from .models import QuestionImage


# Register your models here.

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'name_ar')

@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'name_ar')

# @admin.register(QuestionImage)
# class QuestionImageAdmin(admin.ModelAdmin):
#     list_display = ('id','Question')