//
//  LogInViewController.swift
//  ShoppingCar
//
//  Created by TBCASoft-Bennett on 2022/7/1.
//

import UIKit
import FacebookLogin
import AuthenticationServices

class LogInViewController: UIViewController {
    
    @IBOutlet weak var facebookBtn: UIButton!
    @IBOutlet weak var signInWithAppleButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Apple Login
        
        let authorizationAppleIDButton: ASAuthorizationAppleIDButton = ASAuthorizationAppleIDButton()
        authorizationAppleIDButton.addTarget(self, action: #selector(pressSignInWithAppleButton), for: UIControl.Event.touchUpInside)
        
        authorizationAppleIDButton.frame = self.signInWithAppleButtonView.bounds
        self.signInWithAppleButtonView.addSubview(authorizationAppleIDButton)
        
        
        // Facebook Login
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
        
        
        // 檢查User 是否已使用 Apple 登入
//        checkCredentialStateWithApple(withUserID: <#T##String#>)
        // 監聽 Apple ID 是否有登入、登出的狀況
        self.observeAppleIDSessionChanges()
        
        
        // 檢查User 是否已使用 Facebook 登入
        checkCredentialStateWithFacebook()
        
        
    }
    
    
    /// 點擊 Sign In with Apple 按鈕後，請求授權
    @objc func pressSignInWithAppleButton() {
        let authorizationAppleIDRequest: ASAuthorizationAppleIDRequest = ASAuthorizationAppleIDProvider().createRequest()
        authorizationAppleIDRequest.requestedScopes = [.fullName, .email]
        
        let controller: ASAuthorizationController = ASAuthorizationController(authorizationRequests: [authorizationAppleIDRequest])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
    }
    
    /// 點擊facebook Login
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
    
    
    private func checkCredentialStateWithApple(withUserID userID: String) {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        appleIDProvider.getCredentialState(forUserID: userID) { (credentialState, error) in
            switch credentialState {
            case .authorized:
                print("用戶已登入")
                break
            case .revoked:
                print("用戶已登出")
                break
            case .notFound:
                print("無此用戶")
                break;
            default:
                break
            }
        }
    }
    
    private func checkCredentialStateWithFacebook(){
        if let _ = AccessToken.current {
            Profile.loadCurrentProfile { profile, error in
                if let profile = profile {
                    print(profile.name as? String)
                    print(profile.imageURL(forMode: .square, size: CGSize(width: 300, height: 300)))
                }
            }
        }
    }
    
}


// 遵從 ASAuthorizationControllerDelegate(實作登入成功、失敗的邏輯)
extension LogInViewController: ASAuthorizationControllerDelegate {
    /// 授權成功
    /// - Parameters:
    ///   - controller: _
    ///   - authorization: _
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            print("user: \(appleIDCredential.user)")
            print("fullName: \(String(describing: appleIDCredential.fullName))")
            print("Email: \(String(describing: appleIDCredential.email))")
            print("realUserStatus: \(String(describing: appleIDCredential.realUserStatus))")
        }
    }
    
    /// 授權失敗
    /// - Parameters:
    ///   - controller: _
    ///   - error: _
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        
        switch (error) {
        case ASAuthorizationError.canceled:
            break
        case ASAuthorizationError.failed:
            break
        case ASAuthorizationError.invalidResponse:
            break
        case ASAuthorizationError.notHandled:
            break
        case ASAuthorizationError.unknown:
            break
        default:
            break
        }
        
        print("didCompleteWithError: \(error.localizedDescription)")
    }
    
    // 監聽 Apple ID 是否有登入、登出的狀況
    private func observeAppleIDSessionChanges() {
        NotificationCenter.default.addObserver(forName: ASAuthorizationAppleIDProvider.credentialRevokedNotification, object: nil, queue: nil) { (notification: Notification) in
            // Sign user in or out
            print("Sign user in or out...")
      }
    }
    
}

// 遵從 ASAuthorizationControllerPresentationContextProviding(告知 ASAuthorizationController 該呈現在哪個 Window 上)
extension LogInViewController: ASAuthorizationControllerPresentationContextProviding {
        
    /// - Parameter controller: _
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
           return self.view.window!
    }
        
}
