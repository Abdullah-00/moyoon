
from rest_framework import serializers
from .models import Session
from .models import EnterSession
from .models import SubmitAnswer
from .models import SubmitAnswerChoice


class SessionSerializer(serializers.ModelSerializer):
    numOfPlayers = serializers.IntegerField(default=0)
    catagory_id = serializers.IntegerField(default=0)
    is_provided = serializers.BooleanField(default=False)
    questions = serializers.CharField()
    class Meta:
        model = Session
        fields = ('__all__')



class EnterSessionSerializer(serializers.ModelSerializer):

    class Meta:
        model = EnterSession
        fields = ('__all__')

class SubmitAnswerSerializer(serializers.ModelSerializer):

    class Meta:
        model = SubmitAnswer
        fields = ('__all__')

class SubmitAnswerChoiceSerializer(serializers.ModelSerializer):

    class Meta:
        model = SubmitAnswerChoice
        fields = ('__all__')
