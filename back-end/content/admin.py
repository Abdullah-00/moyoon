from django.contrib import admin
from .models import Category, CategoryTmp, QuestionTmp
from .models import Question
#from .models import QuestionImage


# Register your models here.

@admin.register(Category)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'name_ar')

@admin.register(Question)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'name_ar','question_image','Category_parent')


@admin.register(CategoryTmp)
class CategoryAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'name_ar')

@admin.register(QuestionTmp)
class QuestionAdmin(admin.ModelAdmin):
    list_display = ('id', 'name', 'name_ar', 'creator_id','Category_parent','is_approved','disapproved')
    list_editable = ('is_approved','disapproved','Category_parent')
    list_filter = ('is_approved',)
    list_max_show_all = 25

# @admin.register(QuestionImage)
# class QuestionImageAdmin(admin.ModelAdmin):
#     list_display = ('id','Question')