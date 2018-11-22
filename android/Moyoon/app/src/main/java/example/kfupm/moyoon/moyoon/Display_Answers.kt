package example.kfupm.moyoon.moyoon

import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.ListView
import android.widget.TextView

class Display_Answers : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_display__answers)

        val question_desplay = findViewById<TextView>(R.id.quiston_at_selecton)
        question_desplay.setText("وش افضل مكان بالعالم؟")

        val nebulae = arrayOf<String>("الرياض", "جنيف", "واشنطن", "قنونا")

        val myList = findViewById(R.id.answers_list) as ListView

        var adapter= ArrayAdapter(this,android.R.layout.simple_list_item_1,nebulae)
        myList.adapter=adapter




    }
}
