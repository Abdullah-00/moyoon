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

# Link: http://127.0.0.1:8000/session/?numOfPlayers=101&catagory_id=6&is_provided=False&questions=jhcusgcziu
# returns session ID
#
def createSessionView(request):
    #numOfPlayers = request.GET.get('numOfPlayers')
    catagory_id = request.GET.get('catagory_id')
    is_provided = request.GET.get('is_provided')
    questions = request.GET.get('questions')
    if(is_provided=="False"):
        array = Question.objects.filter(Category_parent=catagory_id)
        x = createSessionByCategory(catagory_id, is_provided, array)
    else:
        array = []
    
    return HttpResponse(x.id)

# Link: http://127.0.0.1:8000/enterSession/?session_id=CSC8hsgaLCwz6OcLmblN&nick_name=mo3sw
# returns player ID
#
def enterSessionView(request):
    nick_name = request.GET.get('nick_name')
    session_id = request.GET.get('session_id')
    if(checkAddPlayer(session_id)):
        x = addPlayers(session_id, nick_name)
        return HttpResponse(x.id)
    else:
        return HttpResponse("Cannot get you inside the session.")

#TC1:
#   Link: http://127.0.0.1:8000/SubmitAnswer/?session_id=CSC8hsgaLCwz6OcLmblN&round_id=1&question_id=1&player_id=9fCmtNjkb0OavZX8mdYO&answer=6
#   update player score
#TC2:
#   Link: http://127.0.0.1:8000/SubmitAnswer/?session_id=CSC8hsgaLCwz6OcLmblN&round_id=1&question_id=1&player_id=9fCmtNjkb0OavZX8mdYO&answer=7
#   Add answer to Wrong answer list
def SubmitAnswerView(request):
    player_id = request.GET.get('player_id')
    session_id = request.GET.get('session_id')
    round_id = request.GET.get('round_id')
    question_id = request.GET.get('question_id')
    answer = request.GET.get('answer')
    correct_answer = isCorrctAnswer(session_id, round_id, question_id)
    if(answer == correct_answer):
        # Add 5 points to the player
        incrementPlayerScore(session_id, player_id, 5)
        return HttpResponse("Done")
    else:
        # Add answer to wrong answer list
        createWrongAnswer(session_id, player_id, round_id, question_id, answer)
        return HttpResponse("wrong answer submitted")

def SubmitAnswerChoiceView(request):
    player_id = request.GET.get('player_id')
    session_id = request.GET.get('session_id')
    round_id = request.GET.get('round_id')
    question_id = request.GET.get('question_id')
