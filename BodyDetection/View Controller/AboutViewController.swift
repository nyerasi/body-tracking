//
//  AboutViewController.swift
//  BodyDetection
//
//  Created by Nikhil Yerasi on 12/3/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import UIKit

protocol ModalViewControllerDelegate: class {
    func removeBlurredBackgroundView()
}

class AboutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    weak var delegate: ModalViewControllerDelegate?
    let data = Data()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        view.backgroundColor = UIColor.clear
    }
    @IBAction func closeAboutViewController(_ sender: Any) {
        print("dismiss view controller")
        dismiss(animated: true, completion: nil)
        delegate?.removeBlurredBackgroundView()
    }
    
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.people.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0;//Choose your custom row height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamMemberCell", for: indexPath)
        if let cell = cell as? PersonTableViewCell {
            let person = data.people[indexPath.row]
            cell.profileImageView.image = person.profileImage
            cell.nameLabel.text = person.name
            cell.affiliationLabel.text = person.affiliation
        }
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
