//
//  SignUpViewController.swift
//  itson
//
//  Created by Eduardo Pérez on 14/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit

class SignUpViewController: UITableViewController {
    
    @IBOutlet var userInput: UITextField?
    @IBOutlet var emailInput: UITextField?
    @IBOutlet var nameInput: UITextField?
    @IBOutlet var lastInput: UITextField?
    @IBOutlet var passInput: UITextField?
    @IBOutlet var confirmPassInput: UITextField?
    @IBOutlet var confirmTerms: UISwitch?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    @IBAction func signup(sender: Any){
        
        let user = userInput?.text!
        let email = emailInput?.text!
        let pass = passInput?.text!
        let cpass = confirmPassInput?.text!
        let checked = confirmTerms?.isOn
        let name = nameInput?.text!
        let last = lastInput?.text!
        
        if !checked! {
            AppConfigs.buildAppDialog(self, "Acepte los términos y condiciones")
            return
        }
        
        if cpass == pass {
            let isValidCode = FieldsValidator.getInstance().isValidSignupForm(name: name!, last: last!, email: email!, user: user!, pwd: pass!)
            
            if isValidCode == 0 {
                
                let parameters = [
                    "email": email!,
                    "user": user!,
                    "name": name!,
                    "last": last!,
                    "pwd": pass!
                ]
                
                DataProvider.getInstance().signupFor(Request: parameters) { (response, error) -> Void in
                    
                    if error == nil {
                        print("No Error: "+(response?.toString())!)
                        AppConfigs.RUNTIME_TOKEN = (response?.data["token"].string!)!
                        
                        self.present((self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"))!, animated: true, completion: nil)
                        return
                    }
                    
                    error!.show(self, completion:{(errorType) -> Void in
                        print("UPS!")
                    })
                    
                }
                
            }else {
                handleErrorCode(isValidCode)
            }
        }
        
    }

    @IBAction func dismissView(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
    }
    
    func handleErrorCode(_ code: Int){
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
