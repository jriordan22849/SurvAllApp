//
//  SelectTitleViewController.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 13/02/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import UIKit

class SelectTitleViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionField: UILabel!
    
    

    var surveyTitle = "No Title"
    var questionLabel = [String]()
    var surveybelongto = [String]()
    var questionNumber = [String]()
    var numberOfAnswers = [String]()

    var currentQuestionCounter = 0
    
    @IBAction func nextButton(_ sender: Any) {
        
        questionField.text = questionLabel[currentQuestionCounter]
        print(questionLabel[currentQuestionCounter])
        
        if currentQuestionCounter < questionLabel.count {
            currentQuestionCounter += 1
        } else {
            currentQuestionCounter = 0
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(surveyTitle)
        titleLabel.text = surveyTitle
        questionField.text =  ""
        self.getAllSurveys()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    
    func getAllSurveys() {
        
        let url:String = "http://survall.top:8000/questionData/"
        
        HTTPRequest.getAllInBackground(url: url) { (completed, data) in
            
            DispatchQueue.main.async {
                if completed {
                    
                    for record in data! {
                        
                        if let survey = record as? [String:Any] {
                            
                            if let surveyRow = survey["fields"] as? [String:Any] {
                         

                                // Get survey questions based on the survey title, return results to an array.
                                if(surveyRow["surveybelongto"] as! String == self.surveyTitle) {
                                    self.questionLabel.append(surveyRow["questionLabel"] as! String)
                                }
                                print(self.questionLabel)
                                
                                //let fiteredArray = (self.surveybelongto ).filter { $0 == self.surveyTitle }
                                //print(self.questionLabel)
                                //self.detailData.append(surveyRow["numOfQuestions"] as! String)
                                //self.tableView.reloadData()
                            }
                        }
                    }
                    print("Number of Questions \(self.questionLabel.count)")                    
                }
            }
        }
    }

}
