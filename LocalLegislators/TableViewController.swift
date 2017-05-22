//
//  TableViewController.swift
//  LocalLegislators
//
//  Created by Grey Patterson on 2017-05-22.
//  Copyright © 2017 Grey Patterson. All rights reserved.
//

import UIKit
import SafariServices

class TableViewController: UITableViewController {
    
    var legislators = [Legislator]()

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
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return legislators.count
    }
    
    func presentLegislator(_ sender: UITapGestureRecognizer){
        let location = sender.location(in: tableView)
        guard let indexPath = tableView.indexPathForRow(at: location) else{
            return
        }
        let legislator = legislators[indexPath.row]
        let SFVC = SFSafariViewController(url: legislator.website)
        self.present(SFVC, animated: true, completion: nil)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let legislator = legislators[indexPath.row]
        cell.textLabel?.text = legislator.name
        cell.detailTextLabel?.text = legislator.twitter
        
        let tapDetector = UITapGestureRecognizer(target: self, action: #selector(TableViewController.presentLegislator(_:)))
        cell.addGestureRecognizer(tapDetector)
        
        return cell
    }
    @IBAction func locationChange(_ sender: Any) {
        let UIAc = UIAlertController(title: "New Location", message: "Enter the coordinates you'd like to look up.", preferredStyle: .alert)
        UIAc.addTextField { (UITF) in //UITF is UITextField
            UITF.placeholder = "Latitude"
        }
        UIAc.addTextField { (UITF) in
            UITF.placeholder = "Longitude"
        }
        let saveAction = UIAlertAction(title: "Search", style: .default) { (UIAA) in // UIAA is UIAlertAction
            let lat = UIAc.textFields![0] as UITextField
            let lon = UIAc.textFields![1] as UITextField
            if let latitude = lat.text, let longitude = lon.text{
                print("Search for latitude \(latitude) and longitude \(longitude)")
                self.search(latitude: latitude, longitude: longitude)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        UIAc.addAction(saveAction)
        UIAc.addAction(cancelAction)
        self.present(UIAc, animated: true, completion: nil)
    }
    
    func search(latitude: String, longitude: String){
        legislators = [Legislator]() // clear out old results
        guard let encLat = latitude.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let encLong = longitude.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return()
        }
        let url = URL(string: "http://congress.api.sunlightfoundation.com/legislators/locate?latitude=\(encLat)&longitude=\(encLong)")
        URLSession.shared.dataTask(with: url!) {
            (data, response, err) in
            if let err = err {
                print("err: \(err)")
            }
            else if let data = data {
                if let json = try! JSONSerialization.jsonObject(with: data) as? [String: AnyObject] {
                    for result in json["results"] as! [[String: AnyObject]]{
                        let title = result["title"] as! String
                        let firstName = result["first_name"] as! String
                        let lastName = result["last_name"] as! String
                        let twitter = result["twitter_id"] as! String
                        let site = result["website"] as! String
                        let website = URL(string: site) ?? URL(string: "https://www.whitehouse.gov")!
                        let name = "\(title) \(firstName) \(lastName)"
                        let legislator = Legislator(name, twitter: twitter, website: website)
                        self.legislators.append(legislator)
                    }
                    if(self.legislators.count > 0){
                        self.tableView.reloadData()
                    }
                }
            }
        }.resume()
    }
    
 

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
