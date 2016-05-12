//
//  UIView+Loading.swift
//  Kindio
//
//  Created by Alin Petrus on 5/11/16.
//  Copyright © 2016 Alin Petrus. All rights reserved.
//

import UIKit

enum SpinnerPosition: Int {
    case TopLeft = 0
    case TopCenter
    case TopRight
    case MiddleLeft
    case Center
    case MiddleRight
    case BottomLeft
    case BottomCenter
    case BottomRight
}

extension UIView {
    func showActivityIndicatorWithColor(color: UIColor, spinnerStyle style: UIActivityIndicatorViewStyle, spinnerPosition position: SpinnerPosition) {
        var spinnerIsShowing = false
        
        for subview in self.subviews  {
            if subview.tag == 1337 {
                spinnerIsShowing = true
                break
            }
        }
        
        if (spinnerIsShowing == false) {
            let activityIndicator = UIActivityIndicatorView.init(activityIndicatorStyle: style)
            activityIndicator.color = color
            activityIndicator.tag = 1337
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(activityIndicator)
            
            self.setupHorizontalConstraintsForIndicator(activityIndicator, position: position)
            self.setupVerticalConstraintsForIndicator(activityIndicator, position: position)
            
            self.bringSubviewToFront(activityIndicator)
            activityIndicator.startAnimating()
        }
    }
    
    func hideActivityIndicator() {
        for subview in self.subviews  {
            if subview.tag == 1337 {
                subview.removeFromSuperview()
                break
            }
        }
    }
    
    // MARK: private
    
    private func setupHorizontalConstraintsForIndicator(activityIndicator: UIActivityIndicatorView, position: SpinnerPosition) {
        if (position == .Center || position == .TopCenter || position == .BottomCenter) {
            let constraint = NSLayoutConstraint.init(item: activityIndicator, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1.0, constant: 0.0)
            
            self.addConstraint(constraint)
        } else if (position == .TopRight || position == .MiddleRight || position == .BottomRight) {
            let constraint = NSLayoutConstraint.init(item: activityIndicator, attribute: .Trailing, relatedBy: .Equal, toItem: self, attribute: .Trailing, multiplier: 1.0, constant: 0.0)
            
            self.addConstraint(constraint)
        }
    }
    
    private func setupVerticalConstraintsForIndicator(activityIndicator: UIActivityIndicatorView, position: SpinnerPosition) {
        if (position == .BottomLeft || position == .BottomCenter || position == .BottomRight) {
            let constraint = NSLayoutConstraint.init(item: activityIndicator, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: 0.0)
            
            self.addConstraint(constraint)
        } else if (position == .MiddleLeft || position == .Center || position == .MiddleRight) {
            let constraint = NSLayoutConstraint.init(item: activityIndicator, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0)
            
            self.addConstraint(constraint)
        }
    }
}