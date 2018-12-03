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
    lateinit var db : FirebaseFirestore
    lateinit var playerAns : String //PLayer Answer
    lateinit var st : String
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.type_lie)


        db = FirebaseFirestore.getInstance()
        questionDesplay = findViewById(R.id.question_desplay)
        lie = findViewById(R.id.Lie)
        submit_lie = findViewById(R.id.Submit_lie)
        val intent = Intent(this,Display_Answers::class.java)

        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").document("1")
            .collection("Questions").document("1")
            .get()
            .addOnSuccessListener { documentReference ->
                questionDesplay.setText(documentReference.data!!["name"].toString())
                st = questionDesplay.text as String
                print("HHHHHHHHHHHHHHHHHH : " + st)
                Global.question = st
                print("Question ABBSSSSS> " + Global.question)
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