//
//  SelectTitleViewController.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 13/02/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import UIKit
import AVFoundation

class SelectTitleViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate {

    
    let size = UserDefaults.standard.double(forKey: "textsize")
    let sPace = UserDefaults.standard.double(forKey: "speechpace")
    
    @IBOutlet weak var enteredDate: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var answerTable: UITableView!
    @IBOutlet weak var textF: UITextField?
    
    let textField = UITextField(frame: CGRect(x: 0, y: 60, width: 400, height: 300))
    
    var cellPressed = false

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
    var enteredData = ""
    var currentQuestionCounter = 0
    var currentQuestion = ""
    var currentAnswer = 0
    var answerArray = [String]()
    var selectedAnswers = [String]()
    var buttonFlag = 0
    var surveyLocked = ""
    var passcode = ""
    var access = true
    let mySynthesizer = AVSpeechSynthesizer()
    
    var val: validation?
    
    let sr = UserDefaults.standard.bool(forKey: "screenReaderAcvive")
 
    @IBOutlet weak var progressionBar: UIProgressView!
    
    @IBAction func previousQuestionButton(_ sender: UIButton) {
        
        textField.isHidden = true
        
        var prgressIncrement = Float(100/questionLabel.count)
        prgressIncrement = Float(prgressIncrement/100)
        
        if currentQuestionCounter > 1 {
            currentAnswer = 0
            currentQuestionCounter -= 2
            questions()
            self.answerTable.reloadData()
            progressionBar.progress -= prgressIncrement
            
            if sr {
                textToSpeech(text: "Previous Button Pressed")
            }

           
        } else {
            print("index out of bounds")
        }
        
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        var moveToNextQuestion = true
        enteredData = textField.text!
        textField.text = ""
        print("Typed answer \(enteredData)")
        
        // Validate the input of data entered.
        let lastElement = questionType.last
        var lastString = lastElement as String!
        
        if lastString == nil {
            lastString = ""
        }
        
        val = validation(question: currentQuestion,inputedData: enteredData,questionType: (lastString )!)
        
        if val!.description() == false {
            moveToNextQuestion = false
            enteredData = ""
        }
        
        if enteredData != "" {
            
            // Save answer to the db
            answerArray.append(currentQuestion)
            answerArray.append(enteredData)
            enteredData = ""
        }
        
        if access == false {
            print("Raise notification to enter passcode")
            
            if sr {
                textToSpeech(text: "Enter Passcode")
            }
            
            alert()
        }
        

        //print(questionLabel[currentQuestionCounter])
        
        if moveToNextQuestion == true {
            
            if sr {
                textToSpeech(text: "Next Button Pressed")
            }
            
            var tempCounter = questionLabel.count
            tempCounter = tempCounter + 1
            textField.isHidden = true
            
            var prgressIncrement = Float(100/tempCounter)
            prgressIncrement = Float(prgressIncrement/100)
            
            if currentQuestionCounter < tempCounter {
                questions()
                self.answerTable.reloadData()
                currentAnswer = 0
                currentQuestionCounter += 1
                
                // increment the progression bar
                progressionBar.progress += prgressIncrement
            }
            if currentQuestionCounter >= tempCounter {
                
                if sr {
                    textToSpeech(text: "End of Survey")
                }
                
                currentQuestionCounter = 0
                performSegue(withIdentifier: "endOfSurvey", sender: self)
            }
            
        }

    }
    
