package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.TextView

class Profile : AppCompatActivity() {
    lateinit var username : TextView
    lateinit var phoneNum : TextView
    lateinit var email : TextView
    lateinit var backButton : Button
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.profile_ui)
        username = findViewById<TextView>(R.id.usernameTxtV)
        phoneNum = findViewById<TextView>(R.id.phoneNumTxtV)
        email = findViewById<TextView>(R.id.emailTxtV)
        backButton = findViewById<Button>(R.id.backButton)


        var backIntent = Intent(this, MainActivity::class.java)

        username.text = Global.username
        phoneNum.text = Global.phone
        email.text = Global.emailAddress

        backButton.setOnClickListener {
            startActivity(backIntent)
        }

    }
}

