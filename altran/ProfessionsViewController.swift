//
//  ProfessionsViewController.swift
//  altran
//
//  Created by Juan S. Landy on 11/7/17.
//
//

import UIKit

class ProfessionsViewController: UIViewController {

    let parse = ParseData()
    var gnomeArray : [Gnome] = []
    var profession:[String] = []
    
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getDataFromURL(url: parse.urlRequest)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getDataFromURL(url: URL) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            if (try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [[String:Any]]) != nil {
                // Ya tenemos el JSON en la constante datos
                self.gnomeArray = self.parse.dataToJson(data: data!)
                self.profession = self.parse.getProfessions(list: self.gnomeArray)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    self.tableView.reloadData()
                })
            }
            }.resume()
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
extension ProfessionsViewController:UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.profession.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cells", for: indexPath) 
        cell.textLabel?.text = self.profession[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newArray:[Gnome] = parse.filterGnomesByProfession(profession: self.profession[indexPath.row], gnomeArray: self.gnomeArray)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Habitants") as! HabitantsViewController
        nextViewController.gnomesData = newArray
        self.navigationController?.pushViewController(nextViewController, animated: true)
    }
}
