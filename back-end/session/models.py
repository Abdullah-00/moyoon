from django.db import models
from content.models import Question as Ques
from rest_framework import serializers
from Random.Firebase_python_DataInsertion.FireBasePythonInsertion import *



class Session(models.Model):
    numOfPlayers = models.IntegerField(default=0)
    catagory_id = models.IntegerField(default=0)
    is_provided = models.BooleanField(default= False)
    questions = models.TextField() # JSON OF Questions to insert directly to firebase ??
    #createSession(numOfPlayers, catagory_id, is_provided, questions)

# Create your models here.

class EnterSession(models.Model):
    session_id = models.TextField(max_length = 255, blank = False, null = False)
    Player_NickName = models.TextField(max_length = 255, blank = False, null = False)

class SubmitAnswer(models.Model):
    session_id = models.TextField(max_length=255, blank=False, null=False)
    question_id = models.TextField(max_length=255, blank=False, null=False)
    Answer = models.TextField(max_length=255, blank=False, null=False)

class SubmitAnswerChoice(models.Model):
    session_id = models.TextField(max_length=255, blank=False, null=False)
    question_id = models.TextField(max_length=255, blank=False, null=False)
    Answer_id = models.TextField(max_length=255, blank=False, null=False)