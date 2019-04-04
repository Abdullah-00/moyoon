package example.kfupm.moyoon.moyoon

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.Button
import android.widget.TextView
import android.widget.Toast
import com.facebook.*
import com.facebook.FacebookSdk;
import com.facebook.appevents.AppEventsLogger;
import com.facebook.login.LoginResult
import com.google.android.gms.common.SignInButton
import com.google.firebase.auth.FacebookAuthProvider
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.auth.FirebaseUser
import com.google.firebase.firestore.FirebaseFirestore
import kotlinx.android.synthetic.main.activity_sign_in__facebook.*
import java.util.HashMap


class Sign_in_Facebook : AppCompatActivity() {

    private lateinit var auth: FirebaseAuth
    lateinit var Sign_outF: Button
    lateinit var goPlayF: Button
    lateinit var texvF: TextView
    var callbackManager:CallbackManager? = null
    //  lateinit var buttonFacebookLogin : SignInButton

    private var db : FirebaseFirestore = FirebaseFirestore.getInstance()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_sign_in__facebook)
        FacebookSdk.sdkInitialize(getApplicationContext());
        AppEventsLogger.activateApp(this);

// ...
// Initialize Firebase Auth
        auth = FirebaseAuth.getInstance()
         callbackManager = CallbackManager.Factory.create();// Initialize Facebook Login button
        Sign_outF = findViewById(R.id.Sign_out)
        goPlayF = findViewById(R.id.GoPlay)
        val out = Intent(this, Sign_up::class.java)
        val play = Intent(this, MainActivity::class.java)

        Sign_out.visibility = View.INVISIBLE
        goPlayF.visibility = View.INVISIBLE

        Sign_outF.setOnClickListener {
            FirebaseAuth.getInstance().signOut()
            Global.LoginUiFlag = false
            startActivity(out)
        }

        goPlayF.setOnClickListener {
            startActivity(play)
        }

        login_button.setOnClickListener {

            login_button.setReadPermissions("email", "public_profile")
            login_button.registerCallback(callbackManager, object : FacebookCallback<LoginResult> {
                override fun onSuccess(loginResult: LoginResult) {
                    Log.d("TAG", "facebook:onSuccess:$loginResult")
                    handleFacebookAccessToken(loginResult.accessToken)
                    Global.LoginUiFlag = true
                }

                override fun onCancel() {
                    Log.d("TAG", "facebook:onCancel")
                    // ...
                }

                override fun onError(error: FacebookException) {
                    Log.d("TAG", "facebook:onError", error)
                    // ...
                }
            })
            // ...
        }

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        // Pass the activity result back to the Facebook SDK
        callbackManager!!.onActivityResult(requestCode, resultCode, data)
    }

   /* public override fun onStart() {
        super.onStart()
        // Check if user is signed in (non-null) and update UI accordingly.
        val currentUser = auth.currentUser
        updateUI(currentUser)
    }*/

    private fun handleFacebookAccessToken(token: AccessToken) {
        Log.d("TAG", "handleFacebookAccessToken:$token")

        val credential = FacebookAuthProvider.getCredential(token.token)
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
                    Toast.makeText(baseContext, "Authentication failed.",
                        Toast.LENGTH_SHORT).show()
                    updateUI(null)
                }

                // ...
            }
    }

    private fun updateUI(user: FirebaseUser?) {
        texvF= findViewById<TextView>(R.id.UserName)
        texvF.text = "Welcome \n" + user?.displayName


        Global.name = user?.displayName.toString()
        Global.emailAddress = user?.email.toString()
        Global.userid = user?.uid.toString()
        Global.signedIn = true
        getInformation(Global.userid)

        Sign_out.visibility = View.VISIBLE
        goPlayF.visibility = View.VISIBLE
    }
    private fun getInformation(userid : String){
        db.collection("Players").document(Global.userid).get()
            .addOnSuccessListener { documentReference ->
                Log.w("TAG001", "documentReference:  " + documentReference)
                if(documentReference.exists()) {
                    Log.w("TAG001", "Successssss")
                    Global.name = documentReference.data!!["displayName"].toString()
                    Global.emailAddress = documentReference.data!!["email"].toString()
                    Global.gamesPlayed = documentReference.data!!["gamesPlayed"] as Long
                    Global.lastScore = documentReference.data!!["lastScore"] as Long
                    Global.totalScore = documentReference.data!!["totalScore"] as Long
                    Global.wins = documentReference.data!!["wins"] as Long
                }else {
                    Log.w("TAG001", "Fialure")
                    val note = HashMap<String, Any>()
                    note.put("displayName", Global.name)
                    note.put("email", Global.emailAddress)
                    note.put("gamesPlayed", Global.gamesPlayed)
                    note.put("lastScore", Global.lastScore)
                    note.put("totalScore", Global.totalScore)
                    note.put("wins", Global.wins)
                    db.collection("Players").document(Global.userid).set(note)
                        .addOnSuccessListener {
                            Log.w("TAG001", "Document Created.")
                        }.addOnFailureListener {
                            Log.w("TAG001", "Document Is not Created.")
                        }
                }
            }
            .addOnFailureListener { exception ->
                Log.w("TAG001", "Document Is not Created.111", exception)
            }
    }
}

