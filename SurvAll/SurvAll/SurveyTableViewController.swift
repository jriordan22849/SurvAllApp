//
//  SurveyTableViewController.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 13/02/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import UIKit

class SurveyTableViewController: UITableViewController,UISearchBarDelegate {

    @IBOutlet weak var searchSurvey: UISearchBar!
    
    var allData = [String]()
    var detailData = [String]()
    var surveyCreated = [String]()
    var completed = [String]()
    
    var titleSurvey = ""
    var numQues = ""
    var surveyCreation = ""
    var timesCompleted = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        searchSurvey.delegate = self

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.getAllSurveys()

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print(self.searchSurvey.text ?? "No search")
        
        // Filter results to what the user typed in.
        
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
                                    
                                    self.allData.append(surveyRow["title"] as! String)
                                    self.detailData.append(surveyRow["numOfQuestions"] as! String)
                                    self.surveyCreated.append(surveyRow["dateSurvCreated"] as! String)
                                    self.completed.append(surveyRow["numOfTimesCompleted"] as! String)
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print(self.searchSurvey.text ?? "No search")
    }



    
    
    func getAllSurveys() {
        
        let url:String = "http://www.survall.top:8000/surveyData"
        
        HTTPRequest.getAllInBackground(url: url) { (completed, data) in
            
            DispatchQueue.main.async {
                if completed {
                    
                    for record in data! {
                        
                        if let survey = record as? [String:Any] {
                            
                            if let surveyRow = survey["fields"] as? [String:Any] {
                                
                                self.allData.append(surveyRow["title"] as! String)
                                self.detailData.append(surveyRow["numOfQuestions"] as! String)
                                self.surveyCreated.append(surveyRow["dateSurvCreated"] as! String)
                                self.completed.append(surveyRow["numOfTimesCompleted"] as! String)
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
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        titleSurvey = self.allData[indexPath.row]
        numQues = self.detailData[indexPath.row]
        surveyCreation = self.surveyCreated[indexPath.row]
        timesCompleted = self.completed[indexPath.row]
        performSegue(withIdentifier: "moveToQuestions", sender: self)
//        performSegue(withIdentifier: "moveToQuestions", sender: numQues)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SelectTitleViewController
        vc.surveyTitle = titleSurvey
        vc.numQues = numQues
        vc.surveyCreated = surveyCreation
        vc.timesCompleted = timesCompleted
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
