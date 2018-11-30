import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use the application default credentials
def createSession(numOfPlayers, catagory_id, is_provided, questions):
    cred = credentials.Certificate('key/Key.json')
    firebase_admin.initialize_app(cred, {
        'projectId': "moyoon-abikmmr",
    })

    db = firestore.client()

    doc_ref = db.collection(u'Session').document(u'insertedByPython2')
    doc_ref.set({
        u'Number of Players': u'123213123',
        u'nickname': u'BandarB7',
        u'born': 1995
    })
