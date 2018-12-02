# Web API
## Create Session API
### Number of parameters : 3 
1. catagory_id // chosen by the user 
2. is_provided // For the time being this should always be False
3. questions // For the time being this should always be empty string

### Returns String: session_id
#### Example: <br/>
session/?catagory_id=6&is_provided=False&questions=jhcusgcziu

# Mobile API
## Enter Session API <br/> 
### Number of parameters : 2 <br/> 
1. nick_name
2. session_id // Taken from web page (screen) 

### Returns string: player_id

#### Example: <br/>
 enterSession/?session_id=CSC8hsgaLCwz6OcLmblN&nick_name=mo3sw



## Submit Answer API <br/> 
### Number of parameters : 5 <br/> 

1. player_id //which was returned in the previous API
2. session_id // Taken from web page (screen)
3. round_id  // taken from Firabase 
4. question_id // taken from Firbase 
5. answer // written by the user 

#### Example:<br/>
SubmitAnswer/?session_id=CSC8hsgaLCwz6OcLmblN&round_id=1&question_id=1&player_id=9fCmtNjkb0OavZX8mdYO&answer=6




## Submit Answer Choice API <br/> 
### Number of parameters : 5 <br/> 
// This method is under development **Logic and parameters might change**

1. player_id //which was returned in the previous API
2. session_id // Taken from web page (screen)
3. round_id  // taken from Firabase 
4. question_id // taken from Firbase 
5. answer // Chosen by the user 


#### Example:<br/>
SubmitAnswerChoice/?session_id=CSC8hsgaLCwz6OcLmblN&round_id=1&question_id=1&player_id=9fCmtNjkb0OavZX8mdYO&answer=6

