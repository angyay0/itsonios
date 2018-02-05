//
//  LoginViewController.swift
//  itson
//
//  Created by Eduardo Pérez on 14/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit
import JQProgressHUD

class LoginViewController: UIViewController {
    
    @IBOutlet var userInput: UITextField?
    
    @IBOutlet var passInput: UITextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.   
        if !LocalDataSource.getInstance().isFirstLaunch() {
            //LocalDataSource.getInstance().getCoconutKey()
            self.showPickerPopover(sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showPickerPopover(sender: AnyObject){
        
        let user = userInput?.text!
        let pass = passInput?.text!
        
        if user != nil && !(user?.isEmpty)! {
            if pass != nil && !(pass?.isEmpty)! {
                
                JQProgressHUDTool.jq_showNormalHUD()
                
                DataProvider.getInstance().authenticate(user: user!, password: pass!, completion: { (response, error) -> Void in
                    
                    JQProgressHUDTool.jq_hideHUD()
                    
                    if error == nil {
                        print("No Error: "+(response?.toString())!)
                        AppConfigs.RUNTIME_TOKEN = (response?.data["token"].string!)!
                        let user = NutAuth()
                        user.buildFrom(json: (response?.data)!)
                        
                        LocalDataSource.getInstance().storeCoconut(token: user.token, for: (user.nut?["gamertag"]!)!, with: (user.nut?["message"]!)!, set: (user.pref?["notifications"])!, and: (user.pref?["reminders"]!)!)
                        
                        LocalDataSource.getInstance().storePassword(pass: pass!)
                        
                        
                        self.navigateToHome()
                        
                        //self.dismiss(animated: true, completion: nil)
                        return
                    }
                    
                    error!.show(self, completion:{(errorType) -> Void in
                        print("UPS!")
                    })
                    
                })
                
            } else {
                AppConfigs.buildAppDialog(self, "Contraseña Inválida")
            }
        }else {
            AppConfigs.buildAppDialog(self, "Usuario incorrecto")
        }
        
     //   DatePickerPopover(title: "DatePicker")
       //     .appear(originView:sender as! UIView, baseViewController: self)
        
        /*
        DataProvider.getInstance().update(Preferences: ["reminders": false, "notifications": false], completion: { (response,error) -> Void in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        })*/
        /*
        DataProvider.getInstance().update(Message: ["status": "iOS Development"], completion: { (response,error) -> Void in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        })*/
        /*
        DataProvider.getInstance().coconutHang(ToFruit: "26b4b433-4618-4f8f-baff-353c30fb7b39", AComment: "Hola!", completion: { (response,error) -> Void in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        })*/
        /*
        DataProvider.getInstance().createNew(Fruit: ["title": "Tryout 2","game":"Pokemon X","platform":"Nintendo 3DS","date_promise": "1525292066000","demolition":[],"hanging":[]], completion: { (response,error) -> Void in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        })*/
        /*
        DataProvider.getInstance().fetchFruits( completion: { (response,error) -> Void in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        })*/
        /*
        DataProvider.getInstance().fetchDemolitions(For: "26b4b433-4618-4f8f-baff-353c30fb7b39") { (response, error) in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        }*/
        /*
        DataProvider.getInstance().fetchHangedCoconuts(For: "26b4b433-4618-4f8f-baff-353c30fb7b39") { (response, error) in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        }*/
        /*
        DataProvider.getInstance().fetchComments(For: "26b4b433-4618-4f8f-baff-353c30fb7b39") { (response, error) in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        }*/
        /*
        DataProvider.getInstance().fetchFruit(Tree: "26b4b433-4618-4f8f-baff-353c30fb7b39") { (response, error) in
            
            if error == nil {
                print("No Error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
        }*/
        /*
        let payload = [
            "fruit": "fruit ID",
            "title": "title",
            "game": "Game Title",
            "platform": "date_promise",
            "status": "statusID",
            "demolition": "reminder"
            ]
        
        DataProvider.getInstance().update(Fruit: payload) { (response, error) in
            
            if error == nil {
                print("No error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion: { (errorType) in
                print("UPS!")
            })
        }*/
        /*
        let payload = [
            "name": "Eduardo",
            "last": "Perez",
            "email": "angel@email.com",
            "user": "angelito",
            "pwd": "4ngeLect3r%"
        ]
        
        DataProvider.getInstance().signupFor(Request: payload) { (response, error) in
            
            if error == nil {
                print("No error: "+(response?.toString())!)
                return
            }
            
            error!.show(self, completion: { (errorType) in
                print("UPS!")
            })
            
        }
        */
    }
    
    func navigateToHome() {
        self.present((self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController"))!, animated: true, completion: nil)
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
