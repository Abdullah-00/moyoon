package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.*
import com.google.firebase.firestore.FirebaseFirestore
import kotlin.collections.ArrayList
import android.widget.AdapterView
import android.os.CountDownTimer
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.EventListener
import com.google.firebase.firestore.QuerySnapshot

class Display_Answers : AppCompatActivity() {
    private lateinit var questionDesplay : TextView
    private lateinit var db : FirebaseFirestore
    private lateinit var answerslist : ListView
    private lateinit var submit : Button
    private lateinit var playersAnswer : ArrayList<String>
    private lateinit var roundText : TextView //Round Number
    private lateinit var arrayAdapter:ArrayAdapter<String>
    private lateinit var timerTxtAns : TextView //PLayer Lie
    private val intentTypeLie : Intent = Intent(this,Type_Lie::class.java)
    private val intentEndOfGame : Intent = Intent(this,EndOfGame::class.java)
    //private var chooseAnswer: Boolean? = false
    //private lateinit var intentCorrect : Intent
    //private lateinit var intentWrong : Intent



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_display__answers)

        db = FirebaseFirestore.getInstance()
        roundText = findViewById(R.id.roundText)
        questionDesplay = findViewById(R.id.quiston_at_selecton)
        answerslist = findViewById(R.id.answers_list)
        submit = findViewById(R.id.submit_ans)
        playersAnswer = ArrayList()


        //intentCorrect = Intent(this,Correct::class.java)
        //intentWrong = Intent(this,Wrong::class.java)



        roundText.text = "Round " + Global.roundID[Global.roundNum] +"\n Question " +Global.questionNum
        questionDesplay.text = Global.question
        timerTxtAns =findViewById<TextView>(R.id.timerAns)

        val timer2 = MyCounter(10000, 1000)
        timer2.start()
        //isDoneChooseAnswer()
//        if (chooseAnswer == true)
//            timer2.cancel()

        //GetAnswers
        getAnswers()

        answerslist.setOnItemClickListener { parent: AdapterView<*>?, view: View?, position: Int, id: Long ->
           submit.text= "You choose: "+playersAnswer[position]
            Global.pAnswer = playersAnswer[position]
            Log.d("nnnnnnnn", playersAnswer[position])
            Log.d("nnnnnnnn", position.toString())
        }

    }

    private fun isDoneChooseAnswer() {
        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").document(Global.roundID[Global.roundNum])
            .collection("Questions").document(Global.questionNum.toString())
            .addSnapshotListener(EventListener<DocumentSnapshot> { document, e ->
                if (e != null) {
                    Log.w("33333", "listen:error", e)
                    return@EventListener
                }
//                chooseAnswer = document!!.getBoolean("isDoneChooseAnswer")
//                if (chooseAnswer == true) {
//                    SendtoServer()
//                    // Check if the Game is done or not
//                    if(Global.roundNum >= 3)
//                        startActivity(intentEndOfGame)
//                    else
//                        startActivity(intentTypeLie)
//                }
            }
            )
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

            if (Global.roundNum >= 3 && Global.questionNum >=3)
                startActivity(intentEndOfGame)
            else
                startActivity(intentTypeLie)

//            if(Global.pAnswer == Global.qAnswer) {
//                    startActivity(intentCorrect)
//            }
//            else {
//                    startActivity(intentWrong)
//            }

        }
    }

/// get answers
    private fun getAnswers(){
    var answerTemp :String
    db.collection("Session").document(Global.sessionID)
        .collection("Rounds").document(Global.roundID[Global.roundNum])
        .collection("Questions").document(Global.questionNum.toString())
        .collection("Answer")
        .addSnapshotListener(EventListener<QuerySnapshot> { documentReference, e ->
            if (e != null) {
                Log.w("33333", "listen:error", e)
                return@EventListener
            }
            playersAnswer.clear()
            for (document in documentReference!!) {
            answerTemp = document.getString("Answer").toString()
            if(answerTemp != Global.qAnswer) // Check if the answer is the same as correct answer or not
                playersAnswer.add(answerTemp)
        }
            playersAnswer.add(Global.qAnswer)
            arrayAdapter = list_view_answerss(this,R.layout.list_view_answers,playersAnswer)
            answerslist.adapter = arrayAdapter

            // instead of simply using the entire query snapshot
            // see the actual changes to query results between query snapshots (added, removed, and modified)
        })
    }

    private fun SendtoServer() {

        val queue = Volley.newRequestQueue(this)
        val url = "http://68.183.67.247:8000/SubmitAnswerChoice/?session_id=${Global.sessionID.trim()}" +
                "&round_id=${Global.roundID[Global.roundNum].trim()}&question_id=" +
                "${Global.questionNum.toString().trim()}&player_id=${Global.playerID.trim()}&answer=${Global.pAnswer.trim()}"

        // Request a string response from the provided URL......
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
