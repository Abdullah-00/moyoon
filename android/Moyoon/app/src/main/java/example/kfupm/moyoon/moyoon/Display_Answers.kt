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
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.EventListener
import com.google.firebase.firestore.QuerySnapshot
import com.google.protobuf.Empty
import java.util.*

class Display_Answers : AppCompatActivity() {
    private lateinit var questionDesplay : TextView
    private lateinit var db : FirebaseFirestore
    private lateinit var answerslist : ListView
    private lateinit var submit : ImageButton
    private lateinit var playersAnswer : ArrayList<String>
    private lateinit var roundText : TextView //Round Number
    private lateinit var queistionText : TextView //Round Number
    private lateinit var arrayAdapter:ArrayAdapter<String>
    private lateinit var timerTxtAns : TextView //PLayer Lie
    private lateinit var intentTypeLie : Intent
    private lateinit var intentEndOfGame : Intent
    lateinit var Home : Intent
    lateinit  var timer2: MyCounter






    //private var chooseAnswer: Boolean? = false
    //private lateinit var intentCorrect : Intent
    //private lateinit var intentWrong : Intent



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_display__answers)

        db = FirebaseFirestore.getInstance()
        roundText = findViewById(R.id.roundText)
        queistionText = findViewById(R.id.questionRoundText2)
        questionDesplay = findViewById(R.id.quiston_at_selecton)
        answerslist = findViewById(R.id.answers_list)
     //   submit = findViewById(R.id.submit_ans)
        playersAnswer = ArrayList()
        intentTypeLie = Intent(this,Type_Lie::class.java)
        intentEndOfGame = Intent(this,EndOfGame::class.java)
        Home = Intent(this,MainActivity::class.java)



        roundText.text = roundText.text.toString() + Global.roundID[Global.roundNum]
        queistionText.text =   queistionText.text.toString() + Global.questionNum

        questionDesplay.text = Global.question
        timerTxtAns =findViewById<TextView>(R.id.timerTxt)

       timer2 = MyCounter(11000, 1000)
        timer2.start()

        getAnswers()

        answerslist.setOnItemClickListener { parent: AdapterView<*>?, view: View?, position: Int, id: Long ->
        //

            //   submit.text= "You choose: "+playersAnswer[position]
            Global.pAnswer = playersAnswer[position]
            Log.d("nnnnnnnn", playersAnswer[position])

            Toast.makeText(baseContext, "انت اخترت: "+ Global.pAnswer, Toast.LENGTH_SHORT).show()

            Log.d("nnnnnnnn", position.toString())
        }

    }

  

    /////////////////////////////////////////////////////////////////////
    inner class MyCounter(millisInFuture: Long, countDownInterval: Long) : CountDownTimer(millisInFuture, countDownInterval) {
        override fun onTick(millisUntilFinished: Long) {
            timerTxtAns.text = (millisUntilFinished / 1000).toString() + ""
            println("Timer  : " + millisUntilFinished / 1000)
        }

        override fun onFinish() {
            if(Global.pAnswer.isEmpty() && Global.playerLie.isEmpty()){
                Global.KickCounter++
            }
            timerTxtAns.text = "Timer Completed."
     SendtoServer()

            if(Global.LeaveSession) {

                if(Global.KickCounter == 3){
                    Global.LeaveSession = false
                    SendtoServerLeave()
                    Toast.makeText(baseContext, "تم طردك لعدم النشاط", Toast.LENGTH_SHORT).show()
                    startActivity(Home)

                }else if (Global.roundNum == 2 && Global.questionNum == 3)
                    startActivity(intentEndOfGame)
                else
                    startActivity(intentTypeLie)
            }else timer2.cancel()

            Global.pAnswer= ""
            Global.playerLie = ""
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

            val seed = System.nanoTime()
            Collections.shuffle(playersAnswer, Random(seed))

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

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val inflater: MenuInflater = menuInflater
        inflater.inflate(R.menu.menu1, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle item selection
        return when (item.itemId) {
            R.id.leave -> {
                Global.LeaveSession =false
                timer2.cancel()
                SendtoServerLeave()
                startActivity(Home)

                true
            }

            else -> super.onOptionsItemSelected(item)
        }
    }

    private fun SendtoServerLeave() {

        val queue = Volley.newRequestQueue(this)
        val url = "http://68.183.67.247:8000/leaveSession/?session_id="+Global.sessionID+"&player_id="+Global.playerID
        Log.d("eeeeee","ohuuygu")

        // Request a string response from the provided URL.
        val stringRequest = StringRequest(Request.Method.GET, url,
            Response.Listener<String> { response ->
                // Display the first 500 characters of the response string.
                //  Global.nickname = response.substringAfter(",",",").trim()
                //   Global.playerID = response.substringBefore(",").trim()
                Log.d("eeeeee",Global.nickname)
            },
            Response.ErrorListener { Log.d("t", "That didn't work!") })

        // Add the request to the RequestQueue.
        queue.add(stringRequest)


    }
}
