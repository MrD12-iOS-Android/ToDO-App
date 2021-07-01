//
//  Info.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 5/5/21.
//

import UIKit

class Info: UIViewController {
    
    
    var delegate : Task?
    @IBOutlet weak var _description: UILabel!
    @IBOutlet weak var _date: UILabel!
    @IBOutlet weak var _title: UILabel!
    @IBOutlet weak var weekslbl: UILabel!
    @IBOutlet weak var miniView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let data = delegate else { return }
        _title.text = data.title
        _description.text = data.desc
        _date.text = data.dates
        weekslbl.text = data.week
        
    }
    func setTask(task: Task){
        delegate = task
    }


}
