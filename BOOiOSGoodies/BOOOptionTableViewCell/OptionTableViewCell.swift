//
//  OptionTableViewCell.swift
//  TestApp
//
//  Created by Tobias Boogh on 01/07/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

import UIKit

@objc protocol OptionTableViewCellDelegate{
    @optional func optionTableViewCell(cell: UITableViewCell!, didSelectButtonAt index : Int)
}

struct OptionTableViewCellButton{
    var textColor : UIColor
    var backgroundColor : UIColor
    var width : CGFloat
    var text : String
}

class OptionTableViewCell: UITableViewCell, UIScrollViewDelegate{
    var scrollView : OptionTableViewCellScrollView!
    var label : UILabel!
    var leftButtonView : UIView!
    var rightButtonView : UIView!
    var delegate : OptionTableViewCellDelegate? = nil
    var tableView  : UITableView!
    var state : State = State.Closed
    var direction = Direction.NotSet
    var currentZero : CGFloat = 0.0
    
    enum Direction: Printable{
        case NotSet
        case Left
        case Right
        
        var description: String { get{
            switch(self){
            case .NotSet:
                return "NotSet"
            case .Left:
                return "Left"
            case .Right:
                return "Right"
            }
        }
        }
    }
    
    enum State: Printable{
        case Closed
        case OpenLeft
        case OpenRight
        
        var description: String { get{
            switch(self){
                case Closed:
                    return "Closed"
                case OpenLeft:
                    return "OpenLeft"
                case OpenRight:
                    return "OpenRight"
                }
            }
        }
    }
    
    func setRightButtons(let buttonArray: [OptionTableViewCellButton]){
        for view in self.rightButtonView.subviews as [UIView]{
            view.removeFromSuperview()
        }
        
        var totalButtonWidth = CGFloat(0.0)
        
        for (var i=0; i < buttonArray.count; ++i){
            let actionButton = buttonArray[i]
            var buttonRect = CGRectMake(0, 0, actionButton.width, self.rightButtonView.bounds.size.height)
            buttonRect.origin.x = buttonRect.size.width * CGFloat(i)
            
            var button = UIButton(frame: buttonRect)
            button.setTitle(actionButton.text, forState: UIControlState.Normal)
            button.backgroundColor = actionButton.backgroundColor
            button.setTitleColor(actionButton.textColor, forState: UIControlState.Normal)
            
            button.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            button.tag = i
            self.rightButtonView.addSubview(button)
            
            totalButtonWidth += actionButton.width
        }
        
        rightButtonView.frame.size.width = totalButtonWidth
        self.setNeedsLayout()
        self.setState(State.Closed, animated: true)
    }
    
    func setLeftButtons(let buttonArray : [OptionTableViewCellButton]){
        
    }
    
    override var contentView : UIView!{
        get{
            if let scrollView = scrollView{
                return scrollView.contentView
            } else {
                return super.contentView
            }
        }
    }
    
