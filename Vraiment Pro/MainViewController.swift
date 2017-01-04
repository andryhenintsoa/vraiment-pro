//
//  MainViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 11/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var leftViewController: SidebarViewController?
    
    var activityIndicator = UIActivityIndicatorView()
//    var activityIndicator = CustomActivityIndicator(text: "Chargement")

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
// MARK: - Functions for the sidebar
    func displaySidebar(_ position:CGFloat = 0, close:Bool = false) {
        
        if leftViewController != nil{
            animateSidebarXPosition(self.view.frame.width)
            leftViewController?.closeSideBar(nil)
            leftViewController = nil
            return
        }
        
        addSidebarViewController()
        animateSidebarXPosition(position)
        
    }
    
    func addSidebarViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.sidebarViewController()
            
            view.addSubview(leftViewController!.view!)
            
//            leftViewController!.view.frame = CGRect(x: self.view.bounds.width, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
            
            leftViewController!.view.frame.origin.x = self.view.bounds.width
            
            addChildViewController(leftViewController!)
        }
    }
    
    func animateSidebarXPosition(_ targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.leftViewController!.view.frame.origin.x = targetPosition
            }, completion: completion)
    }

// MARK: - Functions for the loading spinner
    func spinnerLoad(_ loading:Bool = true) {
        if(loading){
            activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0,y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
            activityIndicator.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
            view.addSubview(activityIndicator)
        
            activityIndicator.startAnimating()
        }
        else{
            print("Spinner stop")
            activityIndicator.isHidden = true
            activityIndicator.removeFromSuperview()
            activityIndicator.stopAnimating()
            self.view.reloadInputViews()
        }
        
//        if(loading){
//            self.view.addSubview(activityIndicator)
//            self.activityIndicator.show()
//        }
//        else{
//            self.activityIndicator.hide()
//        }
    }
    
    func spinnerHide(){
        spinnerLoad(false)
    }

    
// MARK: - Functions for alerting users
    func alertUser(title:String?, message:String?, completion: ((UIAlertAction) -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: completion))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func alertConfirmUser(title:String?, message:String?, completion: ((UIAlertAction) -> Void)?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: completion))
        
        alertController.addAction(UIAlertAction(title: "Annuler", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
// MARK : Functions taking the result of webservices
    func reloadMyView(_ wsData:Any? = nil) {
    }
    
    func reloadMyViewWithError() {
        alertUser(title: "Erreur de connexion", message: "Veuillez réessayer plus tard")
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



private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
    
    class func sidebarViewController() -> SidebarViewController? {
        return mainStoryboard().instantiateViewController(withIdentifier: "SidebarViewController") as? SidebarViewController
    }
    
}

