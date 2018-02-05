//
//  EventViewController.swift
//  itson
//
//  Created by Eduardo Pérez on 18/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit
import SwiftyPickerPopover
import GoogleMobileAds
import JQProgressHUD

class EventViewController: UITableViewController {
    
    @IBOutlet var gameInput: UITextField?
    
    @IBOutlet var platformInput: UITextField?
    
    @IBOutlet var dateInput: UITextField?
    
    @IBOutlet var statusInput: UITextField?
    
    @IBOutlet var reminderInput: UITextField?
    
    @IBOutlet var nutsTableView: NutTableView?
    
    @IBOutlet var addNutButton: UIButton?
    
    @IBOutlet var openComments: UIButton?
    
    @IBOutlet weak var nativeAdView: GADNativeExpressAdView!
    
    var statusId: Int = 0
    
    var reminderId: Int = 0
    
    var date_string = ""
    
    var fruit_id = ""
    
    var fruit: Fruit?
    
    var nuts: Array<Nut>?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        runOverEventType()
        
        //ADS Loading UNCOMMENT BEFORE GO TO PRODUCTION
     //   nativeAdView.adUnitID = "ca-app-pub-3129748972358848/1096060610"
      //  nativeAdView.rootViewController = self
       // nativeAdView.load( GADRequest() )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 8
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    @IBAction func dismissView(sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createOrUpdateEvent(sender: AnyObject){
        self.askForName()
    }
    
    func createNewEventWith(Title:String){
        let payload = [
            "title": Title,
            "game": gameInput?.text!,
            "platform": platformInput?.text!,
            "date_promise": self.date_string,
            "demolition":[reminderId],
            "hanging":[]
            ] as [String : Any]
        
        JQProgressHUDTool.jq_showNormalHUD()
        
        DataProvider.getInstance().createNew(Fruit: payload, completion: { (response,error) -> Void in
            
            JQProgressHUDTool.jq_hideHUD()
            
            if error == nil {
                LocalDataSource.getInstance().store(fruit: Title, game: (self.gameInput?.text)!, on: (self.platformInput?.text)!, date: self.date_string, and: self.reminderId)
                self.showAlert(0)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        })
        
    }
    
    func updateEventWith(Title:String){
        let payload = [
            "fruit": self.fruit_id,
            "title": Title,
            "game": gameInput?.text!,
            "platform": platformInput?.text!,
            "date_promise": self.date_string,
            "status": statusId,
            "demolition": reminderId
            ] as [String : Any]
        
        JQProgressHUDTool.jq_showNormalHUD()
        
        DataProvider.getInstance().update(Fruit: payload, completion: { (response, error) -> Void in
            
            JQProgressHUDTool.jq_hideHUD()
            
            if error == nil {
                LocalDataSource.getInstance().store(fruit: Title, game: (self.gameInput?.text)!, on: (self.platformInput?.text)!, date: self.date_string, and: self.reminderId)
                self.showAlert(0)
                return
            }
            
            error!.show(self, completion: { (errorType) in
                print("Ups! \(errorType)")
            })
        })
        
    }
    
    func addParticipant(nut: String) {
        
        JQProgressHUDTool.jq_showNormalHUD()
        
        DataProvider.getInstance().hangTo(Fruit: fruit_id, A: nut, completion: { (response, error) -> Void in
            
            JQProgressHUDTool.jq_hideHUD()
            
            if error == nil { //Update and refreshUI
                if self.nuts == nil {
                    self.nuts = Array<Nut>()
                }
                
                self.nuts?.append( Nut(with: nut) )
                self.nutsTableView?.receive(self.nuts!)
                self.nutsTableView?.reloadData()
                return
            }
            
            error!.show(self, completion: { (errorType) in
                print("Ups!")
            })
            
        })
    }
    
    @IBAction func addParticipants(sender: AnyObject){
        print("TODO - Add Participants & Update Nut Table")
        let alert = UIAlertController.init(title: "Agrega a tus amigos", message: "Ej: myfriendTag", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "myfriendtag"
            textField.isSecureTextEntry = false
        })
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {[weak alert](action) in
            print("Cancel add participantes")
        }))
        alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: {[weak alert](action) in
            //Actualiza el estado de la persona
            let name = (alert?.textFields![0])?.text!
            
            if FieldsValidator.getInstance().isValidUsername(username: name!) {
                if LocalDataSource.getInstance().getCoconutTag() == name {
                    let alert = UIAlertController.init(title: "Error", message: "Tu eres el creador del evento, ya estas agregado", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: {[weak alert](action) in
                        alert?.dismiss(animated: true, completion: nil)
                    }))
                    return
                }
                
                self.addParticipant(nut: name!)
            }
            
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func openDatePicker(sender: AnyObject){
        //Implement DatePicker
        DatePickerPopover(title: "Selecciona una Fecha")
            .setDoneButton(action: { popover, selectedDate in
                self.setupLabelFor(date: selectedDate)
                print("selectedDate \(selectedDate)")
            })
            .setCancelButton(action: {_, v in print("cancel")})
            .appear(originView: sender as! UITextField, baseViewController: self)
        
    }
    
