from django.shortcuts import render
from content.models import Category
import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore
from django.http import HttpResponse
import requests



# cred = credentials.Certificate({
#     "type": "service_account",
#     "project_id": "moyoon-abikmmr",
#     "private_key_id": "***REMOVED***",
#     "private_key": "***REMOVED***",
#     "client_email": "firebase-adminsdk-x7woa@moyoon-abikmmr.iam.gserviceaccount.com",
#     "client_id": "108089772069529574197",
#     "auth_uri": "https://accounts.google.com/o/oauth2/auth",
#     "token_uri": "https://oauth2.googleapis.com/token",
#     "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
#     "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-x7woa%40moyoon-abikmmr.iam.gserviceaccount.com"
# })
# firebase_admin.initialize_app(cred, {
#     'projectId': "moyoon-abikmmr",
# })

db = firestore.client()


def index(request):
    catagory_list = Category.objects.order_by('id')[:5]
    context = {
        'catagory_list': catagory_list,
    }
    return render(request, 'shared_screen/index.html', context)

sessions = db.collection(u'Session')
sessions_docs = sessions.get()

# for doc in sessions_docs:
#     print(u'{} => {}'.format(doc.id, doc.to_dict()))

def create(request):
    catID = 6
    if 'category' in request.GET:
        catID = request.GET['category']
        message = 'Category id is: %r' % request.GET['category']
    else:
        message = 'You submitted an empty form.'

    global session_id
    session_id = requests.get('http://68.183.67.247:8000/session/?catagory_id=' + catID +'&is_provided=False&questions=').text

    context = {
        'session_id': session_id,
    }
    return render(request, 'shared_screen/lobby.html', context)


def customSession(request):
    catagory_list = Category.objects.order_by('id')[:5]
    context = {
        'catagory_list': catagory_list,
    }
    return render(request, 'shared_screen/customSession.html', context)

def start(request):
    s = requests.get('http://68.183.67.247:8000/beginGame/?session_id=' + session_id)
    context = {
        'session_id': session_id,
    }
    return render(request, 'shared_screen/leaderboard.html', context)

def createCS(request):
    post_data = request.POST
    print(post_data)
    global session_id
    session_id = requests.post('http://68.183.67.247:8000/session/', data=post_data).text

    context = {
        'session_id': session_id,
    }
    return render(request, 'shared_screen/lobby.html', context)
