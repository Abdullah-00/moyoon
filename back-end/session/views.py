from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader
from . import models
from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from . import serializers
from Random.Firebase_python_DataInsertion.FireBasePythonInsertion import createSession


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
    createSession("123", "123", False, "123")

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
    session = Session(request.GET)
    if session.is_valid():
        numOfPlayers = session.cleaned_data('numOfPlayers')
        catagory_id = session.cleaned_data('catagory_id')
        is_provided = session.cleaned_data('is_provided')
        questions = session.cleaned_data('questions')
        createSession(100,"123",False,"123")
    return HttpResponse(template.render(context, request))

class sessionTestAPIView(APIView):
    def get(self, request, format=None):
        an_apiview = [

        ]

    def post(self, request):
        """Create a hello message with our name."""

        serializer = serializers.HelloSerializer(data=request.data)

        if serializer.is_valid():
            name = serializer.data.get('name')
            message = 'Hello {0}!'.format(name)
            return Response({'message': message})
        else:
            return Response(
                serializer.errors, status=status.HTTP_400_BAD_REQUEST)