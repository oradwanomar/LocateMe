//
//  TripsTableViewController.swift
//  LocateMe
//
//  Created by Omar Ahmed on 19/07/2022.
//

import UIKit

class TripsTableViewController: UITableViewController {
    
    var trips: [Trip] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func addTripNavigator(_ sender: Any) {
        let mapVC = self.storyboard?.instantiateViewController(withIdentifier: "mapVC") as! MyLocationVC
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
}

// MARK: - Table view data source

extension TripsTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "Trip"

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Trips"
    }
}

// MARK: - Table view delegate

extension TripsTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
