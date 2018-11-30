
from rest_framework import serializers
from .models import Session


<<<<<<< HEAD
class SessionSerializer(serializers.ModelSerializer):
    numOfPlayers = serializers.IntegerField(default=0)
    catagory_id = serializers.IntegerField(default=0)
    is_provided = serializers.BooleanField(default=False)
    questions = serializers.CharField()
    class Meta:
        model = Session
        fields = ('__all__')

||||||| merged common ancestors
class SessionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Session
        fields = ('__all__')

=======
>>>>>>> e413eaa3e7eb70d3827e0beb4d5e9cb4be57f56a


class SessionSerializer(serializers.ModelSerializer):

    class Meta:
        model = Session
        fields = ('__all__')

