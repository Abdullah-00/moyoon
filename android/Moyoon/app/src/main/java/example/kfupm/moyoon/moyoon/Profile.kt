package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.provider.Settings
import android.util.Log
import android.widget.ArrayAdapter
import android.widget.Button
import android.widget.ListView
import android.widget.TextView
import com.google.firebase.firestore.FirebaseFirestore
import java.util.ArrayList
import java.util.HashMap

class Profile : AppCompatActivity() {

    lateinit var name : TextView
    lateinit var level : TextView
    lateinit var backButton : Button

    private lateinit var arrayAdapter : ArrayAdapter<String>
    var ps  = ArrayList<String>()
    private lateinit var playerInformation : ListView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.profile_ui)
        name = findViewById(R.id.usernameTxtV)
        level = findViewById(R.id.userlevel)
        backButton = findViewById(R.id.backhomebutton)
        playerInformation = findViewById<ListView>(R.id.userinfo)
        val intent = Intent(this, MainActivity::class.java)

        name.text = Global.name
        backButton.setOnClickListener {
            startActivity(intent)
        }

        var lastScore = Global.lastScore.toInt()
        var totalScore = Global.totalScore.toInt()
        var gamesPlayed = Global.gamesPlayed.toInt()
        var wins = Global.wins.toInt()
        var loses = gamesPlayed - wins
        //// profile info
        ps.add("Email: \t" + Global.emailAddress)
        ps.add("Last Game Score: \t" + lastScore)
        ps.add("Total Score: \t" + totalScore)
        ps.add("#Games Played: \t" + gamesPlayed)
        ps.add("#Wins: \t" + wins)
        ps.add("#Loses: \t" + loses)

        if(loses != 0) {
            Global.ratio = Global.wins/loses.toDouble()
        }

        ps.add("Ratio: \t" + Global.ratio.toString())

        arrayAdapter = list_players_score(this,R.layout.list_players_scores,ps)
        playerInformation.adapter = arrayAdapter


        ////show level:
        if(Global.totalScore <= 100) {
            level.text = "Rookie🤓"
        }
        else if(Global.totalScore <= 250) {
            level.text = "Semi-Pro🤓"
        }
        else if(Global.totalScore <= 500) {
            level.text = "Pro🤓"
        }
        else if(Global.totalScore <= 800) {
            level.text = "Expert😌"
        }
        else if(Global.totalScore <= 1500) {
            level.text = "Master😎"
        }
        else {
            level.text = "Legend🤓"
        }

    }
}

