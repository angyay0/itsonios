//
//  HomeViewController.swift
//  itson
//
//  Created by Eduardo Pérez on 14/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit
import SwiftyJSON
import BOZPongRefreshControl

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var eventsTable: UITableView?
    
    @IBOutlet var statusLabel: UILabel?
    
    @IBOutlet var userLabel: UIButton?
    
    @IBOutlet var userImage: UIImageView?
    
    var event_list = Array<Fruit>()
    
    var event : Fruit?
    
    var pongControl: BOZPongRefreshControl?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Updaters
        updateIdentity()
        fetchEvents()
        AppConfigs.EVENT_MODE = 0
    }
    
    override func viewDidLayoutSubviews() {
        prepareTable()
        
        // Configure Rounded image.
        self.userImage?.layer.borderWidth = 2.0
        self.userImage?.layer.borderColor = UIColor.white.cgColor
        self.userImage?.layer.cornerRadius = (self.userImage?.frame.size.width)!/2
        self.userImage?.layer.masksToBounds = false
        self.userImage?.clipsToBounds = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pongControl?.scrollViewDidScroll()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.pongControl?.scrollViewDidEndDragging()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (event_list.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventViewCell
        print ("IndexPath: ",indexPath.row)
        
        print(self.event_list.count)
        
        // Configure the cell...
        if cell != nil && self.event_list.count > 0 {
            let fruit_atmp = self.event_list[indexPath.row]
            print ("event: ", fruit_atmp.fruit!)
            let fruit = fruit_atmp.fruit as! Dictionary<String, Any>
            let formatter = DateFormatter()
            formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy HH:mm")
            
            let seconds = Double(fruit["date_promise"] as! String)!/1000.00
            
            cell.gameLabel.text = fruit["game_title"] as! String
            cell.platformLabel.text = fruit["platform"] as! String
            cell.titleLabel.text = fruit["title"] as! String
            cell.dateLabel.text = formatter.string(from: Date(timeIntervalSince1970: seconds))
/*
            cell.dateLabel.text = fruit.fruit!["date_promise"].stringValue
            cell.gameLabel.text = fruit.fruit!["game_title"].stringValue
            cell.platformLabel.text = fruit.fruit!["platform"].stringValue
            cell.titleLabel.text = fruit.fruit!["title"].stringValue*/
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        AppConfigs.EVENT_MODE = 1
        self.event = event_list[indexPath.row]
        
        self.performSegue(withIdentifier: "eventSegue", sender: self)
    }
    
    @IBAction func updateStatus(){
        let alert = UIAlertController.init(title: "Actualización de estado", message: "Escribe tu estado", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Actualiza tu estado..."
            textField.isSecureTextEntry = false
        })
        alert.addAction(UIAlertAction.init(title: "Click", style: UIAlertActionStyle.default, handler: {[weak alert](action) in
            //Actualiza el estado de la persona
            let status = (alert?.textFields![0])?.text!
            
            self.updateUser(Status: status!)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func logout(sender: AnyObject) {
        LocalDataSource.getInstance().removeStoredCoconut()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateIdentity() {
        let name = LocalDataSource.getInstance().getCoconutTag()
        
        self.userLabel?.setTitle(name, for: UIControlState.normal)
        self.statusLabel?.text = LocalDataSource.getInstance().getStatus()
        
    }
    
    func fetchEvents() -> Void {
        
        DataProvider.getInstance().fetchFruits { (response, error) in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                
                self.event_list = Array<Fruit>()
                
                let created = (response?.data["created"].arrayValue)!
                
                let invited = (response?.data["invited"].arrayValue)!
                
                for f in created {
                    let fruit = Fruit()
                    fruit.convertFrom(JSON: f.dictionaryObject!)
                    
                    if !fruit.expired {
                        self.event_list.append(fruit)
                    }
                }
                
                for f in invited {
                    let fruit = Fruit()
                    fruit.convertFrom(JSON: f.dictionaryObject!)
                    
                    if !fruit.expired {
                        self.event_list.append(fruit)
                    }
                }
                
                self.eventsTable?.reloadData()
                
                self.pongControl!.finishedLoading()
                
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                self.pongControl!.finishedLoading()
                print("UPS! \(errorType)")
            })
            
        }
    }
    
    func updateUser(Status status: String){
        DataProvider.getInstance().update(Message: ["status":status]) { (response, error) in
            if error == nil {
                print("No Error: "+(response?.toString())!)
                self.statusLabel!.text = status
                LocalDataSource.getInstance().storeStatus(for: status)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS! \(errorType)")
            })
        }
    }
    
    func prepareTable() {
        self.pongControl = BOZPongRefreshControl .attach(to: eventsTable, withRefreshTarget: self, andRefreshAction: #selector(HomeViewController.refreshAction))
        
    }
    
    @objc func refreshAction() {
      //  self.pongControl?.beginLoading()
        fetchEvents()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if sender is UIButton {
            AppConfigs.EVENT_MODE = 0
        }
        
        if segue.identifier == "eventSegue" {
            
            let controller = (segue.destination as! UINavigationController).topViewController as! EventViewController
            
            if AppConfigs.EVENT_MODE != 0 {
                controller.receiveFruit(event: self.event!)
              //  AppConfigs.EVENT_MODE = 0
            }
        }
    }
    

}
