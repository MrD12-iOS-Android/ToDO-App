//
//  PriorityVC.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 4/29/21.
//

import UIKit
protocol PriorityDelegate {
    func didPri(priority: TaskPriorety, color: UIColor, title: String)
    
}


class PriorityVC: UIViewController {

    var delegate : PriorityDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    @IBAction func _priority_Choosse(_ sender: UIButton) {
        var choosenPri : TaskPriorety = .none
        if sender.tag == 0{
            choosenPri = .none
        }else if sender.tag == 1{
            choosenPri = .low
        }else if sender.tag == 2{
            choosenPri = .medium
        }else{
            choosenPri = .high
        }
        self.delegate?.didPri(priority: choosenPri, color: sender.backgroundColor!, title: sender.currentTitle!)
        dismiss(animated: true, completion: nil)
        
    }
    @IBAction func dismis(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    
}
