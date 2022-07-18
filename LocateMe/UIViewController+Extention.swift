//
//  UIViewController+Extention.swift
//  LocateMe
//
//  Created by Omar Ahmed on 18/07/2022.
//

import UIKit

extension UIViewController{
    
    func showAlert(messege: String){
        let alert = UIAlertController(title: "Alert", message: messege, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func settingsAlert(){
        let alert = UIAlertController(title: "Enable Location",
                                      message: "Please Enable Location Service",
                                      preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Settings",
                                      style: UIAlertAction.Style.default,
                                      handler: openSettings))
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: UIAlertAction.Style.default,
                                      handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func openSettings(alert: UIAlertAction!) {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
    }
}
