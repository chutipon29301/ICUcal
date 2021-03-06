//
//  AppInit.swift
//  ICUcal
//
//  Created by admin on 8/18/2560 BE.
//  Copyright © 2560 Thinc. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import SwiftyJSON

class TabBarViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isAppHasBeenLaunched() {
            
            var formulaList: [Formula] = []
            
            let jsonString = "{\"allFormula\":[{\"name\":\"BMI\",\"variable\":[\"weight\",\"height\"],\"type\":\"General\",\"formula\":\"a/(b*b)\"},{\"name\":\"BSA\",\"variable\":[\"weight\",\"height\"],\"type\":\"General\",\"formula\":\"(a*b/3600)**(0.5)\"},{\"name\":\"Male predicted IBW\",\"variable\":[\"height\"],\"type\":\"General\",\"formula\":\"a-100-(a-150)/4\"},{\"name\":\"Female predicted IBW\",\"variable\":[\"height\"],\"type\":\"General\",\"formula\":\"a-100-(a-150)/2\"},{\"name\":\"PPV\",\"variable\":[\"PPmax\",\"PPmin\",\"PPmean\"],\"type\":\"Hemodynamic\",\"formula\":\"((a-b)/c)*100\"},{\"name\":\"Distensibility Index\",\"variable\":[\"IV CDmax\",\"IV CDmin\"],\"type\":\"Hemodynamic\",\"formula\":\"(a-b)/b\"},{\"name\":\"Collapsibility Index\",\"variable\":[\"IV CDmax\",\"IV CDmin\"],\"type\":\"Hemodynamic\",\"formula\":\"(a-b)/a\"},{\"name\":\"SVR\",\"variable\":[\"M AP\",\"CV P\",\"CO\"],\"type\":\"Hemodynamic\",\"formula\":\"(a-b*79.9)/c\"},{\"name\":\"PVR\",\"variable\":[\"MP AP\",\"PCW P\",\"CO\"],\"type\":\"Hemodynamic\",\"formula\":\"(a-b*79.9)/c\"},{\"name\":\"CO\",\"variable\":[\"V O2\",\"Hb\",\"SaO2\",\"SvO2\"],\"type\":\"Hemodynamic\",\"formula\":\"a/13.4*b*(c-d)\"},{\"name\":\"CI\",\"variable\":[\"CO\",\"BSA\"],\"type\":\"Hemodynamic\",\"formula\":\"a/b\"},{\"name\":\"Male BEE\",\"variable\":[\"weight\",\"height\",\"age\"],\"type\":\"Nutrition\",\"formula\":\"66.473+13.752*a+5.003*b-6.755*c\"},{\"name\":\"Female BEE\",\"variable\":[\"weight\",\"height\",\"age\"],\"type\":\"Nutrition\",\"formula\":\"655.096+9.563*a+1.85*b-4.676*c\"},{\"name\":\"Male BMR\",\"variable\":[\"weight\",\"height\",\"age\"],\"type\":\"Nutrition\",\"formula\":\"10*a+6.25*b-5*c+5\"},{\"name\":\"Female BMR\",\"variable\":[\"weight\",\"height\",\"age\"],\"type\":\"Nutrition\",\"formula\":\"10*a+6.25*b-5*c-161\"},{\"name\":\"Total Energy Expenditure\",\"variable\":[\"BEE\",\"AF\",\"IF\"],\"type\":\"Nutrition\",\"formula\":\"a*b*c\"},{\"name\":\"Anion gap\",\"variable\":[\"Na\",\"Cl\",\"HCO3\"],\"type\":\"Nephro\",\"formula\":\"a-b+c\"},{\"name\":\"Corrected Anion gap\",\"variable\":[\"Anion gap\",\"alb\"],\"type\":\"Nephro\",\"formula\":\"a+0.25*(40-b)\"},{\"name\":\"Water Deficit\",\"variable\":[\"weight\",\"Current Na\"],\"type\":\"Nephro\",\"formula\":\"0.6*a*(b/139)\"},{\"name\":\"FW Deficit(Adult Female/Elderly Male)\",\"variable\":[\"weight\",\"Current Na\"],\"type\":\"Nephro\",\"formula\":\"0.5*a*(b/139)\"},{\"name\":\"FW Deficit(Elderly Female)\",\"variable\":[\"weight\",\"Current Na\"],\"type\":\"Nephro\",\"formula\":\"0.45*a*(b/139)\"},{\"name\":\"GFR Creatinine Clearance\",\"variable\":[\"age\",\"weight\",\"Cr\"],\"type\":\"Nephro\",\"formula\":\"(140-a)*b/(72*c)\"},{\"name\":\"GFR Creatinine Clearance (Female)\",\"variable\":[\"age\",\"weight\",\"Cr\"],\"type\":\"Nephro\",\"formula\":\"(140-a)*b*0.85/(72*c)\"},{\"name\":\"GFR MDRD\",\"variable\":[{\"name\":\"SerumCr\",\"unit\":\"Scr/k,1\"},{\"name\":\"Age\",\"unit\":\"year\"}],\"type\":\"Nephro\",\"formula\":\"186*(1/(a**(1.154)))*(1/(b**(0.203)))*0.742\"},{\"name\":\"GFR CKD-EPI Male\",\"variable\":[\"min\",\"max\",\"age\"],\"type\":\"Nephro\",\"formula\":\"141*(1/a*(0.411))*b-1.209*0.993*c\"},{\"name\":\"GFR CKD-EPI Female\",\"variable\":[\"min\",\"max\",\"age\"],\"type\":\"Nephro\",\"formula\":\"141*(1/a*(0.329))*b-1.209*0.993*c*1.018\"},{\"name\":\"Rate\",\"variable\":[\"IBW\",\"dosage\",\"drug dilution\"],\"type\":\"Drugdose\",\"formula\":\"0.06*a*b/c\"},{\"name\":\"Dosage\",\"variable\":[\"Rate\",\"drug dilution\",\"IBW\"],\"type\":\"Drugdose\",\"formula\":\"a*b/(0.06*c)\"},{\"name\":\"Predicted VT ARDSNET\",\"variable\":[\"target TV\",\"ideal BW\"],\"type\":\"Ventilator\",\"formula\":\"a*b\"},{\"name\":\"PF ratio\",\"variable\":[\"PaO2\",\"FiO2\"],\"type\":\"Ventilator\",\"formula\":\"a/b\"}]}"
            
            if let data = jsonString.data(using: String.Encoding.utf8) {
                let json = JSON(data: data)
                
                for item in json["allFormula"].arrayValue {
                    let formula = Formula()
                    formula.id = UUID().uuidString
                    formula.name = item["name"].stringValue
                    formula.type = item["type"].stringValue
                    formula.formula = item["formula"].stringValue
                    for parameter in item["variable"].arrayValue{
                        let realmString = RealmString()
                        realmString.text = parameter.stringValue
                        formula.variable.append(realmString)
                    }
                    formulaList.append(formula)
                }
            }
            
            let realm = try! Realm()
            
            try! realm.write {
                for formula in formulaList{
                    realm.add(formula)
                }
            }
        }
        
    }
    
    func isAppHasBeenLaunched() -> Bool{
        let defualts = UserDefaults.standard
        
        if defualts.string(forKey: "isAppHasBeenLaunched") != nil {
            return false
        }else{
            defualts.set(true, forKey: "isAppHasBeenLaunched")
            return true
        }
    }
}
