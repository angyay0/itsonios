//
//  CommentsViewController.swift
//  itson
//
//  Created by Eduardo Pérez on 20/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit
import SwiftyJSON
import BOZPongRefreshControl

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var commentsTable: UITableView?
    
    @IBOutlet weak var inputTextField: UITextField?

    var fruit_id: String = ""
    
    var comments = Array<NutComment>()

    var pongControl: BOZPongRefreshControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Configura para si se recibe la notificacion de comunicaciones
        //se actualicen los comentarios
        configureAsObserver()
    }
    
    override func viewDidLayoutSubviews() {
        assingRefreshControl()
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
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentTableViewCell
        
        // Configure the cell...
        let comment = comments[indexPath.row]
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("dd/MM/yyyy HH:mm")
        
        let seconds = Double(comment.date)!/1000.00
        let date_string = formatter.string(from: Date(timeIntervalSince1970: seconds))
        
        cell.configureCellFor(Nut: comment.nut, a: comment.comment, on: date_string)
        
        return cell
    }
    
    @IBAction func dismissView(sender: AnyObject){
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postComment(sender: AnyObject) {
        let text = inputTextField?.text
        
        if FieldsValidator.getInstance().isValidComment(comment: text!) {
            postCoconut(Comment: text!)
        }else {
            let alert = UIAlertController.init(title: "It's On!", message: "El comentario no es valido", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction.init(title: "Ok", style: UIAlertActionStyle.default, handler: {[weak alert](action) in
                alert?.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func fetchComments(){
        DataProvider.getInstance().fetchComments(For: fruit_id) { (response, error) in
            
            if error == nil {
                print((response?.data))
                
                let commentsRefresh = (response?.data.arrayValue)!
                self.comments = Array<NutComment>()
                
                for c in commentsRefresh {
                    let cmm = NutComment()
                    cmm.convertFrom(JSON: c.dictionaryObject!)
                
                    self.comments.append(cmm)
                }
                
                self.commentsTable?.reloadData()
                self.pongControl!.finishedLoading()
                
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
               self.pongControl!.finishedLoading()
                print("UPS!")
            })
        }
    }
    
    func postCoconut(Comment comment: String){
        DataProvider.getInstance().coconutHang(ToFruit: fruit_id, AComment: comment) { (response, error) in
            
            if error == nil {
                self.inputTextField?.text = ""
                
                self.fetchComments()
                
                return
            }
            
            error!.show(self, completion:{(errorType) -> Void in
                print("UPS!")
            })
            
        }
    }
    
    func assingRefreshControl() {
        self.pongControl = BOZPongRefreshControl .attach(to: commentsTable, withRefreshTarget: self, andRefreshAction: #selector(CommentsViewController.refreshAction))
    }
    
    @objc func refreshAction() {
        //  self.pongControl?.beginLoading()
        fetchComments()
    }
    
    func receiveComments(comments: Array<NutComment>, andId: String){
        self.comments = comments
        self.fruit_id = andId
        
        print("Si se pasa los comentarios y el id: "+self.fruit_id)
    }
    
    func configureAsObserver() {
        let nc = NotificationCenter.default
        
        nc.addObserver(forName: Notification.Name(rawValue: AppConfigs.RECEIVER_COMMENTS), object: nil, queue: nil, using: notificationHandler)
        
    }

    func notificationHandler(notification:Notification) -> Void {
        print("Catch Notification")
        
        fetchComments()
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
