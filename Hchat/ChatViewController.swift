//
//  ChatViewController.swift
//  Hchat
//
//  Created by Hüdahan Altun on 31.10.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextField: UITextField!
    
    let db = Firestore.firestore() //veri tabanı erişim nesnesi
    
    var messages:[Message] = [Message] () //mesajları tutacak olan boş nesne dizisi
    
    override func viewDidLoad() {
        super.viewDidLoad()

        messageTextField.autocorrectionType = .no
        messageTextField.autocapitalizationType = .none
        
        self.navigationItem.hidesBackButton = true
        
        navigationItem.title = "⚡️Hchat"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(rgb: 0xFAEAFE)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor(named: "BrandLightPurple")
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier) // özel cell yapılandırılması yüklenir
        
         RealtimeLoadMessages()//uyg başlamadan mesajlar yüklenir
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationItem.hidesBackButton = true
    }
  
    @IBAction func sendPressed(_ sender: Any) {
        
        //if le tile mesaj içieriği ve uyg'a giriş yapan kullanıcı bilgisini aldıkaldık
        
        if let messageBody = messageTextField.text {
            
            DispatchQueue.main.async { //textfield içini boşalt
                self.messageTextField.text = ""
            }
            if messageBody != ""{
                
                if let messageSender = Auth.auth().currentUser?.email{
                    
                    db.collection(K.FStore.collectionName).addDocument(data: [K.FStore.senderField:messageSender,
                         K.FStore.bodyField:messageBody,
                         K.FStore.dateField:Date().timeIntervalSince1970]){
                        
                        error in
                        
                        if let e = error{
                            
                            print("firebaseStore'a veri kaydedilemedi.hata kodu:\(e)")
                        }else{
                            
                            print("veri kaydı başarılı!")
                            
                        }
                    }
                    
                }
                
            }else{
                
                let alertController = UIAlertController(title: "Hata", message: "Boş Mesaj Gönderilemez", preferredStyle: .alert)
                
                let tamam = UIAlertAction(title: "Tamam", style: .cancel)
                
                alertController.addAction(tamam)
                
                self.present(alertController, animated: true)
            }

           
            
        }
       
    }
    
    @IBAction func logOutPressed(_ sender: Any) {

        do {
            
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            
           print("Error signing out: %@", signOutError)
            
        }
      
        print("çıkış yapıldı!")
    }
}

//MARK: - Tableview Protocols
extension ChatViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier,for:indexPath) as! MessageCell
        
        cell.Label.text = messages[indexPath.row].body
        
        cell.backgroundColor = UIColor(rgb: 0xFAEAFE)
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
}

//MARK: - ChatVC extra func
extension ChatViewController{
    
    
    
    func loadMessages(){//uyg ya girince  önceki mesajlarımızı ekrana yüklemeyi sağlayan fonks. Veri tabanınndan sadece bir defa veri çekmek istersek bu kullanılır
        
        messages = []
        
        db.collection(K.FStore.collectionName).getDocuments() {
            
            (querySnapshot, err) in //anlık görüntü ve hata
            
            if let e = err {
                
                print("Veritabanından veri getirme başarısız.Hata kodu : \(e)")
                
            } else {
                
                if let snapShotDocument = querySnapshot?.documents{ //verilerimizi nesne dizisi şeklinde aldık
                    
                    for doc in snapShotDocument{ //her bir nesneyi for döngüsü ile çıkardık
                        
                        let data  = doc.data() // burada data artık bi dictionary'dir
                        if let messageSender = data[K.FStore.senderField] as? String,let messageBody = data[K.FStore.bodyField] as? String{
                            
                            
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                            }
                        }
                    }
                
                }
            }
        }
        
        
    }
    
    func RealtimeLoadMessages(){//uyg ya girince  önceki mesajlarımızı ekrana yüklemeyi sağlayan fonks. aktif bir şekilde her günc sonrası veri çekimi için
        
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener() {
            
            (querySnapshot, err) in //anlık görüntü ve hata
            
            self.messages.removeAll() //diziyi temizledik
            
            if let e = err {
                
                print("Veritabanından veri getirme başarısız.Hata kodu : \(e)")
                
            } else {
                
                if let snapShotDocument = querySnapshot?.documents{ //verilerimizi nesne dizisi şeklinde aldık
                    
                    for doc in snapShotDocument{ //her bir nesneyi for döngüsü ile çıkardık
                        
                        let data  = doc.data() // burada data artık bi dictionary'dir
                        if let messageSender = data[K.FStore.senderField] as? String,let messageBody = data[K.FStore.bodyField] as? String{
                            
                            
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                
                                self.tableView.reloadData()
                            }
                        }
                    }
                
                }
            }
        }
        
        
    }
    
}

//MARK: - UICOLOR rgb extension


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}




