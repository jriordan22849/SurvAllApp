//
//  settingsController.swift
//  SurvAll
//
//  Created by Jonathan Riordan on 02/03/2017.
//  Copyright © 2017 Jonathan Riordan. All rights reserved.
//

import UIKit
import AVFoundation

class settingsController: UIViewController,AVSpeechSynthesizerDelegate {
    
    var textSize = 0
    var sr = false
    let mySynthesizer = AVSpeechSynthesizer()
    var pace = 1.0

    // Text label in the settings.
    @IBOutlet weak var screenMagnifierLabel: UILabel!
    @IBOutlet weak var screenMagLabel: UILabel!
    @IBOutlet weak var screenReaderLabel: UILabel!
    @IBOutlet weak var screenReaderButton: UISwitch!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var srButton: UISwitch!
    @IBOutlet weak var paceSlider: UISlider!
    
    @IBAction func speechPace(_ sender: UISlider) {
        
        let currentValue = Int(sender.value)
        var speechPace = UserDefaults.standard.double(forKey: "speechpace")
        speechPace = Double(currentValue)
        pace = Double(speechPace)
        print("Pace = \(pace)")
 
        
    }
    @IBAction func inAppScreenRead(_ sender: UISwitch) {
        UserDefaults.standard.set(sr, forKey: "screenReaderAcvive")
        let currentValue = sender.isOn
        var screenBool = UserDefaults.standard.bool(forKey: "screenReaderAcvive")
        screenBool = currentValue
        sr = screenBool
        
        
        if screenBool {
            textToSpeech(text: "Screen Reader Acvtivated")
        }
        
        if screenBool == false{
            textToSpeech(text: "Screen Reader turned off")
        }
        
        print("Screen Reader in inAppScreenRead: \(screenBool)")
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        UserDefaults.standard.set(textSize, forKey: "textsize")
        UserDefaults.standard.set(sr, forKey: "screenReaderAcvive")
        UserDefaults.standard.set(pace, forKey: "speechpace")
        _ = UserDefaults.standard.double(forKey: "textsize") 
    
        
        print("Save Button Pressed")
        performSegue(withIdentifier: "settingsToMain", sender: self)
    }
    
    
    @IBAction func screenReaderSwitch(_ sender: UISwitch) {
        let currentValue = sender.isOn
        var reader = UserDefaults.standard.bool(forKey: "sReader")
        reader = currentValue
        
        if reader {
            let response = alert()
            
            if response == false {
                screenReaderButton.isOn = false
            }
        }
        print("Screen Reader: \(reader)")
    }
    

    
    
    @IBAction func sccreenMagnifierSwitch(_ sender: UISwitch) {
        //let currentValue = sender.isOn
        //var screenBool = UserDefaults.standard.bool(forKey: "screenMagnifier")
        //screenBool = currentValue
        //textToSpeech(text: "Screen Reader Acvtivated")
        
        //print("Screen Magnifier: \(screenBool)")
    }
    
    func textToSpeech(text : String) {
        let speech = AVSpeechUtterance(string: text)
        speech.rate = AVSpeechUtteranceMinimumSpeechRate
        speech.voice = AVSpeechSynthesisVoice(language: "en-us")
        speech.pitchMultiplier = Float(pace)
        mySynthesizer.speak(speech)
    }
    
    
    // Function to set size of font throughout the app.
    @IBAction func fontSlider(_ sender: UISlider) {
        let currentValue = Int(sender.value)
        textSize = currentValue
        screenMagnifierLabel.font = screenMagnifierLabel.font.withSize(CGFloat(currentValue))
        screenMagLabel.font = screenMagnifierLabel.font.withSize(CGFloat(currentValue))
        screenReaderLabel.font = screenMagnifierLabel.font.withSize(CGFloat(currentValue))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! SurveyTableViewController
        vc.textSize = textSize
        
    }
    


    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Settings"
        
        let screenBool = UserDefaults.standard.bool(forKey: "screenReaderAcvive")
        let sPace = UserDefaults.standard.double(forKey: "speechpace")
        
        screenMagnifierLabel.text = "Change Font Size"
        screenReaderLabel.text = "Screen Reader"
       
        slider.value = Float(textSize)
        screenReaderButton.isOn = sr
        
        srButton.isOn = screenBool
        paceSlider.value = Float(sPace)
    
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func alert() -> Bool {
        let alertController = UIAlertController(title: "Redirect to settings", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { (_) in
            self.screenReaderButton.setOn(true, animated: true)
            UIApplication.shared.openURL(URL(string:"App-Prefs:root=General/Accessibility")!)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            return false
        }
        
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
        return false
    }
    
    
}