    // Mark : Cell initialization
    init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    };
    
    override func willMoveToSuperview(newSuperview: UIView!) {
        var superView = newSuperview
        while superView != nil{
            if let tableView = superView as? UITableView{
                self.tableView = tableView
                self.tableView.panGestureRecognizer.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.New, context: nil)
                break
            }
            superView = superView.superview
        }
    }
    
    func commonInit(){
        self.selectionStyle = UITableViewCellSelectionStyle.None
        
        let cellResizingMask = UIViewAutoresizing.FlexibleHeight
        // The buttonView
        var leftButtonFrame = self.bounds
        leftButtonFrame.size.width = 100
        leftButtonFrame.origin.x = 0
        var leftButtonView = UIView(frame: leftButtonFrame)
        leftButtonView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleRightMargin
        self.contentView.addSubview(leftButtonView)
        self.leftButtonView = leftButtonView
        self.leftButtonView.backgroundColor = UIColor.greenColor()
        
        var rigthButtonFrame = self.bounds;
        rigthButtonFrame.size.width = 100
        rigthButtonFrame.origin.x = self.bounds.size.width - rigthButtonFrame.size.width
        var buttonView = UIView(frame: rigthButtonFrame)
        buttonView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleLeftMargin
        self.contentView.addSubview(buttonView)
        self.rightButtonView = buttonView
        
        // The scrollview overlay
        var scrollViewRect = self.bounds;
        var scrollView = OptionTableViewCellScrollView(frame: scrollViewRect);
        scrollView.autoresizingMask = cellResizingMask
        scrollView.contentSize = CGSizeMake(self.bounds.size.width + rigthButtonFrame.size.width + leftButtonView.frame.size.width, self.bounds.size.height)
        scrollView.delegate = self
        self.addGestureRecognizer(scrollView.panGestureRecognizer)
        self.contentView.addSubview(scrollView)
        
        var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTap:");
        tapGestureRecognizer.numberOfTapsRequired = 1
        scrollView.contentView.addGestureRecognizer(tapGestureRecognizer)

        self.leftButtonView.hidden = true
        self.rightButtonView.hidden = true
        
        self.scrollView = scrollView;
    }
    
    deinit{
        self.tableView.panGestureRecognizer.removeObserver(self, forKeyPath: "state")
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>) {
        if (keyPath == "state" && object as NSObject == self.tableView.panGestureRecognizer){
            // Any panning in the tableView closes the scrollview
            self.setState(State.Closed, animated: true)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame.size = self.frame.size
        if (self.state == State.OpenLeft){
            layoutLeftButtons()
        } else if (self.state == State.OpenRight){
            layoutRightButtons()
        } else {
            self.scrollView.contentSize = self.scrollView.frame.size
            self.scrollView.contentSize.width += 50
        }
        self.setState(self.state, animated: true)
    }
    
    func layoutLeftButtons(){
        var contentFrame = self.bounds
        contentFrame.origin.x = self.leftButtonView.frame.size.width
        self.scrollView.contentView.frame = contentFrame
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width + leftButtonView.frame.size.width, self.bounds.size.height)
        var contentOffset = self.scrollView.contentOffset
        var scrollDirection = self.scrollView.panGestureRecognizer.translationInView(self.scrollView.superview).x
        contentOffset.x = self.leftButtonView.frame.size.width - scrollDirection
        self.scrollView.contentOffset = contentOffset
    }
    
    func layoutRightButtons(){
        var contentFrame = self.bounds
        contentFrame.origin.x = 0
        var rightButtonFrame = self.rightButtonView.frame
        rightButtonFrame.origin.x = contentFrame.size.width - rightButtonFrame.size.width
        self.rightButtonView.frame = rightButtonFrame
        self.scrollView.contentView.frame = contentFrame
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width + rightButtonView.frame.size.width, self.bounds.size.height)
    }
    
    // Mark : Method overrides
    override func hitTest(point: CGPoint, withEvent event: UIEvent!) -> UIView! {
        let hitView = super.hitTest(point, withEvent: event)
        if (hitView){
            // Hit detected and no options displaying, act like a regular cell
            if (self.scrollView.contentOffset.x == 0){
                return self;
            }
        } else {
            if (self.scrollView.contentOffset.x != 0){
                self.setState(State.Closed, animated: true)
            }
        }
        return hitView
    }
    
    override func prepareForReuse() {
        self.setState(State.Closed, animated: false)
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        if (selected){
            self.setState(State.Closed, animated: true)
            self.scrollView.contentView.backgroundColor = UIColor(white: 0.8, alpha: 1.0)
        } else {
            if (!self.scrollView.dragging){
                self.setState(State.Closed, animated: true)
            }
            self.scrollView.contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
    // Mark : Public methods
    func setState(state : State, animated : Bool){
        prepareState(state)
        switch (state){
            case .Closed:
                NSLog("%@ %@ %f", __FUNCTION__, state.description, currentZero)
                self.scrollView.setContentOffset(CGPoint(x: currentZero, y:0.0), animated: animated)
            case .OpenRight:
                self.scrollView.setContentOffset(CGPoint(x: self.rightButtonView.frame.size.width, y: 0), animated: animated)
            case .OpenLeft:
                self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
            
        }
    }
    
    func prepareState(state : State){
        switch (state){
            case .Closed:
//                direction = Direction.NotSet
                var x = 0
            case .OpenLeft:
                direction = Direction.Left
                self.layoutLeftButtons()
                leftButtonView.hidden = false
                rightButtonView.hidden = true
                currentZero = self.leftButtonView.frame.size.width
            case .OpenRight:
                direction = Direction.Right
                self.layoutRightButtons()
                rightButtonView.hidden = false
                leftButtonView.hidden = true
                currentZero = 0
        }
    }
    
    // Mark : Private methods
    
    func buttonPressed(sender: UIButton){
        delegate?.optionTableViewCell?(self, didSelectButtonAt: sender.tag)
    }
    
    func isView(var view: UIView, childOf parent: UIView) -> Bool{
        if (view.superview != nil){
            if (view.superview == parent){
                return true;
            }
            return isView(view.superview, childOf: parent)
        }
        return false;
    }
    
    func didTap(gestureRecognizer : UIGestureRecognizer){
        self.setState(State.Closed, animated: true)
    }
    
    // Mark : - UIScrollViewDelegate
    func scrollViewDidScroll(scrollView: UIScrollView!){
        NSLog("%@ %@ %@", __FUNCTION__, state.description, direction.description)
        if (direction == Direction.NotSet){
            var scrollDirection = self.scrollView.panGestureRecognizer.translationInView(self.scrollView.superview).x
            if (scrollDirection > 0.0){
                self.prepareState(State.OpenLeft)
                direction = Direction.Left
            } else {
               self.prepareState(State.OpenRight)
                direction = Direction.Right
            }
        }
        var contentOffset = scrollView.contentOffset
        if (scrollView.contentOffset.x == currentZero){
            self.state = State.Closed
            direction = Direction.NotSet
        } else if (scrollView.contentOffset.x == 0 && direction == Direction.Left){
            self.state = State.OpenLeft
        } else if (scrollView.contentOffset.x == self.rightButtonView.frame.size.width && direction == Direction.Right){
            self.state = State.OpenRight
        }
        scrollView.contentOffset = contentOffset
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        for visibleCell in self.tableView.visibleCells(){
            if let visibleCell = visibleCell as? OptionTableViewCell{
                if (visibleCell != self){
                    visibleCell.setState(State.Closed, animated: true)
                }
            }
        }
        self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow(), animated: true)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView!, withVelocity velocity: CGPoint, targetContentOffset: UnsafePointer<CGPoint>){
        let contentOffset = UnsafePointer<CGPoint>(targetContentOffset).memory
        let velocityThreshold : CGFloat = 0.2
        if (abs(velocity.x) < velocityThreshold){
            if (self.direction == .Right){
                if (contentOffset.x > self.rightButtonView.bounds.size.width * 0.5){
                    UnsafePointer<CGPoint>(targetContentOffset).memory.x = self.rightButtonView.bounds.size.width
                } else {
                    UnsafePointer<CGPoint>(targetContentOffset).memory.x = 0
                }
            } else if (self.direction == .Left){
                if (contentOffset.x < self.leftButtonView.bounds.size.width * 0.5){
                    UnsafePointer<CGPoint>(targetContentOffset).memory.x = 0
                } else {
                    UnsafePointer<CGPoint>(targetContentOffset).memory.x = self.leftButtonView.bounds.size.width
                }
            }
        }
    }
}

class OptionTableViewCellScrollView : UIScrollView{
    var contentView : UIView!
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    func commonInit(){
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        
        var contentView = UIView(frame: self.bounds)
        contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
        contentView.userInteractionEnabled = false
        self.addSubview(contentView)
        self.contentView = contentView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.frame.size = self.bounds.size
    }
}
