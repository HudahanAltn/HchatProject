//
//  ViewController.swift
//  Hchat
//
//  Created by Hüdahan Altun on 31.10.2022.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var regButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    var textLabel = "⚡️Hchat"
    override func viewDidLoad() {
        super.viewDidLoad()
        
        regButton.layer.cornerRadius = regButton.frame.height/6
        loginButton.layer.cornerRadius = loginButton.frame.height/6
        
//        titleLabel.text = ""
//
//        var charIndex = 0.0
//        for letter in textLabel{
//
//            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false){
//
//                timer in
//
//                self.titleLabel.text?.append(letter)
//
//            }
//            charIndex += 1
//        }
//
//        UIView.animate(withDuration: 2, delay: 1, options: [.repeat,.autoreverse] , animations: {
//
//            self.titleLabel.alpha = 0.1
//
//        })
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        titleLabel.alpha = 1
        titleLabel.text = ""
        
        var charIndex = 0.0
        for letter in textLabel{
            
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false){
                
                timer in
                
                self.titleLabel.text?.append(letter)
                
            }
            charIndex += 1
        }
        
        UIView.animate(withDuration: 2, delay: 1, options: [.repeat,.autoreverse] , animations: {
             
            self.titleLabel.alpha = 0.1
            
        })

    }

}

