package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button

class Sign_up : AppCompatActivity() {

     lateinit var button: Button
     lateinit var google: Button
    lateinit var FB: Button

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sign_up)

        button = findViewById(R.id.button)
        google = findViewById(R.id.google)
        FB = findViewById(R.id.FB)

        val mainActiv = Intent(this, MainActivity::class.java)
        val googleSign = Intent(this, Sign_in_google::class.java)
        val FBsignin = Intent(this, Sign_in_Facebook::class.java)


        button.setOnClickListener {
            startActivity(mainActiv)
        }
            google.setOnClickListener {
                startActivity(googleSign)
        }
        FB.setOnClickListener {
            startActivity(FBsignin)
        }



    }
}
