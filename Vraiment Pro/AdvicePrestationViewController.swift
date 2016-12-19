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

    @IBAction func closeKeyboard(_ sender: UITextField?) {
        natureLabel.resignFirstResponder()
    }
    
    @IBAction func goToSummary(_ sender: UIButton) {
        closeKeyboard(nil)
        
        if natureLabel.text == "" {
            self.alertUser(title: "Erreur", message: "Vous devez préciser la nature de la prestation")
        } else {
            if(sender.currentTitle == "Plus tard"){
                print("Plus tard")
                joiningBillOption = .later
                performSegue(withIdentifier: "toSummary", sender: sender)
            }
            else if(sender.currentTitle == "Maintenant"){
                print("Maintenant")
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
