import firebase_admin
import json
import time
import threading
from firebase_admin import credentials
from firebase_admin import firestore
import random

cred = credentials.Certificate({
    "type": "service_account",
    "project_id": "moyoon-abikmmr",
    "private_key_id": "***REMOVED***",
    "private_key": "***REMOVED***",
    "client_email": "firebase-adminsdk-x7woa@moyoon-abikmmr.iam.gserviceaccount.com",
    "client_id": "108089772069529574197",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-x7woa%40moyoon-abikmmr.iam.gserviceaccount.com"
})
firebase_admin.initialize_app(cred, {
    'projectId': "moyoon-abikmmr",
})

def randomString():
    strg = ""
    x = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    for i in range(6):
        y = random.choice(x) #int(random.randrange(10))
        strg = strg + y
    return strg

def createSessionByCategory(catagory_id, is_provided, questions):
    db = firestore.client()
    x = randomString()
    doc_ref = db.collection(u'Session').document(x)
    session_id = doc_ref
    data2 = {
        u'addPlayers' : True
    }
    session_id.set(data2)

    for i in range(3):
        round_col = session_id.collection(u'Rounds')
        round_id = round_col.document(str(i+1))
        data2 = {
            u'isDone' : False
        }
        round_id.set(data2)
        for j in range((i*3), (i*3+3)):
            question_id = round_col.document(str(i+1)).collection(u'Questions').document(str(j+1))
            data2 = {
                u'name' : questions[j].name,
                u'name_ar' : questions[j].name_ar,
                u'Photo' : "URL",
                u'Correct_Answer' : questions[j].Correct_answer,
                u'isDoneSubmitAnswer' : False,
                u'isDoneChooseAnswer' : False
            }
            question_id.set(data2)
    return session_id

# def createSessionByCategory(numOfPlayers, catagory_id, is_provided, questions):
#     db = firestore.client()
#     doc_ref = db.collection(u'Session').document()
#     session_id = doc_ref
#     data2 = {
#         u'addPlayers' : True
#     }
#     session_id.set(data2)

#     for i in range(3):
#         round_col = session_id.collection(u'Rounds')
#         round_id = round_col.document(str(i+1))
#         data2 = {
#             u'isDone' : False
#         }
#         round_id.set(data2)
#         for j in range(len(questions)):
#             question_id = round_id.collection(u'Questions').document(str(j+1))
#             data2 = {
#                 u'name' : questions[j].name,
#                 u'name_ar' : questions[j].name_ar,
#                 u'Photo' : "URL",
#                 u'Correct_Answer' : questions[j].Correct_answer,
#                 u'isDone' : False
#             }
#             question_id.set(data2)
#     return session_id

def checkAddPlayer(session_id):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id)
    addplayer = doc_ref.get().to_dict()
    for key, value in addplayer.items():
        addplayer = value
        break
    print(addplayer)
    return addplayer

def addPlayers(session_id, nick_name):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id)\
        .collection(u'Players').document()
    player_id = doc_ref
    data = {
        u'nick-name' : nick_name,
        u'Score' : 0
    }
    doc_ref.set(data)
    return player_id

def isCorrctAnswer(session_id, round_id, question_id):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id)\
        .collection(u'Rounds').document(round_id)\
        .collection(u'Questions').document(question_id)
    question_doc_id = doc_ref
    question_info = doc_ref.get().to_dict()
    answer = ""
    for key, value in question_info.items():
        if(key == "Correct_Answer"):
            answer = value
    return answer

def incrementPlayerScore(session_id, player_id, points):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id)\
        .collection(u'Players').document(player_id)
    player_info = doc_ref.get().to_dict()
    score = 0
    nick_name = ""
    for key, value in player_info.items():
        if(key == "Score"):
            score = int(value)+points
        elif(key == "nick-name"):
            nick_name = value
    data = {
        u'nick-name' : nick_name,
        u'Score' : score
    }
    doc_ref.set(data)

