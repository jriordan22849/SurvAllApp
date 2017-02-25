//
//  SelectTitleViewController.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 13/02/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import UIKit

class SelectTitleViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {


    @IBOutlet weak var enteredDate: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerTable: UITableView!
    @IBOutlet weak var textF: UITextField?
    
    let textField = UITextField(frame: CGRect(x: 20, y: 20, width: 500.00, height: 100))

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
    
    var answerArray = [String]()
    
    var selectedAnswers = [String]()
    


    

    @IBAction func previousQuestionButton(_ sender: UIButton) {
        
        textField.isHidden = true
        
        if currentQuestionCounter > 1 {
            currentAnswer = 0
            currentQuestionCounter -= 2
            questions()
            self.answerTable.reloadData()

           
        } else {
            print("index out of bounds")
        }
        
    }
    @IBAction func nextButton(_ sender: UIButton) {

        //print(questionLabel[currentQuestionCounter])
        var tempCounter = questionLabel.count
        tempCounter = tempCounter + 1
        textField.isHidden = true
        
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
        
        textField.delegate = self
        answerTable.dataSource = self
        answerTable.delegate = self
        answerArray = []
        answerArray.append(surveyTitle)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let esvc = segue.destination as! endScreenViewController
        esvc.answerArray = answerArray

    }
    
    // Reformat date string to only display the first 10 characters.
    func remformatDate(date: String) -> String {

        let index = date.index(date.startIndex, offsetBy: 10)
        return(date.substring(to: index))

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let lastElement = questionType.last
        
        // clear the text field.
        textField.text = ""
       
        //let answerPicked = self.answerLabel[indexPath.row]
        print("Current question is: \(currentQuestion)")
        
        // Ge the question tpye so the user can be able to input answer.
        let lastString = lastElement as String!
        if NSString(string: lastString!).contains("date") {
            
            print("date type answer selected")
            addTextField()
            tableView.addSubview(textField)
            tableView.reloadData()
            
        } else if NSString(string: lastString!).contains("time") {
            
            print("time type answer selected")
            addTextField()
            tableView.addSubview(textField)
            tableView.reloadData()
            
        } else if NSString(string: lastString!).contains("text") {
            
            print("text type answer selected")
            addTextField()
            tableView.addSubview(textField)
            tableView.reloadData()
            
        } else {
            textField.isHidden = true
        }
        print("Question \(currentQuestionCounter) type is \(lastElement)")
       // print("Answer picked is: \()")
        //print("Optional(\"checkBox\")")
        
        
        answerArray.append(currentQuestion)
        //answerArray.append(answerPicked)
    }
    
    func addTextField() {
        textField.isHidden = false
        textField.textAlignment = NSTextAlignment.left
        textField.textColor = UIColor.white
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Changre background colour depending on the insert operation, short answer, time, date
        // Distingihs each task by colour.
        let lastElement = questionType.last
        let lastString = lastElement as String!
        
        if NSString(string: lastString!).contains("date") {
            //purple colour
            view.backgroundColor = UIColor(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0)
            textField.keyboardType = UIKeyboardType.numbersAndPunctuation
        } else if NSString(string: lastString!).contains("time") {
            // pink colour
            view.backgroundColor = UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1.0)
            textField.keyboardType = UIKeyboardType.numbersAndPunctuation
            
        } else if NSString(string: lastString!).contains("text") {
            // orange colour
             view.backgroundColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
             textField.keyboardType = UIKeyboardType.alphabet
        }
    }
    
    func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        //Hide the keyboard
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        print("Return Button hit")
        view.backgroundColor = UIColor.white
        return true;
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.answerLabel.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
       
        let lastElement = questionType.last
        //print("Last element in array: \(lastElement)")
        
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
                        //print("Downloaded picture:  \(res.statusCode)")
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
        } else if lastElement == "text" {
            cell.textLabel?.text = "Enter Short Answer"
        } else if lastElement == "time" {
            cell.textLabel?.text = "Enter Time Format (HH : MM)"
        } else if lastElement == "date" {
            cell.textLabel?.text = "Enter Date Format (YYYY/MM/DD)"
            
            
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
                                        let max = (Int(surveyRow["scaleMaximum"] as! NSNumber))
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
                //print(self.answerLabel)
                //print(self.scaleMax)
            
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
