package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.Button
import android.widget.TextView

class Correct : AppCompatActivity(){
    lateinit var correctTxt : TextView
    lateinit var score : TextView
    lateinit var next : Button
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.correct_answer)
        correctTxt = findViewById(R.id.correctTxt)
        score = findViewById(R.id.score)
        next = findViewById(R.id.next)
        val intent = Intent(this,Type_Lie::class.java)

        next.setOnClickListener{
            startActivity(intent)
        }
    }
}