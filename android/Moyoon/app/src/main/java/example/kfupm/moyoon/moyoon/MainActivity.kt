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
    lateinit var sID : String //Session ID
    lateinit var pNickname : String //Player Nickname
    lateinit var playerId : String
    lateinit var nickname : EditText //Nickname Input
    lateinit var sessionCode : EditText
    lateinit var join : Button
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        sessionCode = findViewById<EditText>(R.id.Sission_Code)
        nickname = findViewById<EditText>(R.id.nickname)
        join = findViewById(R.id.join)
        val intent = Intent(this, PlayerlistActivity::class.java)

        join.setOnClickListener{
            sID = sessionCode.text.toString() //Session ID
            pNickname  = nickname.text.toString()  //Player Nickname

            playerId = SendtoServer() //sID, pNickname

            if (!playerId.isEmpty()) {
                //Global.sessionID = sID
                Global.playerID = playerId
                Global.nickname = pNickname

                startActivity(intent)
            }else{
                sessionCode.setHint("must enter code ")
            }
        }



    }

    private fun SendtoServer(): String {

        return "0000"
    }


}