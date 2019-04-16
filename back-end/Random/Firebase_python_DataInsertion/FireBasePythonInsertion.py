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

def createSessionByCategory(questions, isPrivate):
    db = firestore.client()
    x = randomString()
    doc_ref = db.collection(u'Session').document(x)
    session_id = doc_ref
    if(isPrivate):
        data2 = {
            u'addPlayers' : True,
            u'isPrivate': True,
            u'isFull': False
        }
    else:
        data2 = {
            u'addPlayers': True,
            u'isPrivate': False,
            u'isFull': False
        }
    session_id.set(data2)

    for i in range(3):
        round_col = session_id.collection(u'Rounds')
        round_id = round_col.document(str(i+1))
        data2 = {
            u'isDone' : False
        }
        round_id.set(data2)
        k=0
        for j in range((i*3), (i*3+3)):
            k+=1
            question_id = round_col.document(str(i+1)).collection(u'Questions').document(str(k))
            data2 = {
                u'name' : questions[j].name,
                u'name_ar' : questions[j].name_ar,
                u'Photo' : "URL",
                u'Correct_Answer' : questions[j].Correct_answer,
                u'isDoneSubmitAnswer' : False,
                u'isDoneChooseAnswer' : False,
                u'isDoneShowingTheResult' : False
            }
            question_id.set(data2)
    return session_id

def createSessionWithUserInput(questions, round_limit):
    db = firestore.client()
    x = randomString()
    doc_ref = db.collection(u'Session').document(x)
    session_id = doc_ref
    data2 = {
        u'addPlayers' : True,
        u'isPrivate': True,
        u'isFull': False
    }
    session_id.set(data2)

    round_col = session_id.collection(u'Rounds')

    for i in range(round_limit):
        round_id = round_col.document(str(i + 1))
        data2 = {
            u'isDone': False
        }
        round_id.set(data2)

    count = 0
    k =0
    j = 0
    for i in questions:
        k += 1
        # round_col = session_id.collection(u'Rounds')
        # round_id = round_col.document(str(count+1))
        question_id = round_col.document(str(count + 1)).collection(u'Questions').document(str(k))
        data2 = {
            u'name': questions[j].name,
            u'name_ar': questions[j].name_ar,
            u'Photo': "URL",
            u'Correct_Answer': questions[j].Correct_answer,
            u'isDoneSubmitAnswer': False,
            u'isDoneChooseAnswer': False,
            u'isDoneShowingTheResult' : False
        }
        question_id.set(data2)
        j +=1
        if(count >= round_limit-1):
            count = 0
        else:
            count +=1

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
    if(addplayer == None):
        return False
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
        u'Score' : 0,
        u'isSuspended': False,
        u'winner' : False,
        u'winnerFlagIsUpdated' : False
    }
    doc_ref.set(data)
    return player_id


def isCorrctAnswer(session_id, round_id, question_id):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id)\
        .collection(u'Rounds').document(round_id)\
        .collection(u'Questions').document(question_id)
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
        u'Score' : score,
        u'isSuspended' : player_info['isSuspended'],
        u'winner' : player_info['winner'],
        u'winnerFlagIsUpdated' : player_info['winnerFlagIsUpdated']
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
    #doc_ref = db.collection(u'Session').document(session_id).collection(u'Players').document(player_id).get().to_dict()
    data = {
        u'nick-name' : nick_name,
        u'Score' : score,
        u'isSuspended' : player_info['isSuspended'],
        u'winner' : player_info['winner'],
        u'winnerFlagIsUpdated' : player_info['winnerFlagIsUpdated']
    }
    doc_ref.set(data)

def incrementAuthorScore(session_id, round_id, question_id, player_id, answer):
    db = firestore.client()
    Answer_col = db.collection(u'Session').document(session_id)\
        .collection(u'Rounds').document(round_id)\
        .collection(u'Questions').document(question_id)\
        .collection(u'Answer')
    answer_doc = Answer_col.get()
    for i in answer_doc:
        answer_info = i.to_dict()
        if(answer_info['Answer'] == answer and player_id != answer_info['player_id']):
            incrementPlayerScore(session_id, answer_info['player_id'], 10)
            
