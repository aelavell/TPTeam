//
//  BuildTeamViewController.swift
//  TPTeam
//
//  Created by Allan Lavell on 2014-11-14.
//  Copyright (c) 2014 ThinkRad. All rights reserved.
//

import UIKit

class BuildTeamViewController: UITableViewController {
    func nextPressed(sender : AnyObject) {
        self.performSegueWithIdentifier("NAME_TEAM_SEGUE", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "NEXT", style: UIBarButtonItemStyle.Plain, target: self, action: "nextPressed:")
    }
}