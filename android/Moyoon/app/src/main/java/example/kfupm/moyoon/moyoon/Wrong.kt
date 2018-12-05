package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.Button
import android.widget.TextView

class Wrong : AppCompatActivity(){
    private lateinit var wrongTxt : TextView
    private lateinit var score : TextView
    private lateinit var next : Button
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.wrong_answer)
        wrongTxt = findViewById(R.id.wrongTxt)
        score = findViewById(R.id.score1)
        next = findViewById(R.id.next1)
        val intent = Intent(this,Type_Lie::class.java)

        if(Global.pAnswer.isEmpty()){
            wrongTxt.text = "You didn't choose an answer!"
        }
        next.setOnClickListener{
            startActivity(intent)
        }

    }
}