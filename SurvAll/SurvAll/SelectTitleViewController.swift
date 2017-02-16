//
//  SelectTitleViewController.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 13/02/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import UIKit

class SelectTitleViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerTable: UITableView!

    var surveyTitle = "No Title"
    var surveyCreatedField = ""
    var numOfQuestions = ""
    var timesCompletedField = ""
    var questionLabel = [String]()
    var surveybelongto = [String]()
    var questionNumber = [String]()
    var questionType = [String]()
    var numberOfAnswers = [NSNumber]()
    var surveyCreated = "No Creation Date"
    var numQues = "No Questions"
    var timesCompleted = ""
    var answerLabel = [String]()
    var questionTypeField = [String]()
    
    var scaleMin = [NSNumber]()
    var scaleMax = [NSNumber]()


    var currentQuestionCounter = 0
    var currentQuestion = ""
    var currentAnswer = 0
    
    
    var selectedAnswers = [String]()
    @IBAction func nextButton(_ sender: UIButton) {

        //print(questionLabel[currentQuestionCounter])
        var tempCounter = questionLabel.count
        tempCounter = tempCounter + 1
        
        if currentQuestionCounter < tempCounter {
            questions()
            self.answerTable.reloadData()
            currentAnswer = 0
            currentQuestionCounter += 1
        }
        if currentQuestionCounter >= tempCounter {
            currentQuestionCounter = 0
            performSegue(withIdentifier: "endOfSurvey", sender: self)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answerTable.tableFooterView = UIView()
        
        print("\n\n\nSurvet Title \(surveyTitle)")
        // print(surveyTitle)
        titleLabel.text = surveyTitle
        questionField.text =  "Survey Details:"
        self.getAllQuestions()
       
        
        // Reformat string
        let newDate = remformatDate(date: surveyCreated)
        
        // Display information regarding each survey.
        questionField.text =  "Survey Details:"
        answerLabel.append("Number of Questions: \(numQues)")
        answerLabel.append("Survey Created: \(newDate)")
        answerLabel.append("Times Completed: \(timesCompleted)")
        
        
        answerTable.dataSource = self
        answerTable.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
    // Reformat date string to only display the first 10 characters.
    func remformatDate(date: String) -> String {

        let index = date.index(date.startIndex, offsetBy: 10)
        return(date.substring(to: index))

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let qType = self.questionType[indexPath.row]
        let answerPicked = self.answerLabel[indexPath.row]
        print("Current question is: \(currentQuestion)")
        print("Question Type is: \(qType)")
        print("Answer picked is: \(answerPicked)")
    }
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answerLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //print("question type \(questionType)")
        let lastElement = questionType.last
        print("Last element in array: \(lastElement)")
        
        if lastElement == "multiple" {
            cell.textLabel?.text = answerLabel[currentAnswer]
        } else if lastElement == "images" {

            let pictureURL = URL(string: answerLabel[currentAnswer])!
            
            let session = URLSession(configuration: .default)

            let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {

                    if let res = response as? HTTPURLResponse {
                        print("Downloaded picture:  \(res.statusCode)")
                        if let imageData = data {
                            // Finally convert that Data into an image and do what you wish with it.
                            let image = UIImage(data: imageData)
                            cell.imageView?.image = image
                            cell.setNeedsLayout()
                        } else {
                            print("Image not found")
                        }
                    } else {
                        print("Couldn't get response code for some reason")
                    }
                }
            }
            
            downloadPicTask.resume()
        } else if lastElement == "scale" {
            cell.textLabel?.text = answerLabel[currentAnswer]
        }
        else {
            // Set cell colour, cell text colour and line seperator colour
            cell.textLabel?.text = answerLabel[currentAnswer]
        }
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        
        currentAnswer = currentAnswer + 1
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func questions() {
        
        //print(questionLabel[currentQuestionCounter])
        var tempCounter = 1
        
        if currentQuestionCounter < questionLabel.count {
            
            tempCounter = currentQuestionCounter + 1
            currentQuestion = questionLabel[currentQuestionCounter]

            //print("Question \(currentQuestionCounter):  \(questionLabel[currentQuestionCounter])")
            questionField.text = "Question \(tempCounter): \(questionLabel[currentQuestionCounter])"
            answerLabel = []
            self.getAllAnswers()
            
        }
    }

    
    func getAllAnswers() {
        
        let url:String = "http://survall.top:8000/answerData/"
        
        HTTPRequest.getAllInBackground(url: url) { (completed, data) in
            
            DispatchQueue.main.async {
                if completed {
                    
                    for record in data! {
                        
                        if let survey = record as? [String:Any] {
                            
                            if let surveyRow = survey["fields"] as? [String:Any] {
                                
                                if(surveyRow["surveyTitle"] as! String == self.surveyTitle && surveyRow["questionLabel"] as! String == self.currentQuestion)  {
                                    do {
                                    self.answerLabel.append(surveyRow["answerLabel"] as! String)
                                    self.questionType.append(surveyRow["questionType"] as! String)
                                    self.scaleMin.append(surveyRow["scaleMinimum"] as! NSNumber)
                                    self.scaleMax.append(surveyRow["scaleMaximum"] as! NSNumber)
                                    //self.numberOfAnswers.append(surveyRow["numberOfAnswers"] as! NSNumber)
                                        
                                    if(surveyRow["questionType"] as! String == "scale") {
                                        var min = (Int(surveyRow["scaleMinimum"] as! NSNumber))
                                        var max = (Int(surveyRow["scaleMaximum"] as! NSNumber))
                                        self.answerLabel = []
                                        
                                        while min <= max {
                                            self.answerLabel.append(String(min))
                                            min = min + 1
                                        }
                                    }

                                    self.answerTable.reloadData()
                                    } catch {
                                        print("Error deserializing JSON: \(error)")
                                    }
                                }
                            }
                        }
                    }
                    
                }
                print(self.answerLabel)
                print(self.scaleMax)
            
            }
        }
    }
    
   
    
    func getAllQuestions() {
        
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
                                    self.numberOfAnswers.append(surveyRow["numberOfAnswers"] as! NSNumber)
                                }

                            }
                        }
                    }
                    
                }
            }
        }
    }

}
