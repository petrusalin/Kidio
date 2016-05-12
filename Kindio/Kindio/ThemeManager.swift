//
//  ThemeManager.swift
//  Kindio
//
//  Created by Alin Petrus on 5/9/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

private let sharedThemeManager = ThemeManager()

class ThemeManager: NSObject {
    var standardColor : UIColor!
    var activeColor : UIColor!
    var barTintColor : UIColor!
    var window : UIWindow?
    
    private override init() {
        super.init()
        
        self.config()
    }
    
    class var sharedInstance: ThemeManager {
        return sharedThemeManager
    }
    
    private func config() {
        self.standardColor = UIColor.redLust()
        self.activeColor = UIColor.robinEggBlue()
        self.barTintColor = UIColor.mantis()
    }
    
    func applyTheme() {
        if let appWindow = self.window {
            appWindow.tintColor = self.standardColor
        }
        
        UIButton.appearance().tintColor = self.standardColor
        UINavigationBar.appearance().barTintColor = self.barTintColor
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UITabBar.appearance().barTintColor = self.barTintColor
    }
}
