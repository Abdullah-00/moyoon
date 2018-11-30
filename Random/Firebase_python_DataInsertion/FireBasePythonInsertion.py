import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

# Use the application default credentials
cred = credentials.Certificate('key/Key.json')
firebase_admin.initialize_app(cred, {
  'projectId': "moyoon-abikmmr",
})

db = firestore.client()

doc_ref = db.collection(u'Players').document(u'insertedByPython')
doc_ref.set({
    u'playerId': u'123213123',
    u'nickname': u'BandarB7',
    u'born': 1995
})
