//
//  ChooseAnswer.swift
//  Moyoon
//
//  Created by Rayan Alajmi on 11/30/18.
//  Copyright © 2018 KFUPM-SWE417. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import Alamofire

class ChooseAnswer: UIViewController {
    
    
    let layer = CAGradientLayer()
    
    @IBOutlet var leaveButton: UIButton!
    
    let db = Firestore.firestore()
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataArray : [String] = []
    
    var cellMarginSize = 1
    

    
    var sent = false;
    
    @IBAction func leaveSessionClicked(_ sender: Any) {
        leaveSession();
    }
    
    func leaveSession(){
        print("Sending leave Request")
        let urlExtension = "/leaveSession/"
        let parameters: Parameters = [
            "session_id": GlobalVariables.sessionId,
            "player_id": GlobalVariables.playerId
        ]
        let urlRequest = URLRequest(url: URL(string: GlobalVariables.hostname+urlExtension)!)
        let urlString = urlRequest.url?.absoluteString
        
        Alamofire.request(urlString!, parameters: parameters).response { response in

        }
        // After leave and join another variables won't reset itself
        GlobalVariables.roundId = "1";
        GlobalVariables.questionId = "1";
        GlobalVariables.submitCounter = 0;
        // End reseting variables
        
        self.performSegue(withIdentifier: "reset", sender: self)
    }
    

    
    @IBOutlet weak var timerLabel: UILabel!
    

    
    @IBOutlet var AnswersBorder: UICollectionView!
    
    @IBOutlet var QuestionBorder: UIView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setupButtons()

        
        if (GlobalVariables.isSunspended == true)
        {
            collectionView.allowsSelection = false
        }
        else
        {
            collectionView.allowsSelection = true
        }
        
        // Answeres border enhancements
        AnswersBorder.layer.cornerRadius = 10
        AnswersBorder.layer.masksToBounds = true
        
        // Question boreer enhancements
        QuestionBorder.layer.cornerRadius = 10
        QuestionBorder.layer.masksToBounds = true
        
        let questionPath = "/Session/\(GlobalVariables.sessionId)/Rounds/\(GlobalVariables.roundId)/Questions/\(GlobalVariables.questionId)"
        db.document(questionPath)
            .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                    print("Error fetching document: \(error!)")
                    return
                }
                guard let data = document.data() else {
                    print("Document data was empty.")
                    return
                }
                print("Current data: \(data)")
                if(data["isDoneChooseAnswer"] as! Bool == true){
                    self.incrementQuestionsAndRounds()
                }
        }
        
        //runTimer()

        
        
        // Set Delegates
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

        // Register cells
        self.collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        // SetupGrid view
        self.setupGridView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.setupGridView()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func getAnswers(){
        var answeresArray = [""]
        // true answer
        
        let docRef = db.collection("Session").document(GlobalVariables.sessionId).collection("Rounds").document(GlobalVariables.roundId).collection("Questions").document(GlobalVariables.questionId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //  print("Document Data -> \(document.data())")
                let q = document.data()!["Correct_Answer"] as! String
                answeresArray[0] = q
                
            } else {
                print("Could not find correct ANSWER !!!!!!!")
            }
        }
        
        // false answers
        var ansCounter = 0
        let path = "Session/\(GlobalVariables.sessionId)/Rounds/\(GlobalVariables.roundId)/Questions/\(GlobalVariables.questionId)/Answer"
        print (path)
        let docArray : [QueryDocumentSnapshot] = []
        db.collection(path).addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                
                for document in querySnapshot!.documents {
                    let ans = document.data()["Answer"] as! String
                    if(!self.dataArray.contains(ans)){
                        ansCounter += 1
                  //  self.collectionView?.performBatchUpdates({
                    //    let indexPath = IndexPath(row: self.dataArray.count, section: 0)
                        answeresArray.append(ans) //add your object to data source first
                     //   self.collectionView?.insertItems(at: [indexPath])
                      //  self.collectionView.reloadData()
                        
                //    }, completion: nil)
                    }
                }
                var i = 0
                print("Number of answeres: ", answeresArray.count)
                answeresArray.shuffle()
                if(answeresArray.count >= 2)
                {
                    while(i < answeresArray.count)
                    {
                        if(!self.dataArray.contains(answeresArray[i]))
                        {
                            self.collectionView?.performBatchUpdates({
                                let indexPath = IndexPath(row: self.dataArray.count, section: 0)
                                self.dataArray.append(answeresArray[i])
                                self.collectionView?.insertItems(at: [indexPath])
                                self.collectionView.reloadData()
                            }, completion: nil)
                        }
                        
                        i += 1
                    }
                }
                
                
            }
        }
        
        
    }

    
    override func viewWillAppear(_ animated: Bool) {
        getAnswers()
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize*10)
    }
    


    func incrementQuestionsAndRounds() {
        if ( (Int(GlobalVariables.roundId)==3) && (Int(GlobalVariables.questionId)==3) ){
            performSegue(withIdentifier: "Finished", sender: self)
            return;
        }
        if(GlobalVariables.submitCounter == 0 && Int(GlobalVariables.questionId) == 3)
        {
            leaveSession();
            return;
        }
        GlobalVariables.questionId = String(Int(GlobalVariables.questionId)!+1)
        if(Int(GlobalVariables.questionId)! == 4){
            GlobalVariables.submitCounter = 0;
            GlobalVariables.questionId = String(1)
            GlobalVariables.roundId = String(Int(GlobalVariables.roundId)!+1)
        }
        
        performSegue(withIdentifier: "SelectToType", sender: self)
    }
}




