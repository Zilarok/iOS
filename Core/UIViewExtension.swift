//
//  UIViewExtension.swift
//  DuckDuckGo
//
//  Created by Mia Alexiou on 21/02/2017.
//  Copyright © 2017 DuckDuckGo. All rights reserved.
//

import Foundation

extension UIView {
    
    public func addEqualSizeConstraints(subView: UIView) {
        addEqualWidthConstraint(subView: subView)
        addEqualHeightConstraint(subView: subView)
    }
    
    public func addEqualHeightConstraint(subView: UIView) {
        addConstraint(NSLayoutConstraint(
            item: subView,
            attribute: .height, relatedBy: .equal, toItem: self,
            attribute: .height, multiplier: 1, constant: 0))
        
    }
    
    public func addEqualWidthConstraint(subView: UIView) {
        addConstraint(NSLayoutConstraint(
            item: subView,
            attribute: .width, relatedBy: .equal, toItem: self,
            attribute: .width, multiplier: 1, constant: 0))
    }
    
    public func round(corners: UIRectCorner, radius: CGFloat) {
        let cornerRadii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
    }
}
