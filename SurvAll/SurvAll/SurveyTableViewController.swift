//
//  SurveyTableViewController.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 13/02/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import UIKit
import AVFoundation

class SurveyTableViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var searchSurvey: UISearchBar!
    
    var allData = [String]()
    var detailData = [NSNumber]()
    var surveyCreated = [String]()
    var completed = [NSNumber]()
    var locked = [String]()
    var pCode = [String]()
    var titleSurvey = ""
    var numQues = ""
    var surveyCreation = ""
    var timesCompleted = ""
    var surveyLocked = ""
    var passcode = ""
    var textSize = 21
    var sugueMove = true
    let mySynthesizer = AVSpeechSynthesizer()
    
    let size = UserDefaults.standard.double(forKey: "textsize") ?? 21.0
    let sr = UserDefaults.standard.bool(forKey: "screenReaderAcvive")
    let sPace = UserDefaults.standard.double(forKey: "speechpace")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        searchSurvey.delegate = self
        
        print("Text Size = \(textSize)")

        let testUIBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(addTapped))
        self.navigationItem.rightBarButtonItem = testUIBarButtonItem
        
        self.getAllSurveys()

    }
    
    func textToSpeech(text : String) {
        let speech = AVSpeechUtterance(string: text)
        speech.rate = AVSpeechUtteranceMinimumSpeechRate
        speech.voice = AVSpeechSynthesisVoice(language: "en-us")
        speech.pitchMultiplier = Float(sPace)
        mySynthesizer.speak(speech)
    }
    
    func addTapped() {
        print("Settings button tapped")
        sugueMove = false
        performSegue(withIdentifier: "settingsController", sender: self)
    }
    
    func rightButtonAction(sender: UIBarButtonItem) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(self.searchSurvey.text ?? "No search")
        
        // Filter results to what the user typed in.
        
        //let url:String = "Jonathan-2.local:8000/surveyData"
        let url:String = "http://www.survall.top:8000/surveyData"
        
        HTTPRequest.getAllInBackground(url: url) { (completed, data) in
            
            DispatchQueue.main.async {
                if completed {
                    
                    for record in data! {
                        
                        if let survey = record as? [String:Any] {
                            
                            if let surveyRow = survey["fields"] as? [String:Any] {
                                if surveyRow["title"] as? String  == self.searchSurvey.text {
                                    
                                    // clear data from all the surveys
                                    self.allData = []
                                    self.detailData = []
                                    self.surveyCreated = []
                                    self.completed = []
                                    self.locked = []
                                    self.pCode = []
                                    
                                    self.allData.append(surveyRow["title"] as! String)
                                    self.detailData.append(surveyRow["numOfQuestions"] as! NSNumber)
                                    self.surveyCreated.append(surveyRow["dateSurvCreated"] as! String)
                                    self.completed.append(surveyRow["numOfTimesCompleted"] as! NSNumber)
                                    self.locked.append(surveyRow["private"] as! String)
                                    self.pCode.append(surveyRow["passcode"] as! String)
                                    //print(self.allData)
                                    self.tableView.reloadData()
                                    
                                }
                                
                            }
                        }
                    }
                    
                }
            }
        }
        
        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        print(self.searchSurvey.text ?? "No search")
        searchSurvey.resignFirstResponder()
    }
    

    
    func getAllSurveys() {
        
        //let url:String = "Jonathan-2.local:8000/surveyData/"
        let url:String = "http://www.survall.top:8000/surveyData"
        
        HTTPRequest.getAllInBackground(url: url) { (completed, data) in
            
            DispatchQueue.main.async {
                if completed {
                    
                    for record in data! {
                        
                        if let survey = record as? [String:Any] {
                            
                            if let surveyRow = survey["fields"] as? [String:Any] {
                                
                                self.allData.append(surveyRow["title"] as! String)
                                self.detailData.append(surveyRow["numOfQuestions"] as! NSNumber)
                                self.surveyCreated.append(surveyRow["dateSurvCreated"] as! String)
                                self.completed.append(surveyRow["numOfTimesCompleted"] as! NSNumber)
                                self.locked.append(surveyRow["private"] as! String)
                                self.pCode.append(surveyRow["passcode"] as! String)
                                //print(self.allData)
                                self.tableView.reloadData()
                            }
                        }
                    }
                    
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.allData.count
    }
    
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        cell.textLabel?.text = self.allData[indexPath.row]
        cell.detailTextLabel?.text = "Number of Questions: \(self.detailData[indexPath.row])"
        
        // Change the font size if user changed it im the settings. 
        cell.textLabel?.font = cell.textLabel?.font.withSize(CGFloat(size))
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("SR: \(sr)")
        if sr {
            textToSpeech(text: self.allData[indexPath.row])
        }
        

        
        titleSurvey = self.allData[indexPath.row]
        numQues = String(describing: self.detailData[indexPath.row])
        surveyCreation = self.surveyCreated[indexPath.row]
        timesCompleted = String(describing: self.completed[indexPath.row])
        surveyLocked = self.locked[indexPath.row]
        passcode = self.pCode[indexPath.row]
        sugueMove = true
        performSegue(withIdentifier: "moveToQuestions", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if sugueMove{
            
            let vc = segue.destination as! SelectTitleViewController
            vc.surveyTitle = titleSurvey
            vc.numQues = numQues
            vc.surveyCreated = surveyCreation
            vc.timesCompleted = timesCompleted
            vc.surveyLocked = surveyLocked
            vc.passcode = passcode
            
        }

        
        if !sugueMove {
            let settings = segue.destination as! settingsController
            settings.textSize = textSize
        }
    }

    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
