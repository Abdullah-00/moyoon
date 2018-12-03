package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.*
import com.google.firebase.firestore.FirebaseFirestore


class Type_Lie : AppCompatActivity() {

    lateinit var questionDesplay : TextView
    lateinit var lie : EditText
    lateinit var submit_lie : Button
    lateinit var roundText : TextView //Round Number
    lateinit var db : FirebaseFirestore
    lateinit var playerAns : String //PLayer Answer
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.type_lie)

        db = FirebaseFirestore.getInstance()

        roundText = findViewById(R.id.roundText)
        questionDesplay = findViewById(R.id.question_desplay)
        lie = findViewById(R.id.Lie)
        submit_lie = findViewById(R.id.Submit_lie)
        val intent = Intent(this,Display_Answers::class.java)


        Global.questionNum +=1
        var roundNum = Global.roundNum
        var questionNum= Global.questionNum

        if (questionNum >= 4){
            Global.roundNum +=1
            roundNum = Global.roundNum

        }
        if(roundNum >= 4){
            Global.questionNum = 1
            Global.roundNum = 1
            roundNum = Global.roundNum
        }
        roundText.text = "Round " + Global.roundID[Global.roundNum]
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


        submit_lie.setOnClickListener{
            playerAns = lie.text.toString()
           startActivity(intent)
        }




    }
//




}