package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button

class EndOfGame : AppCompatActivity() {
    private lateinit var EndHome: Button


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_end_of_game)

        EndHome = findViewById<Button>(R.id.EndHome)
        val intent = Intent(this, MainActivity::class.java)

        EndHome.setOnClickListener {

            startActivity(intent)
        }
    }
}
