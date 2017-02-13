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
    var surveyTitle = "No Title"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // print(surveyTitle)
        titleLabel.text = surveyTitle
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
