//
//  AdvicePrestationViewController.swift
//  Vraiment Pro
//
//  Created by Andry Henintsoa Razafindramanana on 07/12/2016.
//  Copyright © 2016 Sparks MG. All rights reserved.
//

import UIKit

class AdvicePrestationViewController: ImagePickerViewController {
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var natureLabel: UITextField!

    var selectedClient: [String:String]!
    var sendingType:SendingType!
    var joiningBillOption:JoiningBillOption?
    
    let mois = ["Janvier","Février","Mars","Avril","Mai","Juin","Juillet","Août","Septembre","Octobre","Novembre","Décembre"]
    var annee = ["2017","2016","2015"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        natureLabel.attributedPlaceholder = NSAttributedString(string: "Ex : Pose de lavabo", attributes: [NSFontAttributeName: natureLabel.font!.italic(), NSForegroundColorAttributeName: UIColor(red: 68/255.0, green: 161/255.0, blue: 43/255.0, alpha: 1) ])
        
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        
        annee = ["\(year)","\(year - 1)","\(year - 2)"]
        
        datePicker.reloadAllComponents()
        
        datePicker.selectRow(month-1, inComponent: 0, animated:true)
        datePicker.selectRow(annee.index(of: "\(year)")!, inComponent: 1, animated:true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeController(_ sender: AnyObject) {
        let _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func toogleSidebar(_ sender: AnyObject) {
        self.displaySidebar()
    }

    @IBAction func closeKeyboard(_ sender: AnyObject?) {
        natureLabel.resignFirstResponder()
    }
    
    @IBAction func goToSummary(_ sender: UIButton) {
        closeKeyboard(nil)
        
        if natureLabel.text == "" {
            self.alertUser(title: "Erreur", message: "Vous devez préciser\n la nature de la prestation")
        } else {
            if(sender.currentTitle == "Plus tard"){
                joiningBillOption = .later
                performSegue(withIdentifier: "toSummary", sender: sender)
            }
            else if(sender.currentTitle == "Maintenant"){
                joiningBillOption = .now
                
                self.segueNextName = "toSummary"
                chooseTakingPictureMode()
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSummary" {
            let destination = segue.destination as? AdviceSummaryViewController
            destination?.selectedClient = self.selectedClient
            destination?.sendingType = self.sendingType
            destination?.joiningBillOption = self.joiningBillOption
            
            let mMois = mois[datePicker.selectedRow(inComponent: 0)]
            let mAnnee = annee[datePicker.selectedRow(inComponent: 1)]
            
            
            destination?.prestationMonth = "\(datePicker.selectedRow(inComponent: 0)+1)"
            destination?.prestationYear = "\(mAnnee)"
            
            destination?.prestationDate = "\(mMois) \(mAnnee)"
            destination?.prestationNature = natureLabel.text
            
            if(imageToSend != nil){
                destination?.imageToSend = self.imageToSend
            }
        }
    }

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
            monthLabel.font = UIFont(name: "Rubik", size: 17)
            return monthLabel
        }
        else{
            let yearLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
            
            yearLabel.backgroundColor = UIColor.clear
            yearLabel.text = annee[row]
            yearLabel.textAlignment = NSTextAlignment.center
            yearLabel.font = UIFont(name: "Rubik", size: 17)
            return yearLabel
        }
    }
}
