//
//  ViewController.swift
//  SimpleChatFirebase
//
//  Created by Alexander Yakovenko on 3/31/18.
//  Copyright © 2018 Alexander Yakovenko. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    let ref = Database.database().reference()
    
    var arrayOfContent = [Model]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        startObservingDB()
        
        
    }
    
    
    func startObservingDB () {
        
        ref.observe(.value) { (snapshot) in  //change "value" to "cildAdded"
            
            self.arrayOfContent = []
           
            for child in snapshot.children {
                print("ok")
                
                let snap = child as! DataSnapshot
                let key = snap.key
                let value = snap.value
                
                
                
                
                print("key = \(key)  value = \(value!)")
                
                if let name = (value as! [String: String])["Sasha"], let content = (value as! [String: String])["context"] {
                    let model = Model(name: name, content: content)
                    self.arrayOfContent.append(model)
                }
                
                
                print("ok")
            }
            
            self.arrayOfContent.reverse()
            self.tableView.reloadData()
        }
        
        
        
    }
    
    @IBAction func addMessage(_ sender: Any) {
        //let model = Model(name: UserDefaults.standard.value(forKey: "uid") as! String, content: messageTextField.text!)
        let ref = Database.database().reference()
        
        // Generating the chat id
        // під цим ід створимо два child - name and context
        //  кожен тап згенерує id
        
        let refChats = ref.child("chats")
        let refChat = refChats.childByAutoId()
        
        // використати id - це вузол для повідомлення
        let chatIdKey = refChat.key
        
        // створюємо повідомлення
        let refUsers = ref.child(chatIdKey)
        let refName = refUsers.child("Sasha") // потім буде uid при авторизації
        refName.setValue("Sasha")
        let refContext = refUsers.child("context")
        refContext.setValue(messageTextField.text!)
        messageTextField.text = ""
        
    }
    
    
    
    
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfContent.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! ChatTableViewCell
        cell.nameLabel.text = arrayOfContent[indexPath.row].name
        cell.contentLabel.text = arrayOfContent[indexPath.row].content
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        return cell
    }
}

