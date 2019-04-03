function refresh(sessionID) {
    console.log(sessionID);
    // Initialize Firebase
    var config = {
        apiKey: "***REMOVED***",
        authDomain: "moyoon-abikmmr.firebaseapp.com",
        databaseURL: "https://moyoon-abikmmr.firebaseio.com",
        projectId: "moyoon-abikmmr",
        storageBucket: "moyoon-abikmmr.appspot.com",
        messagingSenderId: "118454694024"
    };
    firebase.initializeApp(config);

    // Initialize Cloud Firestore through Firebase
    var db = firebase.firestore();

    // Disable deprecated features
    db.settings({
        timestampsInSnapshots: true
    });

    const output = document.querySelector("#list");

    db.collection("Session/" + sessionID + "/Players").orderBy("Score", "desc")
        .onSnapshot(function (querySnapshot) {
            output.innerHTML = "";
            querySnapshot.forEach(function (doc) {
                var data = doc.data();
                var nickName = data["nick-name"];
                var score = data["Score"];
                output.innerHTML += "<li> <mark>" + nickName + "</mark> <small>" + score + "</small> </li>";
            });
            console.log(sessionID);
        });
    // db.collection("Session").get().then((querySnapshot) => {
    //     querySnapshot.forEach((doc) => {
    //         console.log(`${doc.id} => ${doc.data()}`);
    //     });
    // });
}