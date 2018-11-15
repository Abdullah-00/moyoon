from rest_framework import serializers
from .models import User
from .models import Player


class UserSerializer(serializers.ModelSerializer):

    class Meta:
        model = User
        fields = ('__all__')

class PlayerSerializer(serializers.ModelSerializer):

    class Meta:
        model = Player
        fields = ('__all__')
