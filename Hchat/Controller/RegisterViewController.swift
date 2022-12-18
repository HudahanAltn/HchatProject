//
//  RegisterViewController.swift
//  Hchat
//
//  Created by Hüdahan Altun on 31.10.2022.
//

import UIKit

import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet weak var EmailTextField: UITextField!
    
    @IBOutlet weak var regButton: UIButton!
    
    @IBOutlet weak var PassTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        EmailTextField.autocorrectionType = .no
        EmailTextField.autocapitalizationType = .none
        PassTextField.autocorrectionType = .no
        PassTextField.autocapitalizationType = .none
        PassTextField.isSecureTextEntry = true
        
        regButton.layer.cornerRadius = regButton.frame.height/5
    }
    


    @IBAction func registerPressed(_ sender: Any) {
        
        if let email = EmailTextField.text , let pass = PassTextField.text{
            
            Auth.auth().createUser(withEmail: email, password: pass) {
                
                authResult, error in // authResul kayıt sonucunu döndürür,error ise hata oluşursa döner
              
                if let e = error {
                    
                    print("user create hata:\(e)")
                    
                }else{
                    
                    self.performSegue(withIdentifier: K.Reg2Chat, sender: self)
                    
                }
            }
        }
    }
    
}
