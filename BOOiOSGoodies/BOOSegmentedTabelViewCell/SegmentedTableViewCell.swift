//
//  SegmentedTableViewCell.swift
//  FactorTrackerApp
//
//  Created by Tobias Boogh on 15/07/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

import UIKit

@objc protocol SegmentedTableViewCellDataSource{
    func numberOfSegmentsInCell(cell : SegmentedTableViewCell) -> Int
    func segmentedCell(cell : SegmentedTableViewCell, viewForIndex index : Int) -> UIView
}

class SegmentedTableViewCell: UITableViewCell {
    var datasource : SegmentedTableViewCellDataSource?
    var _numberOfSegments : Int = 0
    var scrollView : UIScrollView!
    var scrollViewContentView : UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let datasource = datasource{
            var segmentCount = datasource.numberOfSegmentsInCell(self)
            if segmentCount != self.contentView.subviews.count{
                for view in self.contentView.subviews{
                    view.removeFromSuperview()
                }
                var previousView : UIView?
                for index in 0..<segmentCount{
                    var view = UIView()
                    self.contentView.addSubview(view)
                    view.setTranslatesAutoresizingMaskIntoConstraints(false)
                    
                    var constraints : [NSLayoutConstraint] = []
                    var widthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0/CGFloat(segmentCount), constant: 0)
                    
                    constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: nil, metrics: nil, views: ["view" : view]) as [NSLayoutConstraint]
                    constraints.append(widthConstraint)
                    if let previousView = previousView{
                        constraints += NSLayoutConstraint.constraintsWithVisualFormat("[previousView][view]", options: nil, metrics: nil, views: ["view" : view, "previousView" : previousView] ) as [NSLayoutConstraint]
                    } else {
                        constraints += NSLayoutConstraint.constraintsWithVisualFormat("|[view]", options: nil, metrics: nil, views: ["view" : view]) as [NSLayoutConstraint]
                    }
                    
                    var userView = datasource.segmentedCell(self, viewForIndex: index)
                    view.addSubview(userView)
                    
                    self.addConstraints(constraints)
                    previousView = view
                }
            }
        }
    }
}
