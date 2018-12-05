package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.*
import com.google.firebase.firestore.FirebaseFirestore
import kotlin.collections.ArrayList

class Display_Answers : AppCompatActivity() {
    private lateinit var questionDesplay : TextView
    private lateinit var db : FirebaseFirestore
    private lateinit var answerslist : ListView
    private lateinit var submit : Button
    private lateinit var playersAnswer : ArrayList<String>
    private lateinit var roundText : TextView //Round Number

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_display__answers)

        db = FirebaseFirestore.getInstance()

        roundText = findViewById(R.id.roundText)
        questionDesplay = findViewById(R.id.quiston_at_selecton)
        answerslist = findViewById(R.id.answers_list)
        submit = findViewById(R.id.submit_ans)
        playersAnswer = ArrayList()
        val intent = Intent(this,Correct::class.java)


        roundText.text = "Round " + Global.roundID[Global.roundNum]
        questionDesplay.text = Global.question
        var arrayAdapter : ArrayAdapter<String>


        //GetAnswers
        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").document(Global.roundID[Global.roundNum])
            .collection("Questions").document(Global.questionNum.toString())
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
