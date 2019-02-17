package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.provider.ContactsContract
import android.util.Log
import android.view.Menu
import android.view.MenuInflater
import android.view.MenuItem
import android.view.View
import android.widget.*
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.StringRequest
import com.android.volley.toolbox.Volley
import com.google.firebase.firestore.*

class PlayerlistActivity : AppCompatActivity() {

    private lateinit var db : FirebaseFirestore
    private lateinit var players : ListView
    private var startPlay: Boolean? = true
    private lateinit var arrayAdapter : ArrayAdapter<String>
    private lateinit var intetToTypeLie :Intent
    lateinit var Home : Intent

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_playerlist)

        db = FirebaseFirestore.getInstance()
        players = findViewById<ListView>(R.id.players)
         intetToTypeLie = Intent(this, Type_Lie::class.java)



        getPlayers()

        getNumOfRounds()

        StartPlayFlag()




    }

    private fun StartPlayFlag() {

        db.collection("Session").document(Global.sessionID)
            .addSnapshotListener(EventListener<DocumentSnapshot> { document , e ->
                if (e != null) {
                    Log.w("33333", "listen:error", e)
                    return@EventListener
                }

                startPlay =  document!!.getBoolean("addPlayers")
                if (startPlay == false)
                    startActivity(intetToTypeLie)
                Global.LeaveSession = true
            }
            )
    }







        private fun getPlayers() {

                db.collection("Session").document(Global.sessionID)
            .collection("Players")
         .addSnapshotListener(EventListener<QuerySnapshot> { documentReference, e ->
            if (e != null) {
                Log.w("33333", "listen:error", e)
                return@EventListener
            }
            var ps  = ArrayList<String>()
            for (document in documentReference!!) {
                ps.add(document.getString("nick-name").toString())
            }
            arrayAdapter = list_names(this,R.layout.activity_list_names,ps)
            players.adapter = arrayAdapter

        })


}



    private fun getNumOfRounds() {
        var i =0 // for test
        //Finding NUMBER of Rounds
        db.collection("Session").document(Global.sessionID)
            .collection("Rounds").get()
            .addOnSuccessListener { k ->

                for (document in k) {
                    Global.roundID.add(document.id)
                    Log.d("Round>>>>",Global.roundID[i])
                    i++

                }

            }.addOnFailureListener { exception ->
                Log.w("PlayerlistActivity", "Error getting documents.", exception)
            }

    }

    override fun onCreateOptionsMenu(menu: Menu): Boolean {
        val inflater: MenuInflater = menuInflater
        inflater.inflate(R.menu.menu1, menu)
        return true
    }

    override fun onOptionsItemSelected(item: MenuItem): Boolean {
        // Handle item selection
        return when (item.itemId) {
            R.id.leave -> {
                Global.LeaveSession =false
                SendtoServerLeave()
                Home = Intent(this,MainActivity::class.java)
                startActivity(Home)

                true
            }

            else -> super.onOptionsItemSelected(item)
        }
    }

    private fun SendtoServerLeave() {

        val queue = Volley.newRequestQueue(this)
        val url = "http://127.0.0.1:8000/leaveSession/?session_id="+Global.sessionID+"&player_id="+Global.playerID
        Log.d("eeeeee","ohuuygu")

        // Request a string response from the provided URL.
        val stringRequest = StringRequest(
            Request.Method.GET, url,
            Response.Listener<String> { response ->
                // Display the first 500 characters of the response string.
                //  Global.nickname = response.substringAfter(",",",").trim()
                //   Global.playerID = response.substringBefore(",").trim()
                Log.d("eeeeee",Global.nickname)
            },
            Response.ErrorListener { Log.d("t", "That didn't work!") })

        // Add the request to the RequestQueue.
        queue.add(stringRequest)


    }

}

