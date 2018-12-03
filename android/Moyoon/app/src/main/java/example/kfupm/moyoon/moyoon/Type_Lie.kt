package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.*
import com.google.firebase.firestore.DocumentSnapshot
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.FirebaseFirestoreException
import com.google.firebase.firestore.FirebaseFirestoreSettings
import java.util.*


class Type_Lie : AppCompatActivity() {

    lateinit var question_desplay : TextView
    lateinit var lie : EditText
    lateinit var Submit_lie : Button
    lateinit var db : FirebaseFirestore

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.type_lie)

        //db = FirebaseFirestore.getInstance()

        question_desplay = findViewById<TextView>(R.id.question_desplay)
        lie = findViewById(R.id.Lie)
        Submit_lie = findViewById<Button>(R.id.Submit_lie)

        //view question
        question_desplay.setText("وش افضل مكان بالعالم؟")

        //submit answer
        Submit_lie.setOnClickListener{
            saveLie()
           /* val intent = Intent(this,Display_Answers::class.java)
            startActivity(intent)*/
        }
    }
    /*private fun getQuestion() {
        // [START get_all_users]
        db.collection("Session/8zdNKG1g8VrCuDCeRTds/Rounds/1/Questions/1").get()
            .addOnSuccessListener { result ->
            for (document in result) {

                Log.d("DocSnippets", document.id + " => " + document.data)
            }
        }
            .addOnFailureListener { exception ->
                Log.w("DocSnippets", "Error getting documents.", exception)
            }
        // [END get_all_users]
    }*/

    private fun saveLie(){
        val getlie = lie.text.toString()

        if(getlie.isEmpty()){
            lie.error = "Type a lie"
            return
        }

        //val ref = FirebaseDatabase.getInstance().getReference("")



        question_desplay = findViewById<TextView>(R.id.question_desplay)
        question_desplay.setText("Best place in the world is ?")

        Submit_lie = findViewById<Button>(R.id.Submit_lie)

        Submit_lie.setOnClickListener {
            val intent = Intent(this, Display_Answers::class.java)
            startActivity(intent)
        }


    }

    }





