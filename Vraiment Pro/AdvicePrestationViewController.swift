//
//  AdvicePrestationViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 07/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdvicePrestationViewController: UIViewController {
    @IBOutlet weak var datePicker: UIPickerView!

    let mois = ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Aout","Septembre","Octobre","Novembre","Décembre"]
    let annee = ["2016","2015","2014"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
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

extension AdvicePrestationViewController : UIPickerViewDataSource{
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 2
    }
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        if component == 0 {
            return 12
        }
        else{
            return annee.count
        }
    }
}

extension AdvicePrestationViewController : UIPickerViewDelegate{
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView{
        if component == 0 {
            let monthLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            
            monthLabel.backgroundColor = UIColor.clear
            monthLabel.text = mois[row]
            monthLabel.textAlignment = NSTextAlignment.center
            monthLabel.font = UIFont(name: "Raleway", size: 17)
            return monthLabel
        }
        else{
            let yearLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            
            yearLabel.backgroundColor = UIColor.clear
            yearLabel.text = annee[row]
            yearLabel.textAlignment = NSTextAlignment.center
            yearLabel.font = UIFont(name: "Raleway", size: 17)
            return yearLabel
        }
    }
}
