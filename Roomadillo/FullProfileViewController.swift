//
//  FullProfileViewController.swift
//  Roomadillo
//
//  Created by Benjamin Devore on 4/11/16.
//  Copyright © 2016 Benjamin Devore. All rights reserved.
//

import UIKit

class FullProfileViewController: UIViewController {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    var firstName : String?
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.image = image
        nameLabel.text = firstName
        print(profileImageView)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func exitButtonPressed(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
