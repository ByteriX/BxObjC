//
//  UIViewController.swift
//  iBXTest
//
//  Created by Sergey Balalaev on 12/04/2019.
//  Copyright © 2019 ByteriX. All rights reserved.
//

import UIKit

@objc
extension UIViewController {
    
    func tablePositionLayout(_ tableView: UITableView, topMagrin: CGFloat) {
        let topY = self.topExtendedEdges() + topMagrin
        let bottomY = self.bottomExtendedEdges()
        
        let contentOffsetY = tableView.contentOffset.y - (topY - tableView.contentInset.top)
        
        tableView.contentInset = UIEdgeInsets(top: topY, left: 0, bottom: bottomY, right: 0)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: topY, left: 0, bottom: bottomY, right: 0)
        tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: contentOffsetY), animated: false)
    }
    
}
