package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.Button
import android.widget.TextView


class Profile1 : AppCompatActivity() {

    lateinit var username : TextView
    lateinit var phoneNum : TextView
    lateinit var email : TextView
    lateinit var baButton : Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.profile_ui)
        username = findViewById(R.id.usernameTxtV)
        phoneNum = findViewById(R.id.phoneNumTxtV)
        email = findViewById(R.id.emailTxtV)
        baButton = findViewById(R.id.backButton)


        var backIntent = Intent(this, MainActivity::class.java)

        username.text = Global.username
        phoneNum.text = Global.phone
        email.text = Global.emailAddress

        baButton.setOnClickListener {
            startActivity(backIntent)
        }

    }
}

