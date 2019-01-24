from django.shortcuts import render
from django.http import HttpResponse, JsonResponse
from django.template import loader
from . import models
from content.models import Question
from rest_framework import viewsets
from content.models import QuestionTmp
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from . import serializers
from Random.Firebase_python_DataInsertion.FireBasePythonInsertion import *
import json
from threading import Thread



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

# Link: http://127.0.0.1:8000/session/?catagory_id=6&is_provided=False&questions=jhcusgcziu
# returns session ID
#


def createSessionView(request):

# Questions coming from Question Table
    is_provided = request.GET.get('is_provided')
    if(is_provided=="False"):
        catagory_id = request.GET.get('catagory_id')
        query_set = Question.objects.filter(Category_parent=catagory_id)
        x = createSessionByCategory(query_set)

        # Questions coming from User
    elif(request.method == 'POST'):

        data = json.loads(request.body)
        is_signed_in = data.get('is_signed_in', None)

        if(is_signed_in == "True"):
            creator_id = data.get('creator_id', None)
        else:
            creator_id = randomString()

        temp = data.get('Questions', None)

# loop through provided questions
        for i in temp:
            name = i['name']
            name_ar = i['name_ar']
            Correct_answer = i['Correct_answer']
            difficulty = i['difficulty']
            age_rating = i['age_rating']
            #  add questions to QuestionTmp
            new_question = QuestionTmp.objects.create(creator_id=creator_id,name=name, name_ar=name_ar, Correct_answer=Correct_answer, difficulty=difficulty,age_rating=age_rating)
            new_question.save()
        query_set = QuestionTmp.objects.filter(creator_id=creator_id)
        x = createSessionByCategory(query_set)

        # delete questions if creater asked to
        is_sharable = data.get('is_sharable', None)
        if(is_sharable == "False"):
            query_set.delete()

    return HttpResponse(x.id)

def chooseCategoryView(request):
    array = Category.objects.filter(parent__isnull=False)
    data2 = []
    for i in array:
        data = {
            u'id' : i.id,
            u'name' : i.name,
            u'name_ar' : i.name_ar
        }
        data2.append(data)
    return HttpResponse(data2)

# Link: http://127.0.0.1:8000/enterSession/?session_id=CSC8hsgaLCwz6OcLmblN&nick_name=mo3sw
# returns player ID
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
    answer = request.GET.get('answer')
    correct_answer = isCorrctAnswer(session_id, round_id, question_id)
    if (answer == correct_answer):
        # Add 10 points to the Player
        incrementPlayerScore(session_id, player_id, 10)
        return HttpResponse("Done Submit choice")
    else:
        # subtract 10 points
        decrementPlayerScore(session_id, player_id, 10)
        incrementAuthorScore(session_id, round_id, question_id, answer)
        return HttpResponse("Done Submit wrong choice")

def SecondControllerView(session_id):
    
    changeAddplayers(session_id)
    x = gameController(session_id)
    str = "Game Ended ",x[0]," ",x[1]
    

def controllerView(request):
    session_id = request.GET.get('session_id')
    t = Thread(target=SecondControllerView, args=(session_id, ))
    t.start()
    return HttpResponse("Game Ended")