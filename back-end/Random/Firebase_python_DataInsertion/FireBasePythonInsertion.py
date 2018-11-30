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


# Use the application default credentials
def createSession(numOfPlayers, catagory_id, is_provided, questions):
    db = firestore.client()
    doc_ref = db.collection(u'Session').document(u'insertedByPython3')
    data = u'City(Number_of_players={}, categoty_id={}, is_provided={}, questions={})'.format(numOfPlayers, catagory_id,
                                                                                              is_provided, questions)
    data2 = {
        u'Number_Of_Players' : numOfPlayers,
        u'Category_ID' : catagory_id,
        u'Is_Provided' : is_provided,
        u'Questions' : questions
    }
    doc_ref.set(data2)


