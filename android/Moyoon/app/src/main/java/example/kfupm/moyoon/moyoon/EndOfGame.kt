package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.ListView
import android.widget.Toast
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.EventListener
import com.google.firebase.firestore.QuerySnapshot
import java.util.ArrayList
import java.util.HashMap

class EndOfGame : AppCompatActivity() {
    private lateinit var EndHome: Button
    private var db: FirebaseFirestore = FirebaseFirestore.getInstance()

    private lateinit var players_scores : ListView
    private lateinit var arrayAdapter : ArrayAdapter<String>


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_end_of_game)

        players_scores = findViewById<ListView>(R.id.players_Score)
        EndHome = findViewById<Button>(R.id.EndHome)
        val intent = Intent(this, MainActivity::class.java)

        getPlayers()

        EndHome.setOnClickListener {

            startActivity(intent)
        }
      //  updateProfile()
    }

    private fun updateProfile() {
        val note = HashMap<String, Any>()
        Global.gamesPlayed++
        getScore()
        Global.wins = 0
        Global.totalScore += Global.lastScore
        note.put("displayName", Global.name)
        note.put("email", Global.emailAddress)
        note.put("gamesPlayed", Global.gamesPlayed)
        note.put("lastScore", Global.lastScore)
        note.put("totalScore", Global.totalScore)
        note.put("wins", Global.wins)

        db.collection("Players").document(Global.userid).set(note)
            .addOnSuccessListener {
                Log.w("TAG001", "Document Created.")
            }.addOnFailureListener {
                Log.w("TAG001", "Document Is not Created.")
            }
    }
    
    private fun getScore() {
        db.collection("Session").document(Global.sessionID).collection("Players").document(Global.playerID).get()
            .addOnSuccessListener { documentReference ->
                Log.w("TAG001", "documentReference:  " + documentReference)
                if (documentReference.exists()) {
                    Global.lastScore = documentReference.data!!["Score"] as Long
                }
            }
    }

    private fun getPlayers() {

        db.collection("Session").document(Global.sessionID)
            .collection("Players")
            .addSnapshotListener(EventListener<QuerySnapshot> { documentReference, e ->
                if (e != null) {
                    Log.w("33333", "listen:error", e)
                    return@EventListener
                }
                var ps  = ArrayList<String>()
                for (document in documentReference!!) {
                    ps.add(document.getString("nick-name").toString() +": "+document.getDouble("Score").toString() )
                }
                arrayAdapter = list_players_score(this,R.layout.list_players_scores,ps)
                players_scores.adapter = arrayAdapter

            })


    }

}
