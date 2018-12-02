from django.shortcuts import render

# Create your views here.

#import pyrebase from django.shortcuts import render


config = {
    'apiKey': "***REMOVED***",
    'authDomain': "moyoon-abikmmr.firebaseapp.com",
    'databaseURL': "https://moyoon-abikmmr.firebaseio.com",
    'projectId': "moyoon-abikmmr",
    'storageBucket': "moyoon-abikmmr.appspot.com",
    'messagingSenderId': "118454694024",
}
firebase = pyrebase.initialize_app(config)

db = firebase.database()
