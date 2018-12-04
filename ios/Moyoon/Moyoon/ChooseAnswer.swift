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
    

    var seconds = 10 //This variable will hold a starting value of seconds. It could be any amount above 0.
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
            performSegue(withIdentifier: "SelectToType", sender: self)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        //dataArray = []
        let db = Firestore.firestore()
        let path = "Session/\(GlobalVariables.sessionId)/Rounds/\(GlobalVariables.roundId)/Questions/\(GlobalVariables.questionId)/Answer"
        print (path)
        db.collection(path).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let ans = document.data()["Answer"] as! String
                    self.collectionView?.performBatchUpdates({
                        let indexPath = IndexPath(row: self.dataArray.count, section: 0)
                        self.dataArray.append(ans) //add your object to data source first
                        print (ans)
                        self.collectionView?.insertItems(at: [indexPath])
                    }, completion: nil)
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
        flow.minimumLineSpacing = CGFloat(self.cellMarginSize)
    }
    
    // MARK: UITableViewDataSource
    @IBOutlet weak var submitButton: UIButton!
    
    @IBAction func selectAnswer(_ sender: Any) {
        submitButton.isEnabled = false;
}

    func incrementQuestionsAndRounds() {
        if ((Int(GlobalVariables.roundId))==3){
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



