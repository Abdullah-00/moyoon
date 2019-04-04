package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.CountDownTimer
import android.os.Parcel
import android.os.Parcelable
import android.util.Log
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import android.widget.*
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.EventListener
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_sign_in__facebook.*


class Type_Lie() : AppCompatActivity() {

    private lateinit var questionDesplay : TextView
    private lateinit var lie : EditText
    private lateinit var submit_lie : ImageButton
    private lateinit var roundText : TextView //Round Number
    private lateinit var queistionText : TextView //Round Number
    private lateinit var db : FirebaseFirestore
    private lateinit var timerTxt : TextView //PLayer Lie
    private var submitAnswer: Boolean? = false
    private lateinit var intentDisplayAnswers : Intent
     lateinit var Home : Intent
    lateinit  var timer: MyCounter
    private var suspended: Double = 0.0



    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.type_lie)

        db = FirebaseFirestore.getInstance()

        roundText = findViewById(R.id.roundText)
        queistionText = findViewById(R.id.questionRoundText7)

        questionDesplay = findViewById(R.id.question_desplay)
        lie = findViewById(R.id.Lie)
        timerTxt = findViewById(R.id.timerTxt)
        intentDisplayAnswers = Intent(this,Display_Answers::class.java)
         timer = MyCounter(11000, 1000)

        if(Global.LeaveSession){
        SusbendFlag()}

        Global.questionNum +=1

        /// Check if the Round is done or not
        if (Global.questionNum == 4 ){
            Global.questionNum = 1
            Global.roundNum +=1
            Global.KickCounter = 0
        }

        Log.d("T","C2"+Global.roundNum+"tttttttttt"+Global.questionNum)

        roundText.text = roundText.text.toString() + Global.roundID[Global.roundNum]
        queistionText.text =   queistionText.text.toString() + Global.questionNum

        //// Display Question
        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").document(Global.roundID[Global.roundNum])
            .collection("Questions").document(Global.questionNum.toString())
            .get()
            .addOnSuccessListener { documentReference ->
                questionDesplay.text = documentReference.data!!["name_ar"].toString()
                var st : String = questionDesplay.text as String
                Global.question = st
                Global.qAnswer = documentReference.data!!["Correct_Answer"].toString()
            }
            .addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }

        timer.start()
        //isDoneSubmitAnswer()
        if (submitAnswer == true)
            timer.cancel()

}

//    }

    inner class MyCounter(millisInFuture: Long, countDownInterval: Long) : CountDownTimer(millisInFuture, countDownInterval) {
        override fun onTick(millisUntilFinished: Long) {
            timerTxt.text = (millisUntilFinished / 1000).toString() + ""
            println("Timer  : " + millisUntilFinished / 1000)

        }

        override fun onFinish() {
            println("Timer Completed.")
            timerTxt.text = "Timer Completed."
            Global.playerLie = lie.text.toString()
            if (Global.LeaveSession) {
                if(Global.playerLie.isNotEmpty())
                SendtoServer()
                startActivity(intentDisplayAnswers)
            }else timer.cancel()
        }
        //"http://68.183.67.247:8000/SubmitAnswer/?session_id="+Global.sessionID+
        //       "&round_id="+Global.roundNum+"&question_id="+Global.questionNum+"&player_id="+Global.playerID+"&answer="+playerLie
    }
    private fun SendtoServer() {
        val queue = Volley.newRequestQueue(this)
        val url = "http://68.183.67.247:8000/SubmitAnswer/?session_id=${Global.sessionID.trim()}&round_id=${Global.roundID[Global.roundNum].trim()}&question_id=${Global.questionNum.toString().trim()}&player_id=${Global.playerID.trim()}&answer=${Global.playerLie.trim()}"

        Log.d("ttttttt", "not in >>>>>" + Global.questionNum.toString())

        // Request a string response from the provided URL.
        val stringRequest = StringRequest(
            Request.Method.GET, url,
            Response.Listener<String> { response ->
                Log.d("ttttttt", response)
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
                SendtoServerLeave()
                Home = Intent(this,MainActivity::class.java)
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

                Log.d("eeeeee",Global.nickname)
            },
            Response.ErrorListener { Log.d("t", "That didn't work!") })

        // Add the request to the RequestQueue.
        queue.add(stringRequest)


    }

    private fun SusbendFlag() {

        db.collection("Session").document(Global.sessionID).collection("Players").document(Global.playerID)
            .addSnapshotListener(EventListener<DocumentSnapshot> { document , e ->
                if (e != null) {
                    Log.w("33333", "listen:error", e)
                    return@EventListener
                }

             if(Global.LeaveSession ){
                 suspended = document!!.getDouble("Score")!!
             }
                if (suspended.toInt() > -50 ) {
                    lie.visibility = View.VISIBLE

                }else{
                    lie.visibility = View.INVISIBLE
                    Toast.makeText(baseContext, "انت موقوف", Toast.LENGTH_SHORT).show()
                }


                Log.w("33333aa", suspended.toString(), e)

            }
            )
    }






}
