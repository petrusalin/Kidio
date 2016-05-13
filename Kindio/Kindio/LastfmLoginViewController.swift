//
//  LastfmLoginViewController.swift
//  Kindio
//
//  Created by Alin Petrus on 5/10/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit
import APLfm
import CryptoSwift

class LastfmLoginViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Last.fm"
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        
        let attributes : [String:AnyObject]  = [NSForegroundColorAttributeName: UIColor.whiteColor(), NSFontAttributeName: UIFont.init(name: "Helvetica-BoldOblique", size: 12.0)!]
        self.usernameTextField.attributedPlaceholder = NSAttributedString.init(string: "username", attributes: attributes)
        self.passwordTextField.attributedPlaceholder = NSAttributedString.init(string: "password", attributes: attributes)
        self.passwordTextField.secureTextEntry = true
        UITextField.appearance().tintColor = UIColor.mantis()
        
        if LastfmManager.sharedInstance.isLoggedIn() {
            self.setupForLogout()
        } else {
            self.setupForLogin()
        }
    }
    
    // MARK: actions
    
    @IBAction func onLogin(sender: AnyObject) {
        if LastfmManager.sharedInstance.isLoggedIn() {
            self.performLogout()
        } else {
            self.performLogin()
        }
    }
    
    // MARK: textfied delegate
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if LastfmManager.sharedInstance.isLoggedIn() {
            return false
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.usernameTextField {
            self.passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
            self.onLogin(self.loginButton)
        }
        
        return true
    }
    
    // Mark private
    
    func setupForLogin() {
        self.loginButton.setTitle("Login", forState: .Normal)
        self.passwordTextField.hidden = false
        self.usernameTextField.text = ""
    }
    
    func setupForLogout() {
        self.loginButton.setTitle("Logout", forState: .Normal)
        self.passwordTextField.hidden = true
        self.usernameTextField.text = LastfmManager.sharedInstance.loggedInUsername()
    }
    
    func performLogout() {
        LastfmManager.sharedInstance.logout()
        self.setupForLogin()
    }
    
    func performLogin() {
        self.view.userInteractionEnabled = false
        
        if let username = self.usernameTextField.text, password = self.passwordTextField.text {
            self.view.showActivityIndicatorWithColor(UIColor.mantis(), spinnerStyle: .WhiteLarge, spinnerPosition: .Center)
            LastfmManager.sharedInstance.loginWithUsername(username, password: password, completion: { (error) in
                self.view.userInteractionEnabled = true
                self.view.hideActivityIndicator()
                self.setupForLogout()
            })
        }
    }
}
