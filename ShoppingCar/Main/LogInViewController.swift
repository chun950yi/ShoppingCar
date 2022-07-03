//
//  LogInViewController.swift
//  ShoppingCar
//
//  Created by TBCASoft-Bennett on 2022/7/1.
//

import UIKit
import FacebookLogin

class LogInViewController: UIViewController {
    
    @IBOutlet weak var facebookBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let accessToken = AccessToken.current,
           !accessToken.isExpired {
            print("\(accessToken.userID) login")
            
            let request = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name"])
            request.start { response, result, error in
                if let result = result as? [String:String] {
                    print(result)
                }
            }
        } else {
            print("not login")
        }
        
        
        if let _ = AccessToken.current {
            Profile.loadCurrentProfile { profile, error in
                if let profile = profile {
                    print(profile.name)
                    print(profile.imageURL(forMode: .square, size: CGSize(width: 300, height: 300)))
                }
            }
        }
        // 使用「Facebook 登入」時，您的應用程式可以要求提供有關個人資料子集的權限。
        //「Facebook 登入」需要進階 public_profile 權限，才能由外部用戶使用。
        //        facebookBtn.permissions = ["public_profile", "email"]
        
    }
    
    @IBAction func facebookLogIn(_ sender: Any) {
        let manager = LoginManager()
        manager.logIn(permissions: [.publicProfile, .email]) { result in
            switch result {
            case .success(granted: let granted, declined: let declined, token: let token):
                print("success")
            case .cancelled:
                print("cancelled")
            case .failed(_):
                print("failed")
            }
        }
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
