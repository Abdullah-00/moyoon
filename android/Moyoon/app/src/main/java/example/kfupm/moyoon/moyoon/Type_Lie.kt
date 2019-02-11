package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.CountDownTimer
import android.util.Log
import android.widget.*
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.EventListener
import com.google.firebase.firestore.FirebaseFirestore



class Type_Lie : AppCompatActivity() {

    private lateinit var questionDesplay : TextView
    private lateinit var lie : EditText
    private lateinit var submit_lie : ImageButton
    private lateinit var roundText : TextView //Round Number
    private lateinit var db : FirebaseFirestore
    private lateinit var playerLie : String //PLayer Lie
    private lateinit var timerTxt : TextView //PLayer Lie
    private var submitAnswer: Boolean? = false
    private lateinit var intentDisplayAnswers : Intent

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.type_lie)

        db = FirebaseFirestore.getInstance()

        roundText = findViewById(R.id.roundText)
        questionDesplay = findViewById(R.id.question_desplay)
        lie = findViewById(R.id.Lie)
        timerTxt =findViewById(R.id.timerTxt)
        intentDisplayAnswers = Intent(this,Display_Answers::class.java)
        val timer = MyCounter(10000, 1000)



        Global.questionNum +=1

        /// Check if the Round is done or not
        if (Global.questionNum == 4 ){
            Global.questionNum = 1
            Global.roundNum +=1
        }


        roundText.text = "Round " + Global.roundID[Global.roundNum] +"\nQuestion " +Global.questionNum
        //// Display Question
        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").document(Global.roundID[Global.roundNum])
            .collection("Questions").document(Global.questionNum.toString())
            .get()
            .addOnSuccessListener { documentReference ->
                questionDesplay.text = documentReference.data!!["name"].toString()
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

//        submit_lie.setOnClickListener{
//
//            //startActivity(intent)
//
//        }
}

    private fun isDoneSubmitAnswer() {
        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").document(Global.roundID[Global.roundNum])
            .collection("Questions").document(Global.questionNum.toString())
            .addSnapshotListener(EventListener<DocumentSnapshot> { document, e ->
                if (e != null) {
                    Log.w("33333", "listen:error", e)
                    return@EventListener
                }
                submitAnswer = document!!.getBoolean("isDoneSubmitAnswer")
                if (submitAnswer == true){
                    playerLie = lie.text.toString()
                    SendtoServer()
                    startActivity(intentDisplayAnswers)
                }

            }
            )
    }

    inner class MyCounter(millisInFuture: Long, countDownInterval: Long) : CountDownTimer(millisInFuture, countDownInterval) {
        override fun onTick(millisUntilFinished: Long) {
            timerTxt.text = (millisUntilFinished / 1000).toString() + ""
            println("Timer  : " + millisUntilFinished / 1000)
        }

        override fun onFinish() {
            println("Timer Completed.")
            timerTxt.text = "Timer Completed."
            playerLie = lie.text.toString()
            SendtoServer()
            startActivity(intentDisplayAnswers)
        }
        //"http://68.183.67.247:8000/SubmitAnswer/?session_id="+Global.sessionID+
        //       "&round_id="+Global.roundNum+"&question_id="+Global.questionNum+"&player_id="+Global.playerID+"&answer="+playerLie
    }
    private fun SendtoServer() {
        val queue = Volley.newRequestQueue(this)
        val url = "http://68.183.67.247:8000/SubmitAnswer/?session_id=${Global.sessionID.trim()}&round_id=${Global.roundID[Global.roundNum].trim()}&question_id=${Global.questionNum.toString().trim()}&player_id=${Global.playerID.trim()}&answer=${playerLie.trim()}"

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


}


////////////////////////////DO NOT TOUCH THIS
/*  private fun getNumOfQuestions() {
      var i =0 // for test
      db.collection("Session").document(Global.sessionID)
          .collection("Rounds").document("1").collection("Questions").get()
          .addOnSuccessListener { k ->
              for (document in k) {
                  Global.questionID.add(document.id)
                  Log.d("Question>>>>",Global.questionID[i])
                  i++

              }
          }.addOnFailureListener { exception ->
              Log.w("PlayerlistActivity", "Error getting documents.", exception)
          }
  }*/