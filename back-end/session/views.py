from django.shortcuts import render
from django.http import HttpResponse
from content.models import Category # using questions from content
# Create your views here.


def index(request):
    catagory_list = Category.objects.order_by('id')[:5]
    output = ', '.join([c.name for c in catagory_list])
    return HttpResponse(output)

def detail(request, question_id):
    return HttpResponse("You're looking at question %s." % question_id)

def results(request, question_id):
    response = "You're looking at the results of question %s."
    return HttpResponse(response % question_id)

def vote(request, question_id):
    return HttpResponse("You're voting on question %s." % question_id)