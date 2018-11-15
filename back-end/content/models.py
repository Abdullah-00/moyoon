from django.db import models
from datetime import datetime
from django.db import models
from django.core.validators import MaxValueValidator




class Category(models.Model):
    representation = models.CharField(max_length=150, unique=True, null=False)
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
