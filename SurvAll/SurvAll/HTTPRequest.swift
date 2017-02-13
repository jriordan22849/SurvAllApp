//
//  HTTPRequest.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 13/02/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import Foundation

class HTTPRequest {
    
    public class func getAllInBackground(url: String, getCompleted : @escaping (_ succeeded: Bool, _ data: NSArray? ) -> ()) {
        
        
        guard let endpoint = URL(string: url) else {
            print("Error creating endpoint")
            return
        }
        var request = URLRequest(url: endpoint)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if ((error) != nil) {
                getCompleted(false, [])
            }
            
            guard let data = data else {
                return
            }
            
            do {
                
                let dataObjects = try JSONSerialization.jsonObject(with: data as Data, options: .allowFragments) as! [String:Any]
                
                let allObjects = dataObjects["data"] as? NSArray
                
                getCompleted(true, allObjects)
                
            } catch let error as NSError {
                print(error)
            }
            
            }.resume()
    }
    
}
