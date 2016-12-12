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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displaySidebar(_ position:CGFloat = 0) {
        addSidebarViewController()
        animateSidebarXPosition(position)
    }
    
    func addSidebarViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.sidebarViewController()
            
            view.addSubview(leftViewController!.view!)
            leftViewController!.view.frame.origin.x = self.view.bounds.width
            
            addChildViewController(leftViewController!)
        }
    }
    
    func animateSidebarXPosition(_ targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.leftViewController!.view.frame.origin.x = targetPosition
            }, completion: completion)
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

