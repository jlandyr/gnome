//
//  HabitantsViewController.swift
//  altran
//
//  Created by Juan S. Landy on 10/7/17.
//
//

import UIKit

class HabitantsViewController :UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionHabitants: UICollectionView!
    
    var task: URLSessionDownloadTask!
    var session: URLSession!
    var cache:NSCache<AnyObject, AnyObject>!
    var tableData : [AnyObject]!
    
    var gnomesData: [Gnome] = []
    var arrayFiltered:[Gnome] = []
    
    var searchActive = false
    
    let parseData = ParseData()
    
    //MARK: - View Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        session = URLSession.shared
        task = URLSessionDownloadTask()
        
        self.tableData = []
        self.cache = NSCache()
        
        if gnomesData.count <= 0 {
            let task2 = session.dataTask(with: parseData.urlRequest) { (data, response, error) in
                // this is where the completion handler code goes
                if let response = response {
                    print(response)
                }
                if let error = error {
                    print(error)
                }
                if data != nil {
                    self.loadData(data: data!)
                }else {
                    print("Error: did not receive data")
                    return
                }
                
            }
            task2.resume()
        }
        else
        {
            DispatchQueue.main.async(execute: { () -> Void in
                self.collectionHabitants.reloadData()
            })
        }
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - parse data
    func loadData(data:Data){
        do{
            let dic = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as AnyObject
            
            self.tableData = dic.value(forKey : "Brastlewark") as? [AnyObject]
            gnomesData = ParseData.parseAllData(anyObj: self.tableData)
            
            DispatchQueue.main.async(execute: { () -> Void in
                self.collectionHabitants.reloadData()
            })
        }
        catch{
            print("something went wrong, try again")
        }
        
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
//MARK: - UICollectionView
extension HabitantsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.searchActive == true {
            return self.arrayFiltered.count
            
        }else{
            return self.gnomesData.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cells", for: indexPath) as! HabitantsCollectionViewCell
        var gnome = Gnome()
        if self.searchActive == true {
            
            gnome = arrayFiltered[indexPath.row]
            
        }else{
            gnome = gnomesData[indexPath.row]
            
        }
            cell.labelName.text = gnome.name
            cell.labelAge.text = String("🎂\n") + String(gnome.age)
            cell.labelHeight.text = String("📐\n") + String(gnome.height)
            cell.labelWeight.text = String("⚖️\n") + String(gnome.weight)
            cell.imageThumbnail.image = nil
            if gnome.hair_color == "Pink" {
                cell.labelGender.text = "♀"
            }else{
                cell.labelGender.text = "♂"
            }
            if (self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil){
                // Use cache
                print("Cached image used, no need to download it")
                cell.imageThumbnail?.image = self.cache.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
            }else{
                print("downloading image...")
                cell.activityIndicator.isHidden = false
                let profilePicture = String(gnome.thumbnail)
                let url:URL! = URL(string: profilePicture!)
                task = session.downloadTask(with: url, completionHandler: { (location, response, error) -> Void in
                    if let data = try? Data(contentsOf: url){
                        DispatchQueue.main.async(execute: { () -> Void in
                            
                            let img:UIImage! = UIImage(data: data)
                            cell.imageThumbnail.image = img
                            self.cache.setObject(img, forKey: (indexPath as NSIndexPath).row as AnyObject)
                            cell.activityIndicator.isHidden = true
                            
                        })
                    }
                })
                task.resume()
            }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "DetailHabitant") as! DetailHabitantViewController
        if self.searchActive == true{
            nextViewController.selectedGnome = self.arrayFiltered[indexPath.row]
        }else{
            nextViewController.selectedGnome = self.gnomesData[indexPath.row]
        }
        self.navigationController?.pushViewController(nextViewController, animated: true)
//        self.presentViewController(nextViewController, animated:true, completion:nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let yourWidth = self.collectionHabitants.bounds.width/3.0 - 6
        let yourHeight = CGFloat(150)
        
        return CGSize(width: yourWidth, height: yourHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(5,5,5,5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
//MARK: -UISearchBar
extension HabitantsViewController: UISearchBarDelegate
{
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
        //        searchActive = true
        if searchBar.text == "" || searchBar.text == " "
        {
            searchActive = false
        }
        else
        {
            searchActive = true
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        self.searchBar.endEditing(true)
//        self.searchBar.showsCancelButton = false
        self.collectionHabitants.reloadData()
        self.cache.removeAllObjects()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true;
        self.searchBar.endEditing(true)
//        self.searchBar.showsCancelButton = false
        self.collectionHabitants.reloadData()
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.arrayFiltered = self.gnomesData.filter({ (text) -> Bool in
            var tmp:NSString = ""
            
            let a = text
            tmp = a.name as NSString
            let range = tmp.range(of: searchText, options: .caseInsensitive)
            
            return range.location != NSNotFound
        })
        if(self.arrayFiltered.count == 0){
            searchActive = false;
            
        } else {
            searchActive = true;
            self.cache.removeAllObjects()
        }
        self.collectionHabitants.reloadData()
    }
}
