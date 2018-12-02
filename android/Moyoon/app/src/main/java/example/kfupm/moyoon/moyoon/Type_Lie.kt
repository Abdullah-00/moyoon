package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.*
import com.google.firebase.firestore.FirebaseFirestore
import com.google.firebase.firestore.FirebaseFirestoreException
import com.google.firebase.firestore.FirebaseFirestoreSettings
import java.util.*


class Type_Lie : AppCompatActivity() {

    lateinit var question_desplay : TextView
    lateinit var lie : EditText
    lateinit var Submit_lie : Button

    val db = FirebaseFirestore.getInstance()
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.type_lie)


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

    private fun saveLie(){
        val getlie = lie.text.toString()

        if(getlie.isEmpty()){
            lie.error = "Type a lie"
            return
        }

        //val ref = FirebaseDatabase.getInstance().getReference("")



        val question_desplay = findViewById<TextView>(R.id.question_desplay)
        question_desplay.setText("Best place in the world is ?")

        val Submit_lie = findViewById<Button>(R.id.Submit_lie)

        Submit_lie.setOnClickListener {
            val intent = Intent(this, Display_Answers::class.java)
            startActivity(intent)

        }





    }


    }





