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


        db = FirebaseFirestore.getInstance()
        question_desplay = findViewById(R.id.question_desplay)

        db.collection("Session").document(Global.sessionID)
            .collection("Rounds/1/Questions/1")
            .get()
            .addOnSuccessListener { documentReference ->
                for (document in documentReference) {

                    question_desplay.setText(document.data["name"].toString())

                }
            }
            .addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }



        Submit_lie.setOnClickListener{
          //  saveLie()
            val intent = Intent(this,Display_Answers::class.java)
            startActivity(intent)
        }




    }
//




        }














