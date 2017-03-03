//
//  settingsController.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 02/03/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import UIKit

class settingsController: UIViewController {
    
    var textSize = 0

    // Text label in the settings.
    @IBOutlet weak var screenMagnifierLabel: UILabel!
    @IBOutlet weak var screenMagLabel: UILabel!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        print("Save Button Pressed")
        performSegue(withIdentifier: "settingsToMain", sender: self)
    }
    

    
    
    @IBAction func sccreenMagnifierSwitch(_ sender: UISwitch) {
        var currentValue = sender.isOn
        print("\(currentValue)")
    }
    
    
    // Function to set size of font throughout the app.
    @IBAction func fontSlider(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        textSize = currentValue
        screenMagnifierLabel.font = screenMagnifierLabel.font.withSize(CGFloat(currentValue))
        screenMagLabel.font = screenMagnifierLabel.font.withSize(CGFloat(currentValue))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SurveyTableViewController
        vc.textSize = textSize
        
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        
        screenMagnifierLabel.text = "Change Font Size"
        slider.value = Float(textSize)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
