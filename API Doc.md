




enterSessionView has 2 parameters 
1. nick_name
2. session_id // Taken from web page (screen) 

It will return Player ID

Example: <br/>
 enterSession/?session_id=CSC8hsgaLCwz6OcLmblN&nick_name=mo3sw


SubmitAnswerView has 5 parameters 

1. player_id //which was returned in the previous API
2. session_id // Taken from web page (screen)
3. round_id  // taken from Firabase 
4. question_id // taken from Firbase 
5. answer // written by the user 

Example:<br/>
SubmitAnswer/?session_id=CSC8hsgaLCwz6OcLmblN&round_id=1&question_id=1&player_id=9fCmtNjkb0OavZX8mdYO&answer=6




SubmitAnswerChoice has 5 parameters 
// This method is under development **Logic and parameters might change**

1. player_id //which was returned in the previous API
2. session_id // Taken from web page (screen)
3. round_id  // taken from Firabase 
4. question_id // taken from Firbase 
5. answer // Chosen by the user 

Example:<br/>
SubmitAnswerChoice/?session_id=CSC8hsgaLCwz6OcLmblN&round_id=1&question_id=1&player_id=9fCmtNjkb0OavZX8mdYO&answer=6

