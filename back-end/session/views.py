from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from . import models
from content.models import Question
from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from . import serializers
from Random.Firebase_python_DataInsertion.FireBasePythonInsertion import *
import json


from content.models import Category # using categories from content
# Create your views here.


def index(request):
    catagory_list = Category.objects.order_by('id')[:5]
    template = loader.get_template('session/index.html')
    context = {
        'catagory_list': catagory_list,
    }
    return HttpResponse(template.render(context, request))


def detail(request, question_id):
    return HttpResponse("You're looking at question %s." % question_id)

def results(request, question_id):
    response = "You're looking at the results of question %s."
    return HttpResponse(response % question_id)

def vote(request, question_id):
    return HttpResponse("You're voting on question %s." % question_id)

class SessionViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.SessionSerializer
    queryset = models.Session.objects.all()
    #createSession("123", "123", False, "123")

class EnterSessionViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.EnterSessionSerializer
    queryset = models.EnterSession.objects.all()


class SubmitAnswerViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.SubmitAnswerSerializer
    queryset = models.SubmitAnswer.objects.all()

class SubmitAnswerChoiceViewSet(viewsets.ModelViewSet):
    serializer_class = serializers.SubmitAnswerChoiceSerializer
    queryset = models.SubmitAnswerChoice.objects.all()

def createSessionView(request):
    numOfPlayers = request.GET.get('numOfPlayers')
    catagory_id = request.GET.get('catagory_id')
    is_provided = request.GET.get('is_provided')
    questions = request.GET.get('questions')
    if(is_provided=="False"):
        array = Question.objects.filter(Category_parent=catagory_id)
    else:
        array = []
    x = createSession(numOfPlayers, catagory_id, is_provided, array)
    return HttpResponse(x.id)