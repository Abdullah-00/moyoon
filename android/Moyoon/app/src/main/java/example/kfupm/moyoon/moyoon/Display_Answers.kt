package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.os.Handler
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.*
import java.util.*
import kotlin.concurrent.timerTask

class Display_Answers : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_display__answers)

        val question_desplay = findViewById<TextView>(R.id.quiston_at_selecton)
        question_desplay.setText("وش افضل مكان بالعالم؟")

        val nebulae = arrayOf<String>("الرياض", "جنيف", "واشنطن", "قنونا")

        val myList = findViewById<TextView>(R.id.answers_list) as ListView

        var adapter= ArrayAdapter(this,android.R.layout.simple_list_item_1,nebulae)
        myList.adapter=adapter

        val intent = Intent(this,Correct_Answer::class.java)
        val timer = Timer()
        timer.schedule(timerTask {startActivity(intent)}, 3000)

        /* Another way to make the next activity launch in 10 sec
        Handler().postDelayed({
           val intent = Intent(this,Correct_Answer::class.java)
            startActivity(intent)
        }, 10000)*/


    }
}
