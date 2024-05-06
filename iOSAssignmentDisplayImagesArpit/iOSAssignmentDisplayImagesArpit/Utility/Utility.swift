//
//  Utility.swift
//  iOSAssignmentDisplayImagesArpit
//
//  Created by Ravi Chokshi on 06/05/24.
//

import Foundation
import UIKit

class Utility {
    
    static func showAlert(title:String?, message:String?, buttons: [String] = ["Ok"],
                          buttonStyle:[UIAlertAction.Style] = [.default], completion:((_ index:Int) -> Void)? = nil) -> Void{
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for index in 0..<buttons.count {
            
            let action = UIAlertAction(title: buttons[index], style: buttonStyle[index]) {_ in
                completion?(index)
            }
            alertController.addAction(action)
        }
        
        DispatchQueue.main.async {
            appDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
}
