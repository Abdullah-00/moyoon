package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.os.Parcel
import android.os.Parcelable
import android.util.Log
import android.view.View
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.*
import com.google.firebase.firestore.FirebaseFirestore
import java.util.*
import kotlin.collections.ArrayList
import kotlin.concurrent.timerTask
import android.widget.AdapterView
import android.widget.AdapterView.OnItemClickListener
import kotlinx.android.synthetic.main.activity_display__answers.*


class Display_Answers : AppCompatActivity() {
    private lateinit var questionDesplay : TextView
    private lateinit var db : FirebaseFirestore
    private lateinit var answerslist : ListView
    private lateinit var submit : Button
    private lateinit var playersAnswer : ArrayList<String>
    private lateinit var roundText : TextView //Round Number
    private lateinit var arrayAdapter:ArrayAdapter<String>

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



        //GetAnswers
        getAnswers()



        answerslist.setOnItemClickListener { parent: AdapterView<*>?, view: View?, position: Int, id: Long ->
           submit.text= "You choose: "+playersAnswer[position]
            Global.pAnswer = playersAnswer[position]
            Log.d("nnnnnnnn", playersAnswer[position])
            Log.d("nnnnnnnn", position.toString())
        }



        if(Global.pAnswer == Global.qAnswer) {
            val intent = Intent(this,Correct::class.java)
            submit.setOnClickListener {
                startActivity(intent)
            }
        }
        else {
            val intent = Intent(this,Wrong::class.java)
            submit.setOnClickListener {
                startActivity(intent)
            }
        }
    }

    /////////////////////////////////////////////////////////////////////

    private fun getAnswers(){
        var answerTemp :String
        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").document(Global.roundID[Global.roundNum])
            .collection("Questions").document(Global.questionNum.toString())
            .collection("Answer").get()
            .addOnSuccessListener { k ->
                for (document in k) {
                    answerTemp = document.getString("Answer").toString()
                    if(answerTemp != Global.qAnswer) // Check if the answer is the same as correct answer or not
                        playersAnswer.add(answerTemp)
                }
                playersAnswer.add(Global.qAnswer)
                arrayAdapter = list_view_answerss(this,R.layout.list_view_answers,playersAnswer)
                answerslist.adapter = arrayAdapter
            }
            .addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }


    }
}
