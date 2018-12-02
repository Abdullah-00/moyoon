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
    var beginGame : Boolean = false
    //lateinit var arrayAdapter : ArrayAdapter<String>
    override fun onStart() {
        super.onStart()
        var i = 0
        db.collection("Session/CSC8hsgaLCwz6OcLmblN/Players").get()
            .addOnSuccessListener { documentReference ->
                    for (document in documentReference) {
                        //Log.d("PlayerlistActivity", document.id + " => " + document.data)
                        ps.add(document.id + " Abdo" + i)
                        i += 1
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
        players = findViewById<TextView>(R.id.players) as ListView
        playersJoind = findViewById<TextView>(R.id.Players_Joind)
        ps = ArrayList<String>()

        val arrayAdapter : ArrayAdapter<String>
       var i = 0
        db.collection("Session/CSC8hsgaLCwz6OcLmblN/Players").get()
            .addOnSuccessListener { documentReference ->
                for (document in documentReference) {
                    //Log.d("PlayerlistActivity", document.id + " => " + document.data)
                    ps.add(document.id + " Abdo" + i)
                    println(ps[i])
                    i += 1

                }
            }
            .addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }

        arrayAdapter = ArrayAdapter(this, android.R.layout.simple_list_item_1, ps)
        players.adapter = arrayAdapter

      // onStart()


        //val myList = findViewById<TextView>(R.id.players) as ListView

        //var adapter= ArrayAdapter(this,android.R.layout.simple_list_item_1,ps)
        //myList.adapter=adapter


    }
}


