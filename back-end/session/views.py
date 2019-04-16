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
        x = createSessionByCategory(query_set,True)

        # Questions coming from User
    elif(request.method == 'POST'):

        data = json.loads(request.body)
        is_signed_in = data.get('is_signed_in', None)

        if(is_signed_in == "True"):
            creator_id = data.get('creator_id', None)
        else:
            creator_id = randomString()

        temp = data.get('Questions', None)
        round_limit = data.get('round_limit', None)
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
        x = createSessionWithUserInput(query_set, int(round_limit))

        # delete questions if creater asked to
        is_sharable = data.get('is_sharable', None)
        if(is_sharable.lower() == "false"):
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
    if(session_id != None):
        if(checkAddPlayer(session_id)):
            x = addPlayers(session_id, nick_name)
            return HttpResponse(x.id)
        else:
            return HttpResponse("Cannot get you inside the session.")
    else:
        category = request.GET.get('category')
        query_set = Category.objects.get(name=category)
        questions = Question.objects.filter(Category_parent=query_set)
        x = searchForSession(nick_name,questions)
        if (checkNumberOfPlayers(x[1].id)):
            t = Thread(target=SecondControllerView, args=(x[1].id,))
            t.start()
        return HttpResponse(x[0].id+","+x[1].id)

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
    answer2 = answer.strip()
    answer2 = answer2.lower()
    correct_answer = isCorrctAnswer(session_id, round_id, question_id)
    correct_answer = correct_answer.lower().strip()
    if(answer2 == correct_answer):
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
    answer2 = answer.strip()
    answer2 = answer2.lower()
    correct_answer = isCorrctAnswer(session_id, round_id, question_id)
    correct_answer = correct_answer.lower().strip()
    if (answer2 == correct_answer):
        # Add 10 points to the Player
        incrementPlayerScore(session_id, player_id, 10)
        return HttpResponse("Done Submit choice")
    else:
        # subtract 10 points
        decrementPlayerScore(session_id, player_id, 10)
        incrementAuthorScore(session_id, round_id, question_id, player_id, answer)
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

#Link: http://127.0.0.1:8000/leaveSession/?session_id=CSC8hsgaLCwz6OcLmblN&player_id=9fCmtNjkb0OavZX8mdYO&answer=7
def leaveSession(request):
    player_id = request.GET.get('player_id')
    session_id = request.GET.get('session_id')
    leaveController(player_id, session_id)

    return HttpResponse('Done')

def addQuestions(request):
    category_name = ["Linux Command Line", "Capital Cities", "Networking Port numbers"]
    category_name_ar = ["سطر أوامر لينكس" , "عواصم الدول" , "أرقام منافذ الشبكات"]
    for i in range(len(category_name)):
        temp = Category.objects.create(name=category_name[i], name_ar=category_name_ar[i], age_rating="+10", difficulty=5)
        temp.save()
    #
    question_name = ["What is the port number used by SSH?", "What is the port number used by HTTPS?", "What is the port number used by Telnet?", "What is the port number used by SMTP?", "What is the port number used by HTTP?", "What is the port number used by DNS?", "What is the port number used by TFTP?", "What is the port number used by POP3?", "What is the port number used by IMAP4?"]
    question_name_ar = ["ما هو رقم المنفذ المستخدم بـ SSH؟", "ما هو رقم المنفذ المستخدم بـ HTTPS؟", "ما هو رقم المنفذ المستخدم بـ Telnet؟", "ما هو رقم المنفذ المستخدم بـ SMTP؟", "ما هو رقم المنفذ المستخدم بـ HTTP؟", "ما هو رقم المنفذ المستخدم بـ DNS؟", "ما هو رقم المنفذ المستخدم بـ TFTP؟", "ما هو رقم المنفذ المستخدم بـ POP3؟", "ما هو رقم المنفذ المستخدم بـ IMAP4؟"]
    question_correct_answer = ["22", "443", "23", "25", "80", "53", "69", "110", "143"]
    #
    category = Category.objects.filter(name="Networking Port numbers")
    for i in range(len(question_name)):
        temp = Question.objects.create(name= question_name[i], name_ar= question_name_ar[i], age_rating="+10", Correct_answer= question_correct_answer[i], difficulty=5, Category_parent=category[0])
        temp.save()
    #
    ####
    question_name = ["What is the command to list files?", "What is the command to show the system's date?", "What is the command to show the system's uptime?", "What is the command to show your username?", "What is the command to change directory?", "What is the command to show the environment variables?", "What is the command to create a new directory?", "What is the command to show memory and swap usage?", "what is the command to show realtime info about processes?"]
    question_name_ar = ["ما هو الأمر المستخدم لإظهار قائمة الملفات؟", "ما هو الأمر المستخدم لإظهار التاريخ المسجل بالنظام؟", "ما هو الأمر المستخدم لإظهار الوقت المنقضي منذ تشغيل النظام؟", "ما هو الأمرالمستخدم لإظهار اسم المستخدم؟", "ما هو الأمر المستخدم لتغيير المجلد؟", "ما هو الأمر المستخدم لإظهار متغيرات البيئة الحالية؟", "ما هو الأمر المستخدم لخلق مجلد جديد؟", "ما هو الأمر المستخدم لإظهار إستخدام الذاكرة و التبديل؟", "ما هو الأمر المستخدم لإظهار معلومات بوقت قصير عن المهام؟"]
    question_correct_answer = ["ls", "date", "uptime", "whoami", "cd", "env", "mkdir", "free", "top"]
    #
    category = Category.objects.filter(name="Linux Command Line")
    for i in range(len(question_name)):
        temp = Question.objects.create(name= question_name[i], name_ar= question_name_ar[i], age_rating="+10", Correct_answer= question_correct_answer[i], difficulty=5, Category_parent=category[0])
        temp.save()
    ####
    question_name = ["What is the capital city of Saudi Arabia?", "What is the capital city of Bahrain?", "What is the capital city of Kuwait?", "What is the capital city of France?", "What is the capital city of United Kingdom?", "What is the capital city of Russia?", "What is the capital city of India?", "What is the capital city of Malaysia?", "What is the capital city of China?"]
    question_name_ar = ["ما هي عاصمة السعودية؟", "ما هي عاصمة البحرين؟", "ما هي عاصمة الكويت؟", "ما هي عاصمة فرنسا؟", "ما هي عاصمة المملكة المتحدة؟", "ما هي عاصمة روسيا؟", "ما هي عاصمة الهند؟", "ما هي عاصمة ماليزيا؟", "ما هي عاصمة الصين؟"]
    question_correct_answer = ["Riyadh", "Manama", "Kuwait", "Paris", "London", "Moscow", "New Delhi", "Kuala Lumpur", "Beijing"]
    #
    category = Category.objects.filter(name="Capital Cities")
    for i in range(len(question_name)):
        temp = Question.objects.create(name= question_name[i], name_ar= question_name_ar[i], age_rating="+10", Correct_answer= question_correct_answer[i], difficulty=5, Category_parent=category[0])
        temp.save()
    return HttpResponse("Done")


    