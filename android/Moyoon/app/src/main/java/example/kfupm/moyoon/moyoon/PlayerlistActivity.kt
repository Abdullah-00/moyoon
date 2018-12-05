package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.ListView
import android.widget.TextView
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.EventListener
import com.google.firebase.firestore.FirebaseFirestore

class PlayerlistActivity : AppCompatActivity() {

    lateinit var db : FirebaseFirestore
    lateinit var players : ListView
    lateinit var ps : ArrayList<String>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_playerlist)

        db = FirebaseFirestore.getInstance()
        players = findViewById<ListView>(R.id.players)


        ps = ArrayList<String>()
        var arrayAdapter : ArrayAdapter<String>

//       fet Players names in ps array
        db.collection("Session").document(Global.sessionID)
            .collection("Players")
            .get()
            .addOnSuccessListener { documentReference ->
                for (document in documentReference) {
                    //Log.d("PlayerlistActivity", document.id + " => " + document.data)
                    ps.add(document.getString("nick-name").toString())
                }
                arrayAdapter = list_names(this,R.layout.activity_list_names,ps)
                players.adapter = arrayAdapter
            }
            .addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }


        var i:Int=0 // for test
        //Finding NUMBER of Rounds
        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").get()
            .addOnSuccessListener { k ->
                for (document in k) {
                    Global.roundID.add(document.id)
                    Log.d("TTTT",Global.roundID[i])
                    i++
                }
            }.addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }

        val start = findViewById<Button>(R.id.to_Qs)
        start.setOnClickListener {
            val intent = Intent(this,Type_Lie::class.java)
            startActivity(intent)
        }

    }
}