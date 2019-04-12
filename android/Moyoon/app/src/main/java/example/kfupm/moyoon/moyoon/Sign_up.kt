package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.ImageButton

class Sign_up : AppCompatActivity() {

    // lateinit var guest: ImageButton
     lateinit var google: Button
    lateinit var FB: Button
    lateinit var backHome : Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sign_up)

        google = findViewById(R.id.google)
        FB = findViewById(R.id.FB)
        backHome = findViewById(R.id.backHome)

        val googleSign = Intent(this, Sign_in_google::class.java)
        val FBsignin = Intent(this, Sign_in_Facebook::class.java)
        val back = Intent(this, MainActivity::class.java)


        backHome.setOnClickListener {
            startActivity(back)
        }
        google.setOnClickListener {
                startActivity(googleSign)
        }
        FB.setOnClickListener {
            startActivity(FBsignin)
        }



    }
}
