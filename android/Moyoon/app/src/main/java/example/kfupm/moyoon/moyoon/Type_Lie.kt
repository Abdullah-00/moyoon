package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.*
import com.google.firebase.database.*
import java.util.*


class Type_Lie : AppCompatActivity() {




    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.type_lie)



        val question_desplay = findViewById<TextView>(R.id.question_desplay)
        question_desplay.setText("Best place in the world is ?")

        val Submit_lie = findViewById<Button>(R.id.Submit_lie)

        Submit_lie.setOnClickListener {
            val intent = Intent(this, Display_Answers::class.java)
            startActivity(intent)

        }




    }


    }





