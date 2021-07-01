//
//  NewTasks.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 4/29/21.
//

import UIKit

protocol NewTask {
    func diddelegate(task: Task)
    
    
}
class NewTasks: UIViewController, UITextFieldDelegate {
    var delegate : NewTask?
    var currntPri : TaskPriorety = .none
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var descTxt: UITextView!
    @IBOutlet weak var priorotyBtn: UIButton!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var dateFormatTF: UITextField!
    @IBOutlet weak var pickerViewTF: UITextField!
    @IBOutlet weak var weekTF: UITextField!
//    @IBOutlet weak var picView: UIPickerView!{
//        didSet{
//            picView.delegate = self
//            picView.dataSource = self
//        }
//    }
    var mydata = ["None","Low","Medium","High"]
    let picView = UIPickerView()
    var picker = UIPickerView()
    var datePicker = UIDatePicker()
    let weeks = [ "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"]
    override func viewDidLoad() {
        super.viewDidLoad()
        cardView.layer.borderWidth = 1.5
        cardView.layer.borderColor = #colorLiteral(red: 0.002697940217, green: 0.9770312905, blue: 0, alpha: 1)
        datePic()
        toolbar()
        _picView()
    }
    
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btn_pri(_ sender: Any) {
        let vc = PriorityVC(nibName: "PriorityVC", bundle: nil)
        vc.delegate = self
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true, completion: nil)
        
    }
    @IBAction func btn_Add(_ sender: Any) {
        if !titleField.text!.isEmpty{
            let task = Task.init(title: titleField.text!, desc: descTxt.text!, priority: self.currntPri, subtasks: [], dates: dateFormatTF.text!, week: weekTF.text!, profildata: .img)
            self.delegate?.diddelegate(task: task)
            self.dismiss(animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Task title can not be empty", message: "Please write the task title in order to create a new task", preferredStyle: .alert)
            let all = UIAlertAction(title: "OK", style: .cancel) { (_) in}
            alert.addAction(all)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    func datePic(){
        dateFormatTF.delegate = self
        dateFormatTF.inputView = datePicker
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(_picker), for: .valueChanged)
    }
    
    @objc func _picker(){
        let dateformat = DateFormatter()
        dateformat.dateFormat = "dd/MM/YY   HH:mm"
        dateFormatTF.text = dateformat.string(from: datePicker.date)
    }
    func toolbar(){
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        //toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done_Btn))
        let space = UIBarButtonItem(systemItem: .flexibleSpace)
        dateFormatTF.inputAccessoryView = toolBar
        pickerViewTF.inputAccessoryView = toolBar
        weekTF.inputAccessoryView = toolBar
        toolBar.items = [space, done]
    }
    
    func _picView(){
        picView.delegate = self
        picView.dataSource = self
        picker.delegate = self
        picker.dataSource = self
        picView.tag = 1
        picker.tag = 2
        pickerViewTF.inputView = picView
        weekTF.inputView = picker
        
    }
    
    @objc func done_Btn(){
        if dateFormatTF.isFirstResponder{
            dateFormatTF.resignFirstResponder()
            pickerViewTF.becomeFirstResponder()
        }else if pickerViewTF.isFirstResponder{
            pickerViewTF.resignFirstResponder()
            weekTF.becomeFirstResponder()
        }else{
            weekTF.resignFirstResponder()
        }
    }
}




extension NewTasks : UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
     
        switch pickerView.tag {
        case 1:
            return mydata.count
        case 2:
            return weeks.count
        default:
            return 1
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 1:
            return mydata[row]
        case 2:
            return weeks[row]
        default:
            return "Data not"
        }
        //self.delegate?.didPri(priority: choosenPri, color: #colorLiteral(red: 0.3176470697, green: 0.07450980693, blue: 0.02745098062, alpha: 1), title: "asd")
        //dismiss(animated: true, completion: nil)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        var choosenPri : TaskPriorety = .none
        
        
    switch pickerView.tag {
        case 1:
            if row == 0{
                print("0")
                pickerViewTF.backgroundColor = .systemGray6
                currntPri = .none
            }else if row == 1{
                print("1")
                pickerViewTF.backgroundColor = .systemGreen
                currntPri = .low
            }else if row == 2{
                print("2")
                pickerViewTF.backgroundColor = .systemYellow
                currntPri = .medium
            }else{
                print("3")
                pickerViewTF.backgroundColor = .systemRed
                currntPri = .high
            }
            pickerViewTF.text = mydata[row]
        case 2:
            weekTF.text = weeks[row]
        default:
            break
    }
        
        
    }
}

extension NewTasks : PriorityDelegate{
    func didPri(priority: TaskPriorety, color: UIColor, title: String) {
        self.currntPri = priority
        self.priorotyBtn.setTitle(title, for: .normal)
        self.priorotyBtn.backgroundColor = color
    }
}