extension ChooseAnswer: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegate {
    
    func collectionView(_: UICollectionView, prefetchItemsAt: [IndexPath]){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(!sent){
            GlobalVariables.submitCounter += 1;
            sent=true;
            collectionView.allowsSelection = false;
            if let cell = collectionView.cellForItem(at: indexPath) as? ItemCell {
                cell.backgroundColor = UIColor.orange
                sendAnswerToAPI(answer: cell.textLabel.text!)
            }
        }
    }
    
    
    func sendAnswerToAPI(answer: String)
    {
        print("Answer Selection Sent : \(answer)")
        let urlExtension = "/SubmitAnswerChoice/"
        let parameters: Parameters = [
            "player_id": GlobalVariables.playerId,
            "session_id": GlobalVariables.sessionId,
            "question_id": GlobalVariables.questionId,
            "round_id": GlobalVariables.roundId,
            "answer": answer
        ]
        let urlRequest = URLRequest(url: URL(string: GlobalVariables.hostname+urlExtension)!)
        let urlString = urlRequest.url?.absoluteString
        
        Alamofire.request(urlString!, parameters: parameters).response { response in
            
            if let data = response.data, let result = String(data: data, encoding: .utf8) {
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.reloadData()
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.setData(text: self.dataArray[indexPath.row])
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        cell.layer.shadowOffset = CGSize(width: 0, height: 20)
        cell.layer.shadowRadius = 25
        cell.layer.shadowOpacity = 1
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor(red: 255, green: 255, blue: 255, alpha: 1).cgColor;
        return cell
    }
    
    func setupBackground()
    {
        // Setup Background
        layer.frame = view.bounds
        layer.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor /* #000000 */, UIColor(red: 0, green: 0.696, blue: 0.766, alpha: 1).cgColor /* #00B2C3 */]
        layer.locations = [0, 0.757]
        layer.startPoint = CGPoint(x: 0.311, y: 1.098)
        layer.endPoint = CGPoint(x: 0.689, y: -0.098)
        self.view.layer.insertSublayer(layer, at: 0)
        
                collectionView.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    func setupButtons()
    {
        // Setup buttons
        leaveButton.layer.masksToBounds = true
        leaveButton.layer.cornerRadius = 5
        leaveButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2).cgColor /* #000000 */
        leaveButton.layer.shadowOffset = CGSize(width: 0, height: 20)
        leaveButton.layer.shadowRadius = 25
        leaveButton.layer.shadowOpacity = 1
        
    }
    
}

extension ChooseAnswer: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: width/2)
    }
    
    func calculateWith() -> CGFloat {
        let cellCount = floor(CGFloat(2))
        
        let margin = CGFloat(1)
        let width = ((self.view.frame.size.width/cellCount) - CGFloat(cellMarginSize) - (cellCount*margin*4)-(margin*cellCount*8))
        
        return width
    }
    
    
    
    
}





