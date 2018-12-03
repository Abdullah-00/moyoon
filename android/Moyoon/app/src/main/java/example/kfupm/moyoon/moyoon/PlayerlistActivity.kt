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

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_playerlist)
        db = FirebaseFirestore.getInstance()
        players = findViewById<ListView>(R.id.players)
      //  playersJoind = findViewById<TextView>(R.id.Players_Joind)

        val textv = findViewById<TextView>(R.id.textViewPlayers)
        ps = ArrayList<String>()
        val arrayAdapter : ArrayAdapter<String>
        var i = 0
var element : String = "Tessssst"

        db.collection("Session").document(Global.sessionID)
            .collection("Players")
            .get()
            .addOnSuccessListener { documentReference ->
                for (document in documentReference) {
                    //Log.d("PlayerlistActivity", document.id + " => " + document.data)
                    ps.add(document.getString("nick-name").toString())
                    println(ps[i])
                    i += 1
                    textv.setText(Global.sessionID)

                }
            }
            .addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }
       // textv.setText(element+"hi ")

      ps.add(Global.nickname)
        arrayAdapter = ArrayAdapter(this, android.R.layout.simple_expandable_list_item_1, ps)
        players.adapter = arrayAdapter

        val start = findViewById<Button>(R.id.to_Qs)
        start.setOnClickListener {
            val intent = Intent(this,Display_Answers::class.java)
            startActivity(intent)
        }

    }
}