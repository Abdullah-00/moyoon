package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.TextView
import com.google.firebase.firestore.FirebaseFirestore
import java.util.HashMap

class Profile : AppCompatActivity() {

    lateinit var name : TextView
    lateinit var email : TextView
    lateinit var gamesPlayed : TextView
    lateinit var lastScore : TextView
    lateinit var totalScore : TextView
    lateinit var wins : TextView
    lateinit var modifeyButton : Button
    private var db : FirebaseFirestore = FirebaseFirestore.getInstance()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.profile_ui)
        name = findViewById(R.id.usernameTxtV)
        email = findViewById(R.id.emailTxtV)
        gamesPlayed = findViewById(R.id.gamesPLayedTxtV)
        lastScore = findViewById(R.id.lastScoreTxtV)
        totalScore = findViewById(R.id.totalScoreTxtV)
        wins = findViewById(R.id.winsTxtV)

        ///Modify button
        modifeyButton = findViewById(R.id.modifyButton)

        modifeyButton.setOnClickListener(){
            reset()
            name.text = Global.name
            email.text = Global.emailAddress
            gamesPlayed.text = Global.gamesPlayed.toString()
            lastScore.text = Global.lastScore.toString()
            totalScore.text = Global.totalScore.toString()
            wins.text = Global.wins.toString()
        }


        name.text = Global.name
        email.text = Global.emailAddress
        gamesPlayed.text = Global.gamesPlayed.toString()
        lastScore.text = Global.lastScore.toString()
        totalScore.text = Global.totalScore.toString()
        wins.text = Global.wins.toString()
    }
    private fun reset() {
        val note = HashMap<String, Any>()
        Global.gamesPlayed = 0
        Global.lastScore = 0
        Global.totalScore = 0
        Global.wins = 0
        note.put("displayName", Global.name)
        note.put("email", Global.emailAddress)
        note.put("gamesPlayed", Global.gamesPlayed)
        note.put("lastScore", Global.lastScore)
        note.put("totalScore", Global.totalScore)
        note.put("wins", Global.wins)
        db.collection("Players").document(Global.userid).set(note)
            .addOnSuccessListener {
                Log.w("TAG001", "Document Created.")
            }.addOnFailureListener {
                Log.w("TAG001", "Document Is not Created.")
            }
    }
}

