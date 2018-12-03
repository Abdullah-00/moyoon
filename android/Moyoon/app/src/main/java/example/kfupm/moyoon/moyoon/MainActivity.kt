package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.EditText
import android.widget.TextView
import com.android.volley.Request
import com.android.volley.RequestQueue
import com.android.volley.Response
import com.android.volley.toolbox.*
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
    lateinit var x : String
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        /// API
        /// vvvvvv CHECK THIS OUT vvvvvv
        // Instantiate the cache
        val cache = DiskBasedCache(cacheDir, 1024 * 1024) // 1MB cap

        // Set up the network to use HttpURLConnection as the HTTP client.
        val network = BasicNetwork(HurlStack())

        // Instantiate the RequestQueue with the cache and network. Start the queue.
        val requestQueue = RequestQueue(cache, network).apply {
            start()
        }

        val url = "http://localhost:8000/enterSession/?session_id="+Global.sessionID +"&nick_name=Ibraheem"
       // val url = "http://www.google.com" //<<<<<<<<<<<<<<<<<< PUT SERVER URL HERE

        // Request a string response from the provided URL.
        val stringRequest = StringRequest(Request.Method.GET, url,
            Response.Listener<String> { response ->
                // Do something with the response
               Global.playerID = response
            },
            Response.ErrorListener { error ->
                // Handle error
                x = "ERROR: %s".format(error.toString())
                print(x + "<<<<<<<<<<<<<<<<<<<<<<< PLAYERID")
            })
        requestQueue.add(stringRequest)
        // Add the request to the RequestQueue.
        //queue.add(stringRequest)
        /// ^^^^^^ CHECK THIS OUT ^^^^^^

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