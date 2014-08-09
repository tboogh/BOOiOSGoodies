//
//  BOOOptionTableViewCell.swift
//  BOOiOSGoodies
//
//  Created by Tobias Boogh on 21/07/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

import UIKit

protocol BOOOptionTableViewCellScrollViewDelegate{
    func touchEnded(scrollView : BOOOptionTableViewCellScrollView)
    func shouldHitTestReturnContentView(scrollView : BOOOptionTableViewCellScrollView) -> Bool
}

internal class BOOOptionTableViewCellScrollView : UIScrollView{
    var contentView : UIView!
    var optionDelegate : BOOOptionTableViewCellScrollViewDelegate?
    
    override init() {
        super.init()
        commonInit()
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func touchesEnded(touches: NSSet!, withEvent event: UIEvent!) {
        NSLog("\(__FUNCTION__)")
        if let optionDelegate = optionDelegate{
            optionDelegate.touchEnded(self)
        }
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
        var result = super.hitTest(point, withEvent: event)
//        
//        if result == self.contentView{
//            if let optionDelegate = optionDelegate{
//                if !optionDelegate.shouldHitTestReturnContentView(self){
//                    NSLog("self")
//                    return self
//                } else {
//                    NSLog("result")
//                    return result
//                }
//            }
//        }
//        NSLog("nil")
        return result
    }
    
    
    override func setContentOffset(contentOffset: CGPoint, animated: Bool) {
        super.setContentOffset(contentOffset, animated: animated)
    }
    func commonInit(){
        var contentView = UIView()
        self.addSubview(contentView)
        contentView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView = contentView
        self.contentView.backgroundColor = UIColor.whiteColor()
        self.setNeedsLayout()
        self.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.showsHorizontalScrollIndicator = false
        self.delaysContentTouches = false
    }
}

class BOOOptionTableViewCell: UITableViewCell, UIScrollViewDelegate, BOOOptionTableViewCellScrollViewDelegate{
    enum State : Printable{
        case Closed
        case LeftOpen
        case RightOpen
        
        var description: String { get{
            switch(self){
                case .Closed:
                    return "Closed"
                case .LeftOpen:
                    return "LeftOpen"
                case .RightOpen:
                    return "RightOpen"
                }
            }
        }
    }
    
    //MARK: - Property decleration
    var scrollView : BOOOptionTableViewCellScrollView!
    private var leftButtonView : UIView!
    private var rightButtonView : UIView!
    private var leftButtonViewWidthConstraint : NSLayoutConstraint!
    private var rightButtonViewWidthConstraint : NSLayoutConstraint!
    private var leftContentViewPositionConstraint : NSLayoutConstraint!
    private var rightContentViewPositionConstraint : NSLayoutConstraint!
    private var tableView : UITableView!
    
    private var testLabel : UILabel!
    
    private var state : State = .Closed{
        didSet{
            switch(state){
                case .Closed:
                    self.leftButtonView.hidden = true
                    self.rightButtonView.hidden = true
                case .LeftOpen:
                    self.leftButtonView.hidden = false
                    self.rightButtonView.hidden = true
                case .RightOpen:
                    self.leftButtonView.hidden = true
                    self.rightButtonView.hidden = false
            }
            self.testLabel.text = state.description
        }
    }
    
    //MARK: - Initialization
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.commonInit()
    }
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    deinit{
        self.tableView.panGestureRecognizer.removeObserver(self, forKeyPath: "state")
    }
    
    /// Create buttons
    func createButtonView() -> (UIView, NSLayoutConstraint){
        var buttonView = UIView()
        buttonView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.contentView.addSubview(buttonView)
        
        self.contentView.addConstraint(NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0.0))
        
