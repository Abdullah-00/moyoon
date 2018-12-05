package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.*
import com.google.firebase.firestore.*

class PlayerlistActivity : AppCompatActivity() {

    private lateinit var db : FirebaseFirestore
    private lateinit var players : ListView

    private lateinit var arrayAdapter : ArrayAdapter<String>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_playerlist)

        db = FirebaseFirestore.getInstance()
        players = findViewById<ListView>(R.id.players)
        val start = findViewById<Button>(R.id.to_Qs)

        getPlayers()
        getNumOfRounds()

        start.setOnClickListener {
            val intent = Intent(this,Type_Lie::class.java)
            startActivity(intent)
        }

    }



    private fun getPlayers() {

        //       fet Players names in ps array
        db.collection("Session").document(Global.sessionID)
            .collection("Players")
            .addSnapshotListener(EventListener<QuerySnapshot> { documentReference, e ->
                if (e != null) {
                    Log.w("33333", "listen:error", e)
                    return@EventListener
                }
                var ps  = ArrayList<String>()
                for (document in documentReference!!) {
                    ps.add(document.getString("nick-name").toString())
                }
                arrayAdapter = list_names(this,R.layout.activity_list_names,ps)
                players.adapter = arrayAdapter

                // instead of simply using the entire query snapshot
                // see the actual changes to query results between query snapshots (added, removed, and modified)
            })

    }



    private fun getNumOfRounds() {
        var i =0 // for test
        //Finding NUMBER of Rounds
        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").get()
            .addOnSuccessListener { k ->

                for (document in k) {
                    Global.roundID.add(document.id)
                    Log.d("Round>>>>",Global.roundID[i])
                    i++

                }

            }.addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }

    }

}

