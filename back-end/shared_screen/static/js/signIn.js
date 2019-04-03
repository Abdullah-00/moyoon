$(document).ready(function(){
    var google = new firebase.auth.GoogleAuthProvider();
    var facebook = new firebase.auth.FacebookAuthProvider();

    $("#googleSignIn").bind("click",function(){
        firebase.auth().signInWithRedirect(google);
    });
    $("#facebookSignIn").bind("click",function(){
        firebase.auth().signInWithRedirect(facebook);
    });

});