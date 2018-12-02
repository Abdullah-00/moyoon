package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.ListView
import android.widget.TextView
import com.google.firebase.firestore.FirebaseFirestore

class PlayerlistActivity : AppCompatActivity() {

    lateinit var db : FirebaseFirestore
    lateinit var players : ListView
    lateinit var playersJoind : TextView
    lateinit var ps : ArrayList<String>
    override fun onStart() {
        super.onStart()
        db.collection("Players").get()
            .addOnSuccessListener { documentReference ->
                for (document in documentReference) {
                  Log.d("PlayerlistActivity", document.id + " => " + document.data)
                    ps.add(document.id)
                 }
            }
            .addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }
    }
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_playerlist)
        db = FirebaseFirestore.getInstance()
        players = findViewById(R.id.players)
        playersJoind = findViewById<TextView>(R.id.Players_Joind)
        onStart()
        players 








        //val myList = findViewById<TextView>(R.id.players) as ListView

        //var adapter= ArrayAdapter(this,android.R.layout.simple_list_item_1,ps)
        //myList.adapter=adapter


    }
}