def createWrongAnswer(session_id, player_id, round_id, question_id, answer):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id)\
        .collection(u'Rounds').document(round_id)\
        .collection(u'Questions').document(question_id)\
        .collection(u'Answer').document()
    data = {
        u'player_id' : player_id,
        u'Answer' : answer
    }
    doc_ref.set(data)

def decrementPlayerScore(session_id, player_id, points):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id)\
        .collection(u'Players').document(player_id)
    player_info = doc_ref.get().to_dict()
    score = 0
    nick_name = ""
    for key, value in player_info.items():
        if(key == "Score"):
            score = int(value)-points
        elif(key == "nick-name"):
            nick_name = value
    data = {
        u'nick-name' : nick_name,
        u'Score' : score
    }
    doc_ref.set(data)

def incrementAuthorScore(session_id, round_id, question_id, answer):
    db = firestore.client()
    Answer_col = db.collection(u'Session').document(session_id)\
        .collection(u'Rounds').document(round_id)\
        .collection(u'Questions').document(question_id)\
        .collection(u'Answer')
    answer_doc = Answer_col.get()
    for i in answer_doc:
        answer_info = i.to_dict()
        if(answer_info['Answer'] == answer):
            incrementPlayerScore(session_id, answer_info['player_id'], 10)
            
def changeAddplayers(session_id):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id)
    data = {
        u'addPlayers' : False
    }
    doc_ref.set(data)

# def gameController(session_id):
#     db = firestore.client()
#     round_col = db.collection(u'Session').document(session_id).collection(u'Rounds')
#     round_docs = round_col.get()
#     iCounter = 0
#     jCounter = 0
#     for i in round_docs:
#         iCounter += 1
#         round_ref = round_col.document(i.id)
        
#         question_col = round_ref.collection(u'Questions')
#         question_doc = question_col.get()
#         for j in question_doc:
#             jCounter += 1
#             #time.sleep(1)
#             question_ref = question_col.document(j.id)
#             question_info = question_ref.get().to_dict()
#             question_info['isDoneSubmitAnswer'] = True
#             question_ref.set(question_info)
#             #time.sleep(1)
#             question_info = question_ref.get().to_dict()
#             question_info['isDoneChooseAnswer'] = True
#             question_ref.set(question_info)
#             #time.sleep(1)
#         round_info = round_ref.get().to_dict()
#         round_info['isDone'] = True
#         round_ref.set(round_info)
#     return (iCounter, jCounter)

def gameController(session_id):
    db = firestore.client()
    round_col = db.collection(u'Session').document(session_id).collection(u'Rounds')
    round_docs = round_col.get()
    round_id = []
    for i in round_docs:
        round_id.append(i.id)
    counter = 0
    qCounter = 0
    for i in round_id:
        qCounter += questionController(session_id, i)
        counter += 1
    return (counter, qCounter)

def questionController(session_id, round_id):
    db = firestore.client()
    question_doc = db.collection(u'Session').document(session_id).collection(u'Rounds').document(round_id).collection(u'Questions').get()
    question_id = []
    for i in question_doc:
        question_id.append(i.id)

    counter = 0
    for i in question_id:
        flagChanger(session_id, round_id, i, True)
        time.sleep(1)
        flagChanger(session_id, round_id, i, False)
        time.sleep(1)
        counter += 1
    return counter

#
# If flag == True then change isDoneSubmitAnswer
# If flag == False then change isDoneChooseAnswer
#
def flagChanger(session_id, round_id, question_id, flag):
    db = firestore.client()
    question_doc = db.collection(u'Session').document(session_id).collection(u'Rounds').document(round_id).collection(u'Questions').document(question_id)
    question_info = question_doc.get().to_dict()
    if(flag):
        question_info['isDoneSubmitAnswer'] = True
    else:
        question_info['isDoneChooseAnswer'] = True
    question_doc.set(question_info)