    @IBAction func openStatusPicker(sender: AnyObject){
        //Implement StringPicker

        StringPickerPopover(title: "Selecciona un Status", choices: ["Nuevo","Creado","En espera","Jugando","Finalizado","Cancelado"])
        .setSelectedRow(0)
        .setDoneButton(action: {(popover,selectedRow, selectedString) in
            self.statusId = selectedRow + 1
            self.setupLabelFor(status: selectedRow)
           // print("Done \(selectedRow): \(selectedString)")
        })
        .setCancelButton(action: {_, i, v in
            print("Cancelled")
        })
        .appear(originView: sender as! UIView, baseViewController: self)
    }
    
    @IBAction func openReminderPicker(sender: AnyObject){
        //Implement StringPicker
        StringPickerPopover(title: "Selecciona un recordatorio",
            choices: ["None","5 Min","15 Min","30 Min","1 Hr","2 Hrs"])
            .setSelectedRow(0)
            .setDoneButton(action: {(popover,selectedRow, selectedString) in
                self.reminderId = selectedRow + 1
                self.setupLabelFor(reminder: selectedRow)
               // print("Done \(selectedRow): \(selectedString)")
            })
            .setCancelButton(action: { _, i, v in
                print("Cancelled")
            })
            .appear(originView: reminderInput!, baseViewController: self)
    }
    
    func runOverEventType() {
        //GeneralConfigurations
                
        switch(AppConfigs.EVENT_MODE){
        case 0: //New
            prepareForNewEvent()
            break
        default: //Edit => View
            prepareForViewEvent()
            break;
        }
    }
    
    func prepareForNewEvent(){
        //More Configurations
        //askForName()
        
        self.addNutButton!.isEnabled = false
        self.addNutButton!.isHidden = true
        
        self.openComments!.isEnabled = false
        self.openComments!.isHidden = true
    }
    
    func prepareForViewEvent(){
        if self.fruit != nil {
            let event = fruit?.fruit as! Dictionary<String, Any>
            gameInput?.text = event["game_title"] as! String
            platformInput?.text = event["platform"] as! String
            self.navigationController!.title = event["title"] as! String
            
            setupLabelFor(status: event["status"] as! Int)
            
            var number = 0
            let reminders = fruit?.reminders
            print(reminders!.count)
            
            if (reminders?.count == 1) {
                let reminder = reminders![0]
                
                print("Number=>%d",reminder.reminder)
                number = reminder.reminder
            }
            
            let seconds = Double(event["date_promise"] as! String)!/1000.00
            
            let nuts = fruit?.hanged
            print(nuts!.count)
            
            self.nutsTableView!.receive(nuts!)
            self.nutsTableView!.reloadData()
            
            setupLabelFor(reminder: number)
            setupLabelFor(date: Date(timeIntervalSince1970: seconds))
            
            self.navigationItem.title? = event["title"] as! String
            
        }
    }
    
    func setupLabelFor(status: Int){
        switch status {
        case 1:
            statusInput?.text = "Creado"
            break
        case 2:
            statusInput?.text = "En espera"
            break
        case 3:
            statusInput?.text = "Jugando"
            break
        case 4:
            statusInput?.text = "Finalizado"
            break
        case 5:
            statusInput?.text = "Cancelado"
            break
        default:
            statusInput?.text = "Nuevo evento"
            break
        }
    }
    
    func setupLabelFor(date: Date){
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy HH:mm")
        dateInput?.text = formatter.string(from: date)
        
        self.date_string = String((Double(date.timeIntervalSince1970) * 1000.0))
        print("EPOCH: "+self.date_string)
    }
    
    func setupLabelFor(reminder: Int){
        switch reminder {
        case 1:
            reminderInput?.text = "5 min"
            break
        case 2:
            reminderInput?.text = "15 Min"
            break
        case 3:
            reminderInput?.text = "30 Min"
            break
        case 4:
            reminderInput?.text = "1 Hr"
            break;
        case 5:
            reminderInput?.text = "2 Hrs"
            break
        default:
            reminderInput?.text = "None"
            break
        }
    }
    
    func receiveFruit(event: Fruit){
        self.fruit = event
        let fdic = event.fruit as! Dictionary<String, Any>
        
        self.fruit_id = fdic["id"] as! String
        
        print("Si Se pasa el evento: ")
        print(self.fruit)
    }
  
    func askForName(){
        let alert = UIAlertController.init(title: "Nombre del evento", message: "Ej: Mi Evento", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Mi evento"
            textField.isSecureTextEntry = false
        })
        alert.addAction(UIAlertAction.init(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: {[weak alert](action) in
            print("Cancel Save or Update")
        }))
        alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: {[weak alert](action) in
            //Actualiza el estado de la persona
            let title_string = (alert?.textFields![0])?.text!
            
            if AppConfigs.EVENT_MODE == 0{ //New
                self.createNewEventWith(Title: title_string!)
            }else{//View-Edit
                self.updateEventWith(Title: title_string!)
            }
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(_ actionId: Int){
        var msg = "Exito"
        switch actionId {
        case 1:
            msg = "Ocurrion un error"
            break
        default:
            msg = "Exito"
            break
        }
        
        let alert = UIAlertController.init(title: "It's On!", message: msg, preferredStyle: UIAlertControllerStyle.alert)
       
        alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: {[weak alert](action) in
            alert?.dismiss(animated: true, completion: nil)
            self.dismissView(sender: alert!)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "commentsSegue" {
            
            let controller = (segue.destination as! UINavigationController).topViewController as! CommentsViewController
            
            if AppConfigs.EVENT_MODE != 0 {
                controller.receiveComments(comments: (self.fruit?.comments)!,
                                           andId: self.fruit_id)
            }
        }
    }
 

}
