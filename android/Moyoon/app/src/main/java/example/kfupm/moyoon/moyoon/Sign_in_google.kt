package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.TextView
import com.google.android.gms.auth.api.signin.GoogleSignIn
import com.google.android.gms.auth.api.signin.GoogleSignInAccount
import com.google.android.gms.auth.api.signin.GoogleSignInClient
import com.google.android.gms.auth.api.signin.GoogleSignInOptions
import com.google.android.gms.common.SignInButton
import com.google.android.gms.common.api.ApiException
import com.google.firebase.auth.FacebookAuthProvider
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.auth.GoogleAuthProvider
import kotlinx.android.synthetic.main.activity_sign_in_google.*

class Sign_in_google : AppCompatActivity() {

    lateinit var mGoogleSignInClient:GoogleSignInClient
    val RC_SIGN_IN:Int =1
     lateinit var auth: FirebaseAuth
     lateinit var sign_in_button: SignInButton
    lateinit var Sign_out: Button
    lateinit var goPlay: Button
    lateinit var texv: TextView
    lateinit var gso: GoogleSignInOptions


    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sign_in_google)
        sign_in_button = findViewById(R.id.sign_in_button)
        Sign_out = findViewById(R.id.Sign_out)
        goPlay = findViewById(R.id.GoPlay)
        val out = Intent(this, Sign_up::class.java)
        val play = Intent(this, MainActivity::class.java)

        // Configure Google Sign In
         gso = GoogleSignInOptions.Builder(GoogleSignInOptions.DEFAULT_SIGN_IN)
            .requestIdToken("118454694024-cr6g04kkro3af1ovm8cannt525uhv3mo.apps.googleusercontent.com")
            .requestEmail()
            .build()
        // Build a GoogleSignInClient with the options specified by gso.
        mGoogleSignInClient = GoogleSignIn.getClient(this, gso);
        // Initialize Firebase Auth
        auth = FirebaseAuth.getInstance()

        Sign_out.visibility = View.VISIBLE
        Sign_out.visibility = View.INVISIBLE
        goPlay.visibility = View.INVISIBLE

        sign_in_button.setOnClickListener {
            signIn()
        }

        Sign_out.setOnClickListener {
            FirebaseAuth.getInstance().signOut()
            startActivity(out)
        }

        goPlay.setOnClickListener {
            startActivity(play)
        }



    }

    private fun signIn() {
        val signInIntent = mGoogleSignInClient.signInIntent
        startActivityForResult(signInIntent, RC_SIGN_IN)
    }

    public override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        // Result returned from launching the Intent from GoogleSignInApi.getSignInIntent(...);
        if (requestCode == RC_SIGN_IN) {
            val task = GoogleSignIn.getSignedInAccountFromIntent(data)
            Log.w("TAG", "If")
            try {
                // Google Sign In was successful, authenticate with Firebase
                val account = task.getResult(ApiException::class.java)
                Log.w("TAG", "Try")

                firebaseAuthWithGoogle(account!!)
                Log.w("TAG", "Try2")

            } catch (e: ApiException) {
                // Google Sign In failed, update UI appropriately
                Log.w("TAG", "Google sign in failed", e)
                // ...
            }
        }
    }


    private fun firebaseAuthWithGoogle(acct: GoogleSignInAccount) {
        Log.d("Tag", "firebaseAuthWithGoogle:" + acct.id!!)

        val credential = GoogleAuthProvider.getCredential(acct.idToken, null)
        auth.signInWithCredential(credential)
            .addOnCompleteListener(this) { task ->
                if (task.isSuccessful) {
                    // Sign in success, update UI with the signed-in user's information
                    Log.d("TAG", "signInWithCredential:success")
                    val user = auth.currentUser
                    updateUI(user)
                } else {
                    // If sign in fails, display a message to the user.
                    Log.w("TAG", "signInWithCredential:failure", task.exception)
                  //  Snackbar.make(main_layout, "Authentication Failed.", Snackbar.LENGTH_SHORT).show()
                    updateUI(null)
                }

                // ...
            }
    }

    private fun updateUI(user: FirebaseUser?) {
        texv= findViewById<TextView>(R.id.UserName)
        texv.text = "Welcom " + user?.displayName

        Global.username = user?.displayName.toString()
        Global.emailAddress = user?.email.toString()
        Global.phone = user?.phoneNumber.toString()

        sign_in_button.visibility - View.INVISIBLE
        Sign_out.visibility = View.VISIBLE
        goPlay.visibility = View.VISIBLE
    }
}
