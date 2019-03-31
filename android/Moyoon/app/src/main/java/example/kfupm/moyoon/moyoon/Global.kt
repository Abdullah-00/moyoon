package example.kfupm.moyoon.moyoon


class Global{
    companion object {

        var sessionID: String = ""
        var roundID: ArrayList<String> = ArrayList()
        var roundNum : Int = 0
        var questionID: ArrayList<String> = ArrayList()
        var questionNum :Int = 0
        var playerID: String = "Cannot get you inside the session."
        var nickname: String = ""
        var question : String = ""
        var qAnswer : String = "" // Correct Answer
        var pAnswer : String = "" //Player Chosen Answer
        var playerLie : String = ""
        var LeaveSession:Boolean= true
        var KickCounter: Int = 0

        // Profile info
        var userid : String = ""
        var name :String = ""
        var emailAddress : String = ""
        var gamesPlayed : Long = 0
        var lastScore : Long = 0
        var totalScore : Long = 0
        var wins : Long = 0


// to commit
    }
}
