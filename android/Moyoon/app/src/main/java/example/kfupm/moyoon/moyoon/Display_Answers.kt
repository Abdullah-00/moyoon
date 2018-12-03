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
    lateinit var arrayAdapter : ArrayAdapter<String>
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_display__answers)

        db = FirebaseFirestore.getInstance()
        questionDesplay = findViewById(R.id.quiston_at_selecton)
        answerslist = findViewById(R.id.answers_list)
        submit = findViewById(R.id.submit_ans)
        val intent = Intent(this,Correct::class.java)

//        db.collection("Session").document(Global.sessionID)
//            .collection("Rounds").document("1")
//            .collection("Questions").document("1")
//            .get()
//            .addOnSuccessListener { documentReference ->
//                questionDesplay.setText(documentReference.data!!["name"].toString())
//            }
//            .addOnFailureListener { exception ->
//                Log.w("PlayerlistActivity", "Error getting documents.", exception)
//            }
        questionDesplay.setText(Global.question)
        val nebulae = arrayOf<String>("الرياض", "جنيف", "واشنطن", "قنونا")

        arrayAdapter = ArrayAdapter(this, android.R.layout.simple_list_item_1, nebulae)
        answerslist.adapter = arrayAdapter

        submit.setOnClickListener{
            startActivity(intent)
        }
    }
}