    // alert dislayed to the user where surveys require passcode.
    func alert() {
        let alertController = UIAlertController(title: "Enter Passcode?", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            if let field = alertController.textFields?[0] {
                // store your data
                UserDefaults.standard.set(field.text, forKey: "passcode")
                print("User entered in: \(field.text)")
                print("Passcode for survey is \(self.passcode)")
                
                if field.text != self.passcode {
                    //performSegue(withIdentifier: "moveToQuestions", sender: ")
                    print("Passcode does not match")
                    // go to previous view
                    _ = self.navigationController?.popViewController(animated: true)
                } else {
                    print("Passcode match")
                    self.access = true
                }
                UserDefaults.standard.synchronize()
            } else {
                // user did not fill field
                _ = self.navigationController?.popViewController(animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // go to previous view
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Passcode"
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func textToSpeech(text : String) {
        let speech = AVSpeechUtterance(string: text)
        speech.rate = AVSpeechUtteranceMinimumSpeechRate
        speech.voice = AVSpeechSynthesisVoice(language: "en-us")
        speech.pitchMultiplier = Float(sPace)
        mySynthesizer.speak(speech)
    }

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.answerTable.tableFooterView = UIView()
        
        print("\n\n\nSurvet Title \(surveyTitle)")
        
        progressionBar.progress = 0

        
       // titleLabel.text = surveyTitle
        questionField.text =  "Survey Details:"
        questionField.font = questionField.font.withSize(CGFloat(size))
        
        self.getAllQuestions()
       
        
        // Reformat string
        let newDate = remformatDate(date: surveyCreated)
        
        // Display information regarding each survey.
        questionField.text =  "Survey Details:"
        answerLabel.append("Number of Questions: \(numQues)")
        answerLabel.append("Survey Created: \(newDate)")
        answerLabel.append("Times Completed: \(timesCompleted)")
        answerLabel.append("Private: \(surveyLocked)")
        
        if surveyLocked == "yes" || surveyLocked == "YES"  {
            access = false
        }
        
        textField.delegate = self
        answerTable.dataSource = self
        answerTable.delegate = self
        answerArray = []
        answerArray.append(surveyTitle)
        
        // set the survey title to the navigation bar.
        self.navigationItem.title = surveyTitle
        

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
        
        //Change color of the user seected answer, the color of the row
        let lastElement = questionType.last
        
        // clear the text field.
        enteredData = textField.text! as String
        textField.text = ""
       
        let answerPicked = self.answerLabel[indexPath.row]
        print("Current question is: \(currentQuestion)")
 
        // Get the question tpye so the user can be able to input answer.
        let lastString = lastElement as String!
        if NSString(string: lastString!).contains("date") {
            
        } else if NSString(string: lastString!).contains("time") {
            
        } else if NSString(string: lastString!).contains("text") {
            
        }   else {
            textField.isHidden = true
            

            answerArray.append(currentQuestion)
            answerArray.append(answerPicked)
            
            if sr {
                textToSpeech(text: "Answer picked is: \(answerPicked)")
            }
            
            print("Answer picked is: \(answerPicked)")
        }

        // Check mark for user selected answer in the table
        let cell = tableView.cellForRow(at: indexPath)
        
        if (cell?.isSelected)! {
            cell?.accessoryType = UITableViewCellAccessoryType.checkmark
        }
    }
    

    
    func textFieldDidBeginEditing(_ textField: UITextField) {
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let returnInt = Int(self.size) * 4
        let cgfloat = CGFloat(returnInt)
        
        return cgfloat
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let lastElement = questionType.last
        var type = ""
        
        cell.textLabel?.font = cell.textLabel?.font.withSize(CGFloat(size))

        cell.textLabel?.numberOfLines = 5
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //Display text in center of cell for the following question types.
        if (lastElement == "checkBox" || lastElement == "multiple" || lastElement == "scale" ||
            lastElement == "text" || lastElement == "time" || lastElement == "date" || lastElement == "images") {
            cell.textLabel?.textAlignment = .center
        }
    
        
        
        print("Last element in array: \(lastElement)")
        if lastElement == "checkBox" {
            if sr {
                textToSpeech(text: answerLabel[currentAnswer])
            }
            cell.textLabel?.text = answerLabel[currentAnswer]
        }
        else if lastElement == "multiple" {
            if sr {
                textToSpeech(text: answerLabel[currentAnswer])
            }
            cell.textLabel?.text = answerLabel[currentAnswer]

        } else if lastElement == "images" {

            let pictureURL = URL(string: answerLabel[currentAnswer])!
            
            let session = URLSession(configuration: .default)

            let downloadPicTask = session.dataTask(with: pictureURL) { (data, response, error) in
                // The download has finished.
                if let e = error {
                    print("Error downloading cat picture: \(e)")
                } else {

                    if (response as? HTTPURLResponse) != nil {
                        //print("Downloaded picture:  \(res.statusCode)")
                        if let imageData = data {
                            
                            
                            // Display the images using the main thread
                            DispatchQueue.main.async(execute: {
                            
                                let image = UIImage(data: imageData, scale: CGFloat(1))
//                                cell.textLabel?.text = "Image \(self.currentAnswer)"
                                cell.imageView?.image = image
                               // cell.imageView?.center = cell.center;
                                cell.setNeedsLayout()

                            })
                            
                            
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
            if sr {
                textToSpeech(text: answerLabel[currentAnswer])
            }
            cell.textLabel?.text = answerLabel[currentAnswer]
        } else if lastElement == "text" {
            type = "Enter Answer"
            addTextField(typePlaceholder: type)
            tableView.addSubview(textField)
            clearEnteredData()
            
        } else if lastElement == "time" {
            
            type = "Enter Time"
            tableView.addSubview(textField)
            addTextField(typePlaceholder: type)
            clearEnteredData()
        } else if lastElement == "date" {
            type = "Enter Date"
            tableView.addSubview(textField)
            addTextField(typePlaceholder: type)
            clearEnteredData()
        }
            
        else {
            // Set cell colour, cell text colour and line seperator colour
            cell.textLabel?.text = answerLabel[currentAnswer]
            cell.isUserInteractionEnabled = false
        }
        
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        
        currentAnswer = currentAnswer + 1
        
        // Changre background colour depending on the insert operation, short answer, time, date
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.red
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
    
    func addTextField(typePlaceholder: String) {
        textField.attributedPlaceholder = NSAttributedString(string: typePlaceholder, attributes: [NSForegroundColorAttributeName : UIColor.white])
        textField.backgroundColor = UIColor.clear
        textField.textColor = UIColor.white
        textField.isHidden = false
        textField.textAlignment = NSTextAlignment.left
        textField.font = .systemFont(ofSize: 30)
        textField.adjustsFontSizeToFitWidth = true
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clearEnteredData() {
        enteredData = ""
    }
    
    func questions() {
        
        //print(questionLabel[currentQuestionCounter])
        var tempCounter = 1
        
        if currentQuestionCounter < questionLabel.count {
            
            tempCounter = currentQuestionCounter + 1
            currentQuestion = questionLabel[currentQuestionCounter]

            //print("Question \(currentQuestionCounter):  \(questionLabel[currentQuestionCounter])")
            
            if sr {
                textToSpeech(text: questionLabel[currentQuestionCounter])
            }
            
            questionField.text = "\(questionLabel[currentQuestionCounter])"
            self.navigationItem.title = surveyTitle + "-" + "Question \(tempCounter)"

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
