//
//  NutTableView.swift
//  itson
//
//  Created by Angel Eduardo Pérez Cruz on 26/09/17.
//  Copyright © 2017 aimos studio. All rights reserved.
//

import UIKit

class NutTableView: UITableView, UITableViewDelegate, UITableViewDataSource {

    var nuts: Array<Nut> = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nuts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nutPlayerIdentifier", for: indexPath) as! NutTableViewCell
        let nut = nuts[indexPath.row]

        //Nut Configuration
        cell.configureRowFor(nut.name, with: "")
        
        return cell
    }
    
    func receive(_ nutData: Array<Nut>) {
        self.nuts = nutData
        self.delegate = self
        self.dataSource = self
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
