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
            
            print("\n\n\n")
            print("JSON Data is \(jsonData)")
            
            //readplistfile ?? "localhostname"
            
            // create POST request
            let url = URL(string: "http://survall.top:8000/postSurvey/")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                    print("success")
                }
            }
            
            task.resume()
            
        } catch {
            print("error")
        }
        

        
        print(answerArray)
   

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
