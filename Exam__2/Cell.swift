//
//  Cell.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 4/30/21.
//

import UIKit

class Cell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var taskdesc: UILabel!
    @IBOutlet weak var taskTitle: UILabel!
    @IBOutlet weak var pri_view: UIView!
    @IBOutlet weak var txt_date: UILabel!
    @IBOutlet weak var text_picker: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func updateCell(task: Task){
        self.taskTitle.text = task.title
        self.taskdesc.text = task.desc
        self.txt_date.text = task.dates
        self.text_picker.text = task.week
        if task.state == .new{
            backView.backgroundColor = .systemGray6
        }else if task.state == .finished{
            backView.backgroundColor = .systemGray5
        }else{
            backView.backgroundColor = .systemGray4
        }
        
    switch task.priority! {
        case .none:
            self.pri_view.backgroundColor = .systemGray6
        case .low:
            self.pri_view.backgroundColor = .systemGreen
        case .medium:
            self.pri_view.backgroundColor = .systemYellow
        case .high:
            self.pri_view.backgroundColor = .systemRed
        }
    }
    
}
