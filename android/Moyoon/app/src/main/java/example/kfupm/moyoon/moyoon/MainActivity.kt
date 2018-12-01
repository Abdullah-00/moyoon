package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        val join = findViewById<Button>(R.id.join)
        join.setOnClickListener{
            val intent = Intent(this,Type_Lie::class.java)
            startActivity(intent)
        }

        val ref = FirebaseDatabase.getInstance().getReference("");

    }

}

