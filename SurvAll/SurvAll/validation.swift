//
//  validation.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 02/03/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import Foundation

class validation {
    
    var inputedData = ""
    var questionType = ""
    var question = ""
    
    init(question: String, inputedData: String, questionType: String) {
        self.inputedData = inputedData
        self.questionType = questionType
        self.question = question 
        
    }
   
    // Validation of time and date
    @discardableResult
    func description() -> Bool {
        print("Question: \(question), Type: \(questionType), Input: \(inputedData)")
        
        if questionType == "time" {
           
            if inputedData.characters.count > 5 {
                return false
            }
            
            
        } else if(questionType == "date") {
            
            if inputedData.characters.count > 10 {
                return false
            }
    
        }
        return true
    }
    
}


