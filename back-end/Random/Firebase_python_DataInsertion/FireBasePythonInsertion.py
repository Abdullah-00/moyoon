import firebase_admin
import json
from firebase_admin import credentials
from firebase_admin import firestore

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

def createSessionByCategory(numOfPlayers, catagory_id, is_provided, questions):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document()
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
    doc_ref = db.collection(u'Session').document(session_id).collection(u'Players').document()
    player_id = doc_ref
    data = {
        u'nick-name' : nick_name,
        u'Score' : 0
    }
    doc_ref.set(data)
    return player_id

def isCorrctAnswer(session_id, round_id, question_id):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id).collection(u'Rounds').document(round_id).collection(u'Questions').document(question_id)
    question_doc_id = doc_ref
    question_info = doc_ref.get().to_dict()
    answer = ""
    for key, value in question_info.items():
        if(key == "Correct_Answer"):
            answer = value
    return answer

def incrementPlayerScore(session_id, player_id, points):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id).collection(u'Players').document(player_id)
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
    doc_ref = db.collection(u'Session').document(session_id).collection(u'Rounds').document(round_id).collection(u'Questions').document(question_id).collection(u'Answer').document()
    data = {
        u'player_id' : player_id,
        u'Answer' : answer
    }
    doc_ref.set(data)
     

    


