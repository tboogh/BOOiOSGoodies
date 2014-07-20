//
//  ViewController.swift
//  ViewTests
//
//  Created by Tobias Boogh on 15/07/14.
//  Copyright (c) 2014 Tobias Boogh. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, SegmentedTableViewCellDataSource {
    var optionCell : OptionTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.registerClass(SegmentedTableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.registerClass(OptionTableViewCell.self, forCellReuseIdentifier: "OptionCell")
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        if (indexPath.row < 4){
            var cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as SegmentedTableViewCell
            cell.datasource = self
            return cell
        }
        var cell = tableView.dequeueReusableCellWithIdentifier("OptionCell", forIndexPath: indexPath) as OptionTableViewCell

        
        
        cell.setRightButtons(createButtons())
        cell.setLeftButtons(createButtons())
        cell.tag = indexPath.row
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 44))
        label.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        label.text = "Hello"
        cell.contentView.addSubview(label)
        optionCell = cell
        return cell
    }

    func createButtons() -> [OptionTableViewCellButton]{
        var editButton = OptionTableViewCellButton(style: OptionTableViewCellButton.Style.Default)
        editButton.backgroundColor = UIColor.blueColor()
        if let label = editButton.textLabel{
            label.text = "Edit"
        }
        var deleteButton = OptionTableViewCellButton(style: OptionTableViewCellButton.Style.Default)
        deleteButton.backgroundColor = UIColor.redColor()
        if let label = deleteButton.textLabel{
            label.text = "Delete"
        }
        
        var moreButton = OptionTableViewCellButton(style: OptionTableViewCellButton.Style.Default)
        moreButton.backgroundColor = UIColor.grayColor()
        if let label = moreButton.textLabel{
            label.text = "More..."
        }
        return [editButton, deleteButton, moreButton]
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func numberOfSegmentsInCell(cell: SegmentedTableViewCell) -> Int {
        return 5
    }
    
    func segmentedCell(cell: SegmentedTableViewCell, viewForIndex index: Int) -> UIView {
        var color = UIColor(white: 1/CGFloat(index+1), alpha: 1.0)
        var view = UIView();
        view.backgroundColor = color
        view.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
        return view
    }
    
    @IBAction func expandTest(){
        if let cell = optionCell{
            cell.setState(OptionTableViewCell.State.OpenLeft, animated: true)
        }
    }

}