def changeAddplayers(session_id):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(session_id)
    data = {
        u'addPlayers' : False,
        u'isPrivate': True,
        u'isFull': False
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
    print("Hello there general kenopi")
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
        round_doc = round_col.document(i)
        round_info = round_doc.get().to_dict()
        round_info['isDone'] = True
        round_doc.set(round_info)
        checkPlayerScore(session_id)
        counter += 1
    print("Going into winner def")
    winner(session_id)
    time.sleep(300)
    round_col = db.collection(u'Session').document(session_id).delete()
    return (counter, qCounter)

def winner(session_id):
    db = firestore.client()
    players_col = db.collection(u'Session').document(session_id).collection(u'Players')
    players_list = players_col.get()
    max_score = -99999999
    player_id = 0
    for i in players_list:
        player_info = i.to_dict()
        player_score = player_info['Score']
        if(player_score > max_score):
            print("Look here")
            print(max_score)
            max_score = player_score
            print(max_score)
            player_id = i.id
            print(player_id)
    print(player_id)
    player_doc = db.collection(u'Session').document(session_id).collection(u'Players').document(player_id)
    player_info = player_doc.get().to_dict()
    data = {
            u'nick-name': player_info['nick-name'],
            u'Score': player_info['Score'],
            u'isSuspended' : player_info['isSuspended'],
            u'winner' : True,
            u'winnerFlagIsUpdated' : True
    }
    player_doc.set(data)
    print("Should be updated")
    players_col = db.collection(u'Session').document(session_id).collection(u'Players')
    players_list = players_col.get() 
    for i in players_list:
        player_info = i.to_dict()
        data = {
            u'nick-name': player_info['nick-name'],
            u'Score': player_info['Score'],
            u'isSuspended' : player_info['isSuspended'],
            u'winner' : player_info['winner'],
            u'winnerFlagIsUpdated' : True
        }
        player_doc = db.collection(u'Session').document(session_id).collection(u'Players').document(i.id).set(data)
            

def checkPlayerScore(session_id):
    db = firestore.client()
    players_col = db.collection(u'Session').document(session_id).collection(u'Players')
    players_list = players_col.get()

    for i in players_list:
        player_info = i.to_dict()
        if(player_info['Score'] >= 0):
            player_info['isSuspended'] = False
        elif(player_info['Score'] <= -20):
            player_info['isSuspended'] = True
        data = {
            u'nick-name': player_info['nick-name'],
            u'Score': player_info['Score'],
            u'isSuspended' : player_info['isSuspended'],
            u'winner' : player_info['winner'],
            u'winnerFlagIsUpdated' : player_info['winnerFlagIsUpdated']
        }
        dict_ref = players_col.document(i.id)
        dict_ref.set(data)


def questionController(session_id, round_id):
    db = firestore.client()
    question_doc = db.collection(u'Session').document(session_id).collection(u'Rounds').document(round_id).collection(u'Questions').get()
    question_id = []
    for i in question_doc:
        question_id.append(i.id)

    counter = 0
    for i in question_id:
        time.sleep(10)
        flagChanger(session_id, round_id, i, True, False)
        time.sleep(10)
        flagChanger(session_id, round_id, i, False, False)
        counter += 1 
    
    return counter

#
# If flag == True then change isDoneSubmitAnswer
# If flag == False then change isDoneChooseAnswer
#
def flagChanger(session_id, round_id, question_id, flag, flag2):
    db = firestore.client()
    question_doc = db.collection(u'Session').document(session_id).collection(u'Rounds').document(round_id).collection(u'Questions').document(question_id)
    question_info = question_doc.get().to_dict()
    if(flag):
        question_info['isDoneSubmitAnswer'] = True
    else:
        question_info['isDoneChooseAnswer'] = True
    question_doc.set(question_info)


def searchForSession(nick_name,questions):
    db = firestore.client()
    doc_ref = db.collection(u'Session')
    session_list = doc_ref.get()

    for i in session_list:
        doc = i.to_dict()
        if (doc["isPrivate"] == False and doc["isFull"] == False):
            x = addPlayers(i.id, nick_name)
            session_id = i
            return (x,session_id)

    session_id = createSessionByCategory(questions, False)
    player_id = addPlayers(session_id.id,nick_name)
    return (player_id,session_id)

def checkNumberOfPlayers(session_id):
    db = firestore.client()
    players_list = db.collection(u'Session').document(session_id).collection(u'Players').get()
    count = 0
    for i in players_list:
        count +=1
        if(count == 4):
            return True
    return False

def leaveController(player_id,session_id):
    db = firestore.client()
    player_doc = db.collection(u'Session').document(session_id).collection(u'Players')
    players_list = player_doc.get()

    for i in players_list:

        if (i.id == player_id):
            player = db.collection(u'Session').document(session_id).collection(u'Players').document(i.id).delete()
        else:
            return ('Player id Does not exist')
