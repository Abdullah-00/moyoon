package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.firestore.FirebaseFirestore

class MainActivity : AppCompatActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        var sessionID : String //Session ID
        var pNickname : String //Player Nickname
        val join = findViewById<Button>(R.id.join)
        join.setOnClickListener{
            sessionID = findViewById<TextView>(R.id.Sission_Code).toString() //Session ID
            pNickname  = findViewById<TextView>(R.id.nickname).toString()  //Player Nickname
            val intent = Intent(this,PlayerlistActivity::class.java)
            startActivity(intent)
        }



    }


}

