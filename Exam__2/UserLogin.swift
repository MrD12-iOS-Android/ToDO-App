//
//  UserLogin.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 5/6/21.
//

import UIKit
import SafariServices

struct UserInfo : Codable {
    var name: String
    var birth: String
    var link_tme: String
    var realtimes : String
}
protocol DatesInfo {
    func infoDates(info: Task)
}
class UserLogin: UIViewController, UITextFieldDelegate, SFSafariViewControllerDelegate {
    var del : DatesInfo?
    var info : UserInfo?
    @IBOutlet weak var _auto_remove: UITextField!
    @IBOutlet weak var _realtime: UILabel!
    @IBOutlet weak var _tme: UITextField!
    @IBOutlet weak var _nameTF: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var profil_img: UIImageView!
    @IBOutlet weak var add_img: UIButton!
    var imging = true
    var date = Date()
    let formatter = DateFormatter()
    let defaults = UserDefaults.standard
    var data : Task?
    var _datepicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserDefaults.standard.setValue(true, forKey: "isUser")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        autoremove()
        toolbar()
    
        formatter.dateFormat = "dd.MM.yyyy   HH:mm"
        let result = formatter.string(from: date)
        _realtime.text = result
       
    }
    // MARK: DATEPICKER
    func autoremove(){
        _auto_remove.delegate = self
        _auto_remove.inputView = _datepicker
        _datepicker.preferredDatePickerStyle = .wheels
        _datepicker.datePickerMode = .dateAndTime
        _datepicker.addTarget(self, action: #selector(_date), for: .valueChanged)
        
    }
    @objc func _date(){
        formatter.dateFormat = "dd.MM.yyyy"
        _auto_remove.text = formatter.string(from: _datepicker.date)
    }
    
    // MARK: TOOLBAR
    func  toolbar(){
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(_doneBtn))
        let space = UIBarButtonItem(systemItem: .flexibleSpace)
        toolbar.isTranslucent = true
        toolbar.sizeToFit()
        _nameTF.inputAccessoryView = toolbar
        _tme.inputAccessoryView = toolbar
        _auto_remove.inputAccessoryView = toolbar
        toolbar.items = [space, done]
        
        
    }
    @objc func _doneBtn(){
        if _nameTF.isFirstResponder{
            _nameTF.resignFirstResponder()
            _tme.becomeFirstResponder()
        }else if _tme.isFirstResponder{
            _tme.resignFirstResponder()
            _auto_remove.becomeFirstResponder()
        }else{
            _auto_remove.resignFirstResponder()
        }
    }
    
    func setImage(image : UIImage) {
        UserDefaults.standard.set(image.jpegData(compressionQuality: 100), forKey: "key")
    }
    func getImage() -> UIImage? {
        if let imageData = UserDefaults.standard.value(forKey: "key") as? Data{
            if let imageFromData = UIImage(data: imageData){
                return imageFromData
            }
        }
        return nil
    }
    
    
//    // MARK: DECODER
//    func decoder(){
//        if let savedData = defaults.object(forKey: "data") as? Data{
//             let decoder = JSONDecoder()
//            if let tasks = try? decoder.decode(Profil_Data.self, from: savedData){
//
//            }
//        }
//    }
    // MARK: ENCODER
//    func save_encoder(){
//        let encoder = JSONEncoder()
//        if let encodedata = try? encoder.encode(info){
//            defaults.set(encodedata, forKey: "data")
//        }
//    }
    

    
    
    // MARK: ADD IMG
    @IBAction func add_Img(_ sender: Any) {
        if imging{
            let img = UIImagePickerController()
            img.sourceType = .photoLibrary
            img.allowsEditing = true
            img.delegate = self
            imging = true
           
            present(img, animated: true)
            defaults.setImage(image: profil_img.image, forKey: "img")
            
            add_img.setTitle("Edit Img", for: .normal)
            //add_img.isHidden = true
        }else{
            let img = UIImagePickerController()
            img.sourceType = .photoLibrary
            img.allowsEditing = true
            img.delegate = self
            imging = false
            
            present(img, animated: true)
            //add_img.isHidden = true
        }
        
        
    }
    
    
    @IBAction func saveBtn(_ sender: Any) {
        UserDefaults.standard.setValue(true, forKey: "isUser")
        let vc = TabBars(nibName: "TabBars", bundle: nil)
      print("WWWW")
        defaults.setImage(image: profil_img.image, forKey: "Img1")
        info = UserInfo(name: _nameTF.text ?? "", birth: _auto_remove.text ?? "", link_tme: _tme.text ?? "", realtimes: _realtime.text ?? "")
        
        
        let encoder = JSONEncoder()
        if let encodedata = try? encoder.encode(info){
            defaults.set(encodedata, forKey: "data1")
        }
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion:  nil)
    }
    
  
    

}

extension UserLogin : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let myImg = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
            profil_img.image = myImg
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
extension UserDefaults {
    
    func imageForKey(key: String) -> UIImage? {
        var image: UIImage?
        if let imageData = data(forKey: key) {
            image = NSKeyedUnarchiver.unarchiveObject(with: imageData) as? UIImage
        }
        return image
    }
    
    func setImage(image: UIImage?, forKey key: String) {
        var imageData: NSData?
        if let image = image {
            imageData = NSKeyedArchiver.archivedData(withRootObject: image) as NSData?
        }
        set(imageData, forKey: key)
    }
    
}



