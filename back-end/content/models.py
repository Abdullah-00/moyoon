from django.db import models
from datetime import datetime
from django.db import models
from django.core.validators import MaxValueValidator




class Category(models.Model):
    name = models.CharField(max_length=35)
    name_ar = models.CharField(max_length=35)
    age_rating = models.CharField(max_length=3)
    creator_id = models.ForeignKey('users.User', null=True,
                                   related_name='creator',
                                   on_delete=models.SET_NULL)
    difficulty = models.IntegerField(validators=[MaxValueValidator(5,'Maximum Limit is 5')])
    created_date = models.DateTimeField(default=datetime.now)

    ## To Make a one to many relation with its self

    parent = models.ForeignKey('self', on_delete=models.CASCADE, blank=True,
                               null=True)

    ## to represent the Category by the name
    def __str__(self):
            return self.name

class Question(models.Model):
    name = models.CharField(max_length=35, null=True)
    name_ar = models.CharField(max_length=35, null=True, blank=True)
    age_rating = models.CharField(max_length=3)
    Correct_answer = models.CharField(max_length=150)

    #  to get the creator ID
    creator_id = models.ForeignKey('users.User', null=True,
                                   related_name='maker',
                                   on_delete=models.SET_NULL)
    difficulty = models.IntegerField(validators=[MaxValueValidator(5, 'Maximum Limit is 5')])

    # To Belong to a Category
    parent = models.ForeignKey('content.Category', on_delete=models.CASCADE, blank=True,
                               null=True)
    photo = models.ImageField ##TODO Fix


