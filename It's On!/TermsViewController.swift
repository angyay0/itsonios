//
//  TermsViewController.swift
//  itson
//
//  Created by Eduardo Pérez on 14/04/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    @IBOutlet var webView : UIWebView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let url = Bundle.main.url(forResource: "terms_es", withExtension: "html")
        
        webView?.loadRequest(URLRequest(url: url!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissView(sender: UIBarButtonItem){
        self.dismiss(animated: true, completion: nil)
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
