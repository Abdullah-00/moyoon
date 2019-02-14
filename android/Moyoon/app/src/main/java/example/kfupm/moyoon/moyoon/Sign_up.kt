package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.ImageButton

class Sign_up : AppCompatActivity() {

     lateinit var guest: ImageButton
     lateinit var google: ImageButton
    lateinit var FB: ImageButton

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sign_up)

     guest = findViewById(R.id.button)
        google = findViewById(R.id.google)
        FB = findViewById(R.id.FB)

        val mainActiv = Intent(this, MainActivity::class.java)
        val googleSign = Intent(this, Sign_in_google::class.java)
        val FBsignin = Intent(this, Sign_in_Facebook::class.java)


        guest.setOnClickListener {
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
