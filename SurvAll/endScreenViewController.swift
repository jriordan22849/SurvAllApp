//
//  endScreenViewController.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 16/02/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import UIKit

class endScreenViewController: UIViewController {
    
    var answerArray = [String]()
    // if the return button is pressed, return to menu.
    @IBAction func returnButton(_ sender: Any) {
         performSegue(withIdentifier: "returnToTable", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            
            //Convert to Data
            let jsonData = try JSONSerialization.data(withJSONObject: answerArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            
            //Convert back to string. Usually only do this for debugging
            if let JSONString = String(data: jsonData, encoding: String.Encoding.utf8) {
                print(JSONString)
            }
            
            print("\n\n\n")
            print("JSON Data is \(jsonData)")
        } catch {
            print("error")
        }
        
        print(answerArray)
        
        //declare parameter as a dictionary which contains string as key and value combination. considering inputs are valid
        
        let parameters = ["name": "name", "password": "passowrd"] as Dictionary<String, String>
        
        //create the url with URL
        let url = URL(string: "http://www.survall.top:8000/post")! //change the url
        
        //create the session object
        let session = URLSession.shared
        
        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        request.httpMethod = "POST" //set http method as POST
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body

            
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
                
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
