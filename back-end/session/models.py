from django.db import models
from content.models import Question as Ques
class Session(models.Model):
    numOfPlayers = models.IntegerField(default=0)
    catagory_id = models.IntegerField(default=0)
    questions = models.TextField() # JSON OF Questions to insert directly to firebase ??

# Create your models here.
