package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.os.Parcel
import android.os.Parcelable
import android.util.Log
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.*
import com.google.firebase.firestore.FirebaseFirestore
import java.util.*
import kotlin.collections.ArrayList
import kotlin.concurrent.timerTask

class Display_Answers : AppCompatActivity() {
    lateinit var questionDesplay : TextView
    lateinit var db : FirebaseFirestore
    lateinit var answerslist : ListView
    lateinit var submit : Button
    lateinit var playersAnswer : ArrayList<String>

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_display__answers)

        db = FirebaseFirestore.getInstance()
        questionDesplay = findViewById(R.id.quiston_at_selecton)
        answerslist = findViewById(R.id.answers_list)
        submit = findViewById(R.id.submit_ans)
        playersAnswer = ArrayList()
        val intent = Intent(this,Correct::class.java)


        questionDesplay.text = Global.question
        var arrayAdapter : ArrayAdapter<String>

        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").document("1")
            .collection("Questions").document("1")
            .collection("Answer").get()
            .addOnSuccessListener { k ->
                for (document in k) {
                    playersAnswer.add(document.getString("Answer").toString())
                }
                playersAnswer.add(Global.qAnswer)
                arrayAdapter = ArrayAdapter(this, android.R.layout.simple_expandable_list_item_1, playersAnswer)
                answerslist.adapter = arrayAdapter
            }
            .addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }

        submit.setOnClickListener{
            startActivity(intent)
        }
    }
}
