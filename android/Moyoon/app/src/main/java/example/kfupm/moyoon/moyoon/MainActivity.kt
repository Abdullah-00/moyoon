package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.firestore.FirebaseFirestore

class MainActivity : AppCompatActivity() {
    //lateinit var global : Global
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
        var sID : String //Session ID
        var pNickname : String //Player Nickname
        var sessionCode : EditText = findViewById<EditText>(R.id.Sission_Code)
        var nickname : EditText = findViewById<EditText>(R.id.nickname)
        val join = findViewById<Button>(R.id.join)

        join.setOnClickListener{

            sID = sessionCode.text.toString() //Session ID
            pNickname  = nickname.text.toString()  //Player Nickname

         //   global.sessionID = sID
          //  global.playerID = pNickname
            var playerId = SendtoServer(sID, pNickname)

            if (!playerId.isEmpty()) {
                val intent = Intent(this, PlayerlistActivity::class.java)
                startActivity(intent)
            }else{
                sessionCode.setText("")
            }
        }

    }

    private fun SendtoServer(sessionID: String, pNickname: String): String {

        return "0000"
    }


}



