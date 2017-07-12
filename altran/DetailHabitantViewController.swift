//
//  DetailHabitantViewController.swift
//  altran
//
//  Created by Juan S. Landy on 11/7/17.
//
//

import UIKit

class DetailHabitantViewController: UIViewController {

    @IBOutlet weak var imageHabitant: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelAge: UILabel!
    @IBOutlet weak var labelWeight: UILabel!
    @IBOutlet weak var labelHeight: UILabel!
    @IBOutlet weak var labelHairColor: UILabel!
    
    var selectedGnome = Gnome()
    
    @IBOutlet weak var viewProfessions: UIView!
    @IBOutlet weak var viewFriends: UIView!
    @IBOutlet weak var collectionProfessions: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.labelName.text = selectedGnome.name
        self.labelAge.text = "🎂 \(selectedGnome.age)"
        self.labelHeight.text = "📐 \(selectedGnome.height)"
        self.labelWeight.text = "⚖️ \(selectedGnome.weight)"
        self.labelHairColor.text = "💇🏼 \(selectedGnome.hair_color)"
        self.labelHairColor.adjustsFontSizeToFitWidth = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            let imageUrl = URL(string: self.selectedGnome.thumbnail)
            let imageData:NSData = NSData(contentsOf: imageUrl!)!
            let imageView = UIImageView(frame: CGRect(x:0, y:0, width:200, height:200))
            imageView.center = self.view.center
            
            // When from background thread, UI needs to be updated on main_queue
            DispatchQueue.main.async {
                let image = UIImage(data: imageData as Data)
                self.imageHabitant.image = image
                
            }
        }
        
        if self.selectedGnome.proffesions.count <= 0{
            self.viewProfessions.isHidden = true
        }
        if self.selectedGnome.friends.count <= 0{
            self.viewFriends.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
extension DetailHabitantViewController: UICollectionViewDelegate, UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0{
            return self.selectedGnome.proffesions.count
        }
        else{
            return self.selectedGnome.friends.count
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cells", for: indexPath) as! ProfessionsCollectionViewCell
            cell.labelProfession.text = self.selectedGnome.proffesions[indexPath.row]
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cells", for: indexPath) as! FriendsCollectionViewCell
            cell.labelFriend.text = self.selectedGnome.friends[indexPath.row]
            return cell
        }
        
    }
}
