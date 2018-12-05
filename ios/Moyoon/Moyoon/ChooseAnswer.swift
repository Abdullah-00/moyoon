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

class ChooseAnswer: UIViewController {
    

    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataArray : [String] = []
    
    var estimateWidth = 80.0
    var cellMarginSize = 10.0
    

    var seconds = 11 //This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer =  Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(WriteAnswer.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @objc func updateTimer() {
        seconds -= 1     //This will decrement(count down)the seconds.
        timerLabel.text = "\(seconds)" //This will update the label.
        if(seconds < 1){
            timer.invalidate()
            incrementQuestionsAndRounds()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let questionPath = "/Session/\(GlobalVariables.sessionId)/Rounds/\(GlobalVariables.roundId)/Questions/\(GlobalVariables.questionId)"
        Firestore.firestore().document(questionPath)
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
                    self.timer.invalidate()
                    self.incrementQuestionsAndRounds()
                }
        }
        
        runTimer()
        
        
        
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

        // false answers
        let db = Firestore.firestore()
        let path = "Session/\(GlobalVariables.sessionId)/Rounds/\(GlobalVariables.roundId)/Questions/\(GlobalVariables.questionId)/Answer"
        print (path)
        db.collection(path).addSnapshotListener() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let ans = document.data()["Answer"] as! String
                    if(!self.dataArray.contains(ans)){
                    self.collectionView?.performBatchUpdates({
                        let indexPath = IndexPath(row: self.dataArray.count, section: 0)
                        self.dataArray.append(ans) //add your object to data source first
                        self.collectionView?.insertItems(at: [indexPath])
                        self.collectionView.reloadData()
                    }, completion: nil)
                    }
                }
            }
        }
        
        // true answer
        
        let docRef = db.collection("Session").document(GlobalVariables.sessionId).collection("Rounds").document(GlobalVariables.roundId).collection("Questions").document(GlobalVariables.questionId)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                print("Document Data -> \(document.data())")
                let q = document.data()!["Correct_Answer"] as! String
                self.collectionView?.performBatchUpdates({
                    let indexPath = IndexPath(row: self.dataArray.count, section: 0)
                    self.dataArray.append(q) //add your object to data source first
                    self.collectionView?.insertItems(at: [indexPath])
                    self.collectionView.reloadData()
                }, completion: nil)
            } else {
                print("Could not find correct ANSWER !!!!!!!")
            }
    }
    }

    
    override func viewWillAppear(_ animated: Bool) {

        getAnswers()
    }
    
    func setupGridView() {
        let flow = collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        flow.minimumInteritemSpacing = CGFloat(self.cellMarginSize)
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    // MARK: UITableViewDataSource
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func selectAnswer(_ sender: Any) {
        submitButton.isEnabled = false;
}

    func incrementQuestionsAndRounds() {
        GlobalVariables.sent = false;
        if ( (Int(GlobalVariables.roundId)==3) && (Int(GlobalVariables.questionId)==3) ){
            performSegue(withIdentifier: "Finished", sender: self)
            return;
        }
        GlobalVariables.questionId = String(Int(GlobalVariables.questionId)!+1)
        if(Int(GlobalVariables.questionId)! == 4){
            GlobalVariables.questionId = String(1)
            GlobalVariables.roundId = String(Int(GlobalVariables.roundId)!+1)
        }
        performSegue(withIdentifier: "SelectToType", sender: self)
    }
}




extension ChooseAnswer: UICollectionViewDataSource, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_: UICollectionView, prefetchItemsAt: [IndexPath]){
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
     //   print("section: \(indexPath.row)")

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        collectionView.reloadData()
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.setData(text: self.dataArray[indexPath.row])
        
        return cell
    }
}

extension ChooseAnswer: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.calculateWith()
        return CGSize(width: width, height: width)
    }
    
    func calculateWith() -> CGFloat {
        let estimatedWidth = CGFloat(estimateWidth)
        let cellCount = floor(CGFloat(self.view.frame.size.width / estimatedWidth))
        
        let margin = CGFloat(cellMarginSize * 2)
        let width = (self.view.frame.size.width - CGFloat(cellMarginSize) * (cellCount - 1) - margin) / cellCount
        
        return width
    }
}



