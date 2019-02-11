package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Button
import android.widget.EditText
import android.widget.ImageButton
import com.android.volley.Request
import com.android.volley.Response
import com.android.volley.toolbox.*


class MainActivity : AppCompatActivity() {

    private lateinit var nickname: EditText //Nickname Input
    private lateinit var sessionCode: EditText
    private lateinit var join: ImageButton
    private lateinit var login: ImageButton
    private lateinit var joinRandom: Button


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)


        sessionCode = findViewById<EditText>(R.id.Sission_Code)
        nickname = findViewById<EditText>(R.id.nickname)
        join = findViewById(R.id.join)
        login = findViewById(R.id.login)
        joinRandom = findViewById(R.id.joinR)

        val intent = Intent(this, PlayerlistActivity::class.java)
        val intent2 = Intent(this, Sign_up::class.java)


        join.setOnClickListener {
            Global.sessionID = sessionCode.text.toString() //Session ID
            Global.nickname = nickname.text.toString().trim()  //Player Nickname
            SendtoServer()
           // Global.playerID=playerId
            startActivity(intent)

            }
        login.setOnClickListener {

            startActivity(intent2)

        }

    }

    private fun SendtoServer() {

        val queue = Volley.newRequestQueue(this)
        val url = "http://68.183.67.247:8000/enterSession/?session_id="+Global.sessionID+"&nick_name="+Global.nickname
        // Request a string response from the provided URL.
        val stringRequest = StringRequest(Request.Method.GET, url,
            Response.Listener<String> { response ->
                // Display the first 500 characters of the response string.
                Global.playerID = response
                Log.d("T","tttttttttt")
            },
            Response.ErrorListener { Log.d("t", "That didn't work!") })

        // Add the request to the RequestQueue.
        queue.add(stringRequest)


    }

}

