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

class OptionTableViewCellButton : UIControl{
    var preferedWidth : CGFloat?
    var style : Style!
    var textLabel : UILabel?
    var imageView : UIImageView?
    
    enum Style{
        case Default
        case ImageOnly
        case TextOnly
        case Custom
    }
    
    init(style : Style){
        super.init(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
        self.style = style
        if (style != Style.Custom){
            createSubViews()
        }
    }
    
    func createSubViews(){
        var imageView : UIImageView?
        var label : UILabel?
        if (style == Style.Default || style == Style.ImageOnly){
            imageView = UIImageView()
            self.addSubview(imageView)
        }
        if (style == Style.Default || style == Style.TextOnly){
            label = UILabel()
            self.addSubview(label)
        }
        
        if let imageView = imageView{
            if let label = label{
                // Image & Label layout
                var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView][label]|", options: nil, metrics: nil, views: ["imageView" : imageView, "label": label]) as [NSLayoutConstraint]
                constraints += NSLayoutConstraint.constraintsWithVisualFormat("|[imageView]|", options: nil, metrics: nil, views: ["imageView" : imageView]) as [NSLayoutConstraint]
                constraints += NSLayoutConstraint.constraintsWithVisualFormat("|[label]|", options: nil, metrics: nil, views: ["label": label]) as [NSLayoutConstraint]
                self.addConstraints(constraints)
            } else {
                // Image only layout
                var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]|", options: nil, metrics: nil, views: ["imageView" : imageView]) as [NSLayoutConstraint]
                constraints += NSLayoutConstraint.constraintsWithVisualFormat("|[imageView]|", options: nil, metrics: nil, views: ["imageView" : imageView]) as [NSLayoutConstraint]
                self.addConstraints(constraints)
            }
        } else {
            if let label = label{
                // No image make label take up entire frame
                var constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[label]|", options: nil, metrics: nil, views: ["label" : label]) as [NSLayoutConstraint]
                constraints += NSLayoutConstraint.constraintsWithVisualFormat("|[label]|", options: nil, metrics: nil, views: ["label" : label]) as [NSLayoutConstraint]
                self.addConstraints(constraints)
            }
        }
        self.textLabel = label
        self.imageView = imageView
    }
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
    
    func setupButtons(buttonArray : [OptionTableViewCellButton], inView buttonView:UIView){
        for view in buttonView.subviews as [UIView]{
            view.removeFromSuperview()
        }
        
        var previousButton : OptionTableViewCellButton?
        var layoutConstraints : [NSLayoutConstraint] = []
        
        for i in 0..<buttonArray.count{
            let actionButton = buttonArray[i]
            actionButton.removeConstraints(actionButton.constraints())
            actionButton.setTranslatesAutoresizingMaskIntoConstraints(false)
            
            actionButton.addTarget(self, action: "buttonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            actionButton.tag = i
            buttonView.addSubview(actionButton)
            
            var fraction = CGFloat(1.0/Float(buttonArray.count))
            var widthConstraint = NSLayoutConstraint(item: actionButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: buttonView, attribute: NSLayoutAttribute.Width, multiplier:fraction , constant: 0)
            layoutConstraints.append(widthConstraint)
            
            if let prevButton = previousButton{
                var positionConstraint = NSLayoutConstraint(item: actionButton, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: previousButton, attribute: NSLayoutAttribute.Trailing, multiplier: 1.0, constant: 0)
                layoutConstraints.append(positionConstraint)
            }
            
            var heightConstraint = NSLayoutConstraint(item: actionButton, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: buttonView, attribute: NSLayoutAttribute.Height, multiplier:1.0, constant: 0)
            layoutConstraints.append(heightConstraint)
            
            previousButton = actionButton
        }
        buttonView.addConstraints(layoutConstraints)
    }
    
    func setRightButtons(let buttonArray: [OptionTableViewCellButton]){
        setupButtons(buttonArray, inView: self.rightButtonView)
        self.setNeedsLayout()
        self.setState(State.Closed, animated: true)
    }
    
    func setLeftButtons(let buttonArray : [OptionTableViewCellButton]){
        setupButtons(buttonArray, inView: self.leftButtonView)
        self.setNeedsLayout()
        self.setState(State.Closed, animated: true)
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
        self.rightButtonView.backgroundColor = UIColor.greenColor()
        
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
        
        self.scrollView.panGestureRecognizer.addObserver(self, forKeyPath: "state", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    deinit{
        self.tableView.panGestureRecognizer.removeObserver(self, forKeyPath: "state")
        self.scrollView.panGestureRecognizer.removeObserver(self, forKeyPath: "state")
    }
    
    override func observeValueForKeyPath(keyPath: String!, ofObject object: AnyObject!, change: [NSObject : AnyObject]!, context: UnsafePointer<()>) {
        if (keyPath == "state"){
            if (object as NSObject == self.tableView.panGestureRecognizer){
                if (self.tableView.panGestureRecognizer.state == UIGestureRecognizerState.Began){
                // Any panning in the tableView closes the scrollview
                    self.setState(State.Closed, animated: true)
                }
            } else if (object as NSObject == self.scrollView.panGestureRecognizer){
                // At currentzero and panning ended
                if (self.scrollView.panGestureRecognizer.state == .Ended && self.scrollView.contentOffset.x == currentZero){
                    self.setState(State.Closed, animated: false)
                    self.direction = .NotSet
                }
            }
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
        self.scrollView.contentView.frame.origin.x = self.leftButtonView.frame.size.width
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width + leftButtonView.frame.size.width, self.bounds.size.height)
        
        var scrollDirection = self.scrollView.panGestureRecognizer.translationInView(self.scrollView.superview).x
        self.scrollView.contentOffset.x = self.leftButtonView.frame.size.width - scrollDirection
    }
    
    func layoutRightButtons(){
        var rightButtonCount = rightButtonView.subviews.count
        var rightButtonFrame = self.rightButtonView.frame
        rightButtonFrame.size.width = CGFloat(80 * rightButtonCount)
        rightButtonFrame.origin.x = self.bounds.size.width - rightButtonFrame.size.width
        self.rightButtonView.frame = rightButtonFrame
        self.rightButtonView.updateConstraints()
        self.scrollView.contentView.frame.origin.x = 0
        self.scrollView.contentSize = CGSizeMake(self.bounds.size.width + rightButtonView.frame.size.width, self.bounds.size.height)
        
        var scrollDirection = self.scrollView.panGestureRecognizer.translationInView(self.scrollView.superview).x
        self.scrollView.contentOffset.x = 0
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
                break
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
        if (scrollView.contentOffset.x == currentZero){
            if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerState.Possible){

                self.scrollView.contentView.backgroundColor = UIColor.redColor()
                self.scrollView.contentView.frame.origin.x = 0
                
                // Setting contentsize triggers scrollViewDidScroll
                self.scrollView.contentSize = self.scrollView.frame.size
                self.scrollView.contentSize.width += 50
                currentZero = 0
                self.leftButtonView.hidden = true
                self.rightButtonView.hidden = true
                
                // Safe to set this here after scrollview change
                self.state = State.Closed
                direction = Direction.NotSet
            }
        } else if (direction == Direction.Left){
            if (scrollView.contentOffset.x == 0){
                self.state = State.OpenLeft
            } else if (scrollView.contentOffset.x >= self.leftButtonView.frame.size.width){
                setState(OptionTableViewCell.State.Closed, animated: false)
            }
        } else if (direction == Direction.Right){
            if (scrollView.contentOffset.x == self.rightButtonView.frame.size.width){
                self.state = State.OpenRight
            } else if (scrollView.contentOffset.x <= 0){
                setState(OptionTableViewCell.State.Closed, animated: false)
            }
        }
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
