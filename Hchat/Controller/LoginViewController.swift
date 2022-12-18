//
//  LoginViewController.swift
//  Hchat
//
//  Created by Hüdahan Altun on 31.10.2022.
//

import UIKit

import Firebase
import FirebaseAuth
class LoginViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var PassTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        EmailTextField.autocorrectionType = .no
        EmailTextField.autocapitalizationType = .none
        PassTextField.autocorrectionType = .no
        PassTextField.autocapitalizationType = .none
        PassTextField.isSecureTextEntry = true
        
        loginButton.layer.cornerRadius = loginButton.frame.height/6
    }
    

    @IBAction func loginPressed(_ sender: Any) {
        
        if let email = EmailTextField.text , let pass = PassTextField.text{
            
            Auth.auth().signIn(withEmail: email, password: pass) {
                
              [weak self] authResult, error in
                
            
                if let e = error{
                    
                    print(e.localizedDescription)
                }else{
                    
                    self?.performSegue(withIdentifier: K.Log2Chat, sender: self)
                }
                
                
            }
        }
    }
    
}
