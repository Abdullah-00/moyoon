package example.kfupm.moyoon.moyoon


class Global{
    companion object {

        var sessionID: String = ""
        var roundID: ArrayList<String> = ArrayList()
        var roundNum : Int = 0
        var questionID: ArrayList<String> = ArrayList()
        var questionNum :Int = 0
        var playerID: String = ""
        var nickname: String = ""
        var question : String = ""
        var qAnswer : String = "" // Correct Answer
        var pAnswer : String = "" //Player Chosen Answer
        var LeaveSession:Boolean= true

// to commit
    }
}
