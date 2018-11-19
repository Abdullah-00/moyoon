from django.db import models
from datetime import datetime
from django.contrib.auth.models import (AbstractBaseUser, BaseUserManager)
from django.contrib.auth.models import PermissionsMixin
from django.utils.functional import cached_property

# Create your models here.

"""
Class Player with its field 
@author 
Khalifah
"""

class UserManager(BaseUserManager):
    def create_user(self, email, nick_name, password=None):
        """
        Creates and saves a User with the given email, password.
        """
        if not email:
            raise ValueError('Users must have an email address')

        user = self.model(
            email=email,
        )

        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, nick_name, password):
        """
        Creates and saves a superuser with the given email, date of
        birth and password.
        """
        user = self.create_user(
            email,
            password=password,
        )
        user.is_superuser = True
        user.is_staff = True
        user.save(using=self._db)
        return user

class User(AbstractBaseUser, PermissionsMixin):
    nick_name = models.CharField(max_length=150, unique=False, blank=False)
    password = models.CharField(max_length=100, null= False)
    email = models.EmailField(max_length=100, unique=True, blank=False, null=False)
    is_active = models.BooleanField(default=True)
    is_superuser = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    registration_date = models.DateTimeField(default=datetime.now, blank=True)

    objects = UserManager()

    USERNAME_FIELD = 'email'

"""
Class Player with its field 
@author 
Khalifah
"""
class Player(User):
    comulative_score = models.IntegerField()
    current_score = models.IntegerField()
    number_of_games = models.IntegerField()
    number_of_wins = models.IntegerField()
    level = models.IntegerField()
    number_of_loose = models.IntegerField()

    def updateComulativeScore(self, score):
        self.comulative_score += score

    def updateCurrentScore(self, score):
        self.current_score = score

    def updateNumberOfGamse(self, game):
        self.number_of_games += game

    def updateLevel(self, level):
        self.level = level

    def updateNumberOfWins(self, win):
        self.number_of_wins += win