        var buttonViewWidthConstraint = NSLayoutConstraint(item: buttonView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1.0, constant: 300)
        buttonView.addConstraint(buttonViewWidthConstraint)
        return (buttonView, buttonViewWidthConstraint)
    }
    
    private func commonInit(){
        // Button views
        var (leftButtonView, leftButtonViewWidthConstraint) = createButtonView()
        var (rightButtonView, rightButtonViewWidthConstraint) = createButtonView()
        
        self.leftButtonView = leftButtonView
        self.rightButtonView = rightButtonView
        leftButtonView.backgroundColor = UIColor.redColor()
        rightButtonView.backgroundColor = UIColor.greenColor()
        
        self.contentView.addConstraint(NSLayoutConstraint(item: leftButtonView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: leftButtonView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: rightButtonView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0))
        self.contentView.addConstraint(NSLayoutConstraint(item: rightButtonView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        self.leftButtonViewWidthConstraint = leftButtonViewWidthConstraint
        self.rightButtonViewWidthConstraint = rightButtonViewWidthConstraint
        
        self.leftButtonView.hidden = true
        self.rightButtonView.hidden = true
        
        // ScrollView
        var scrollView = BOOOptionTableViewCellScrollView()
        scrollView.delegate = self
        scrollView.optionDelegate = self
        self.contentView.addSubview(scrollView)
        
        var scrollViewConstraints : [NSLayoutConstraint] = []
        var leftConstraint = NSLayoutConstraint(item: scrollView.contentView, attribute: NSLayoutAttribute.Left, relatedBy: NSLayoutRelation.Equal, toItem: scrollView, attribute: NSLayoutAttribute.Left, multiplier: 1.0, constant: 0)
        scrollViewConstraints.append(leftConstraint)
        self.leftContentViewPositionConstraint = leftConstraint
        
        var rightConstraint = NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.Right, relatedBy: NSLayoutRelation.Equal, toItem: scrollView.contentView, attribute: NSLayoutAttribute.Right, multiplier: 1.0, constant: 0)
        scrollViewConstraints.append(rightConstraint);
        self.rightContentViewPositionConstraint = rightConstraint
        
        scrollViewConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[contentView]|", options: nil, metrics: nil, views: ["contentView" : scrollView.contentView]) as [NSLayoutConstraint]
        scrollView.addConstraints(scrollViewConstraints)
        
        var constraints : [NSLayoutConstraint] = []
        // set the scrollview's contentview to have the same size as the cell
        constraints.append(NSLayoutConstraint(item: scrollView.contentView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: scrollView.contentView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        
        // Constraints to position the scrollview in the cell contentview
        constraints.append(NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Height, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1.0, constant: 0))
        constraints.append(NSLayoutConstraint(item: scrollView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterY, multiplier: 1.0, constant: 0))
        
        self.addConstraints(constraints)
        
        self.scrollView = scrollView
        
        self.leftButtonViewWidthConstraint.constant = 100
        self.leftContentViewPositionConstraint.constant = self.leftButtonViewWidthConstraint.constant
        self.leftButtonView.hidden = false
        
        self.rightButtonViewWidthConstraint.constant = 100
        self.rightContentViewPositionConstraint.constant = self.rightButtonViewWidthConstraint.constant
        self.rightButtonView.hidden = false
        
        var leftbutton = UIButton(frame: CGRectMake(0, 0, 100, 44))
        leftbutton.setTitle("Left button", forState: UIControlState.Normal)
        leftbutton.addTarget(self, action: Selector("testFunc:"), forControlEvents: UIControlEvents.TouchUpInside)
        leftButtonView.addSubview(leftbutton)
        
        var rightButton = UIButton(frame: CGRectMake(0, 0, 100, 44))
        rightButton.setTitle("Right button", forState: UIControlState.Normal)
        rightButton.addTarget(self, action: Selector("testFunc:"), forControlEvents: UIControlEvents.TouchUpInside)
        rightButtonView.addSubview(rightButton)
        self.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        var label = UILabel(frame: self.bounds)
        label.text = "New Cell"
        self.scrollView.contentView.addSubview(label)
        self.testLabel = label
        
        self.scrollView.contentSize = CGSize(width: self.bounds.size.width + leftButtonViewWidthConstraint.constant + rightButtonViewWidthConstraint.constant, height: self.bounds.size.height)
        
        self.scrollView.setContentOffset(CGPoint(x: self.leftButtonViewWidthConstraint.constant, y: 0), animated: false)
    }
    
    func testFunc(sender : UIButton){
        self.testLabel.text = sender.titleForState(UIControlState.Normal)
        NSLog("Hello, World! \(sender.titleForState(UIControlState.Normal))")
    }
    
    //MARK: - Method overrides
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        closeOtherCells(animated)
    }
    
    override func prepareForReuse() {
        scrollView.setContentOffset(CGPoint(x: leftButtonViewWidthConstraint.constant, y: 0), animated: false)
    }
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
        var result = super.hitTest(point, withEvent: event)
        if result == scrollView.contentView{
            return contentView
        }
        return result
    }
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        super.willMoveToSuperview(newSuperview)
        
        var superView = newSuperview
        while (superView != nil){
            if (superView.isKindOfClass(UITableView.self)){
                break
            }
            superView = superView.superview
        }
        if (superView != nil){
            self.tableView = superView as UITableView
            self.tableView.panGestureRecognizer.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.New, context: nil)
        }
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setState(.Closed, animated: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.setState(self.state, animated: false)
    }
    
    //MARK: - UIScrollViewDelegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        closeOtherCells(true)
        self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow(), animated: false)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView!, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        switch (state){
            case .LeftOpen:
                if (targetContentOffset.memory.x < leftButtonViewWidthConstraint.constant * 0.5){
                    targetContentOffset.memory.x = 0
                } else if (targetContentOffset.memory.x > leftButtonViewWidthConstraint.constant * 0.5) {
                    targetContentOffset.memory.x = leftButtonViewWidthConstraint.constant
                }
            case .RightOpen:
                if (targetContentOffset.memory.x < leftButtonViewWidthConstraint.constant + (rightButtonViewWidthConstraint.constant * 0.5)){
                    targetContentOffset.memory.x = leftButtonViewWidthConstraint.constant
                } else if (targetContentOffset.memory.x > leftButtonViewWidthConstraint.constant + (rightButtonViewWidthConstraint.constant * 0.5)) {
                    targetContentOffset.memory.x = (leftButtonViewWidthConstraint.constant + rightButtonViewWidthConstraint.constant)
                }
                break
            case .Closed:
                break
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!, willDecelerate decelerate: Bool) {
        switch (state){
        case .LeftOpen, .RightOpen:
            if (scrollView.contentOffset.x == leftButtonViewWidthConstraint.constant){
                state = State.Closed
            }
        case .Closed:
            break
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
        if (state == .Closed && scrollView.tracking){
            if (scrollView.contentOffset.x < leftButtonViewWidthConstraint.constant){
                state = .LeftOpen
            } else if (scrollView.contentOffset.x > leftButtonViewWidthConstraint.constant){
                state = .RightOpen
            }
        } else if (state == .LeftOpen && scrollView.tracking){
            if (scrollView.contentOffset.x >= leftButtonViewWidthConstraint.constant){
                scrollView.contentOffset.x = leftButtonViewWidthConstraint.constant
            }
        } else if (state == .RightOpen && scrollView.tracking){
            if (scrollView.contentOffset.x <= leftButtonViewWidthConstraint.constant ){
                scrollView.contentOffset.x = leftButtonViewWidthConstraint.constant
            }
        }
        if (scrollView.contentOffset.x == self.leftButtonViewWidthConstraint.constant && !scrollView.tracking){
            state = .Closed
        }
    }
    
    //MARK: - BOOOptionTableViewCellScrollViewDelegate
    func shouldHitTestReturnContentView(scrollView: BOOOptionTableViewCellScrollView) -> Bool {
        if (scrollView.contentOffset.x != self.leftButtonViewWidthConstraint.constant){
            return false
        }
        return true
    }
    
    func touchEnded(scrollView: BOOOptionTableViewCellScrollView) {
        scrollView.setContentOffset(CGPoint(x: self.leftButtonViewWidthConstraint.constant, y: 0.0), animated: true)
    }
    
    //MARK: - KVO
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafeMutablePointer<()>) {
        if (keyPath == "state"){
            if (object as NSObject == self.tableView.panGestureRecognizer){
                if (self.tableView.panGestureRecognizer.state == UIGestureRecognizerState.Began){
                    // Any panning in the tableView closes the scrollview
                    scrollView.setContentOffset(CGPoint(x: leftButtonViewWidthConstraint.constant, y: 0), animated: true)
                }
            }
        }
    }
    
    //MARK: - Private methods
    func closeOtherCells(animated : Bool){
        for visibleCell in self.tableView.visibleCells(){
            if let visibleCell = visibleCell as? BOOOptionTableViewCell{
                if (visibleCell != self){
                    visibleCell.scrollView.setContentOffset(CGPoint(x: leftButtonViewWidthConstraint.constant, y: 0), animated: animated)
                }
            }
        }
    }
    
    //MARK: - Public methods
    func setState(state : State, animated : Bool){
        self.state = state
        switch(state){
            case .Closed:
                self.scrollView.setContentOffset(CGPoint(x: self.leftButtonViewWidthConstraint.constant, y: 0), animated: animated)
            case .LeftOpen:
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
            case .RightOpen:
                self.scrollView.setContentOffset(CGPoint(x: self.leftButtonViewWidthConstraint.constant + self.rightButtonViewWidthConstraint.constant, y: 0), animated: animated)
        }
    }
}
