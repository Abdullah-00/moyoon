package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.ListView
import android.widget.TextView

class PlayerlistActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_playerlist)

        val ps = arrayOf<String>("P1", "P2", "P3", "P4")

        val myList = findViewById<TextView>(R.id.players) as ListView

        var adapter= ArrayAdapter(this,android.R.layout.simple_list_item_1,ps)
        myList.adapter=adapter

        val start = findViewById<Button>(R.id.Start)
        start.setOnClickListener{
            val intent = Intent(this,Type_Lie::class.java)
            startActivity(intent)
        }
    }
}


