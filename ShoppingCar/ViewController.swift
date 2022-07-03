//
//  ViewController.swift
//  ShoppingCar
//
//  Created by TBCASoft-Bennett on 2022/6/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let token = AccessToken.current,
           !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        
        
        // 使用「Facebook 登入」時，您的應用程式可以要求提供有關個人資料子集的權限。
        //「Facebook 登入」需要進階 public_profile 權限，才能由外部用戶使用。
        loginButton.permissions = ["public_profile", "email"]
    }


}

