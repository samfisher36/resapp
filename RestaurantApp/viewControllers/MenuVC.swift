//
//  MenuVC.swift
//  RestaurantApp
//
//  Created by mitesh Churi on 22/02/21.
//

import UIKit

class MenuVC: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var lblName:UILabel!
    @IBOutlet weak var dp_img:UIImageView!
    
    var menu = ["Current Orders","My Previous Order","Analytics","Menu categories","Leaderboard","Logout","Settings"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! MenuCell
        cell.name!.text = menu[indexPath.row]
        //cell.icon.image = UIImage.init(named: menu[indexPath.row].lowercased())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if (indexPath.row == 4) {
            self.performSegue(withIdentifier: "leader", sender: self)
            return
        }
        
        if (indexPath.row == 0) {
            self.navigationController?.popViewController(animated: true)
            }
        
        else if (indexPath.row == 1) {
            self.performSegue(withIdentifier: "prev", sender: self)
        } else if (indexPath.row == 2) {
            self.performSegue(withIdentifier: "analytics", sender: self)
        }
        else if (indexPath.row == 5) {
            confirmLogout()
        }
        else if (indexPath.row == 6) {
            self.performSegue(withIdentifier: "setting", sender: self)
        }
        else {
            self.performSegue(withIdentifier: "menucat", sender: self)
        }
    }
    
    func confirmLogout() {
        let alert = UIAlertController(title: "Confirm Logout", message: "Are you sure you want to logout from app", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: {_ in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: {_ in
            
        }))

        self.present(alert, animated: true)
    }
    
    func logout() {
        do {
            UserDefaults.standard.removeObject(forKey: "name")
            UserDefaults.standard.removeObject(forKey: "uid")
            let alert = UIAlertController(title: "Logged out successfully", message: "", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Close", style: .default, handler: {_ in
                
                    let storyboard = UIStoryboard.init(name: "Main", bundle: .main)
                    let vc = storyboard.instantiateViewController(withIdentifier: "login")

                    UIApplication.shared.keyWindow!.rootViewController = vc
                    
                    UIApplication.shared.keyWindow!.makeKeyAndVisible()
                
            }))

            self.present(alert, animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if ((UserDefaults.standard.value(forKey: "name")) != nil) {
            let name  = UserDefaults.standard.value(forKey: "name")
            lblName.text = name as! String
            
            var photo_url  = UserDefaults.standard.value(forKey: "photo_url") as! String
            photo_url  = photo_url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!
            
            dp_img.sd_setImage(with: URL(string: photo_url), completed: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
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
