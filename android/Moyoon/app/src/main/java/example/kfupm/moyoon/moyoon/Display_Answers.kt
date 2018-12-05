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
import android.os.CountDownTimer
import android.widget.AdapterView.OnItemClickListener
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import kotlinx.android.synthetic.main.activity_display__answers.*


class Display_Answers : AppCompatActivity() {
    private lateinit var questionDesplay : TextView
    private lateinit var db : FirebaseFirestore
    private lateinit var answerslist : ListView
    private lateinit var submit : Button
    private lateinit var playersAnswer : ArrayList<String>
    private lateinit var roundText : TextView //Round Number
    private lateinit var arrayAdapter:ArrayAdapter<String>
    private lateinit var timerTxtAns : TextView //PLayer Lie


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
        timerTxtAns =findViewById<TextView>(R.id.timerAns)

        val timer2 = MyCounter(10000, 1000)
        timer2.start()


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
    inner class MyCounter(millisInFuture: Long, countDownInterval: Long) : CountDownTimer(millisInFuture, countDownInterval) {
        override fun onTick(millisUntilFinished: Long) {
            timerTxtAns.text = (millisUntilFinished / 1000).toString() + ""
            println("Timer  : " + millisUntilFinished / 1000)
        }

        override fun onFinish() {
            println("Timer Completed.")
            timerTxtAns.text = "Timer Completed."

            SendtoServer()

            startActivity(intent)

        }
        //"http://68.183.67.247:8000/SubmitAnswer/?session_id="+Global.sessionID+
        //       "&round_id="+Global.roundNum+"&question_id="+Global.questionNum+"&player_id="+Global.playerID+"&answer="+playerLie
    }



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

    private fun SendtoServer() {

        val queue = Volley.newRequestQueue(this)
        val url = "http://68.183.67.247:8000/SubmitAnswerChoice/?session_id=${Global.sessionID.trim()}" +
                "&round_id=${Global.roundID[Global.roundNum].trim()}&question_id=" +
                "${Global.questionNum.toString().trim()}&player_id=${Global.playerID.trim()}&answer=${Global.pAnswer.trim()}"

        // Request a string response from the provided URL.
        val stringRequest = StringRequest(
            Request.Method.GET, url,
            Response.Listener<String> { response ->
                // Display the first 500 characters of the response string.
               // Global.playerID = response
                Log.d("T","tttttttttt")
            },
            Response.ErrorListener { Log.d("t", "That didn't work!") })

        // Add the request to the RequestQueue.
        queue.add(stringRequest)


    }
}
