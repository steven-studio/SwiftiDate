//
//  UIView+Border.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/11.
//

import Foundation
import UIKit

extension UIView {
    func addBorder(_ edge: UIRectEdge, color: UIColor, thickness: CGFloat) -> UIView {
        let subview = UIView()
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.backgroundColor = color
        addSubview(subview)
        switch edge {
        case .top, .bottom:
            subview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            subview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            subview.heightAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .top {
                subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
            } else {
                subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            }
        case .left, .right:
            subview.topAnchor.constraint(equalTo: topAnchor).isActive = true
            subview.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
            subview.widthAnchor.constraint(equalToConstant: thickness).isActive = true
            if edge == .left {
                subview.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
            } else {
                subview.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
            }
        default:
            break
        }
        
        return subview
    }
}
