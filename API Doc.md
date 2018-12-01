




Enter Session API <br/> Number of parameters : 2 <br/> 
1. nick_name
2. session_id // Taken from web page (screen) 

It will return Player ID

Example: <br/>
 enterSession/?session_id=CSC8hsgaLCwz6OcLmblN&nick_name=mo3sw


Submit Answer API <br/> Number of parameters : 5 <br/> 

1. player_id //which was returned in the previous API
2. session_id // Taken from web page (screen)
3. round_id  // taken from Firabase 
4. question_id // taken from Firbase 
5. answer // written by the user 

Example:<br/>
SubmitAnswer/?session_id=CSC8hsgaLCwz6OcLmblN&round_id=1&question_id=1&player_id=9fCmtNjkb0OavZX8mdYO&answer=6




Submit Answer Choice API <br/> Number of parameters : 5 <br/> 
// This method is under development **Logic and parameters might change**

1. player_id //which was returned in the previous API
2. session_id // Taken from web page (screen)
3. round_id  // taken from Firabase 
4. question_id // taken from Firbase 
5. answer // Chosen by the user 

Example:<br/>
SubmitAnswerChoice/?session_id=CSC8hsgaLCwz6OcLmblN&round_id=1&question_id=1&player_id=9fCmtNjkb0OavZX8mdYO&answer=6

