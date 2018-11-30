
from rest_framework import serializers
from .models import Session
from .models import EnterSession
from .models import SubmitAnswer
from .models import SubmitAnswerChoice
from Random.Firebase_python_DataInsertion.FireBasePythonInsertion import createSession


class SessionSerializer(serializers.ModelSerializer):

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
