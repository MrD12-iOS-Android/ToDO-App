//
//  Profil.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 5/6/21.
//

import UIKit
import SafariServices



class Profil: UIViewController, SFSafariViewControllerDelegate {


    
    @IBOutlet weak var tme: UIButton!
    @IBOutlet weak var birth: UILabel!
    @IBOutlet weak var realdate: UILabel!
    @IBOutlet weak var name: UILabel!
    let defaults = UserDefaults.standard
    var data : Task?
    @IBOutlet weak var img: UIImageView!
    var decoderInfo : UserInfo?
    var _name = ""
    override func viewDidLoad() {
        super.viewDidLoad()

//        guard let datas = data else { return }
       
        
        
        // MARK: DECODER
   
        if let data = UserDefaults.standard.object(forKey: "data1") as? Data {
            let decoder = JSONDecoder()
            if let tasks = try? decoder.decode(UserInfo.self, from: data) {
                print("AAAAAAAa")
                decoderInfo = tasks
            }
        }
        
        
//            if let savedData = defaults.object(forKey: "data") as? Data{
//                var decoder = JSONDecoder()
//                if let tasks = try? decoder.decode(UserInfo.self, from: savedData){
//
//                }
//            }
        
        tme.setTitle(decoderInfo?.link_tme, for: .normal)
        birth.text = decoderInfo?.birth
        
        name.text = decoderInfo?.name
        realdate.text = decoderInfo?.link_tme
        img.image = defaults.imageForKey(key: "Img1")
        
    }
    @IBAction func logout(_ sender: Any) {
        
    }
//    @IBAction func back(_ sender: Any) {
//        let vc = TabBars(nibName: "TabBars", bundle: nil)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true, completion: nil)
//    }
    // MARK: ENCODER
    func save_encoder(){
        let encoder = JSONEncoder()
        if let encodedata = try? encoder.encode(data){
            defaults.set(encodedata, forKey: "data")
        }
    }
    func myData(set: Task){
        data = set
        save_encoder()
    }
    @IBAction func button_telegram(_ sender: Any) {
        guard let datas = data else { return }
        url(url: tme.titleLabel!.text!)
    }
    func url(url: String){
        let telegram = "https://t.me/\(url)"
        if let sendurl = URL(string: telegram){
            let vc = SFSafariViewController(url: sendurl)
            vc.delegate = self
            present(vc, animated: true, completion: nil)
        }
    }
}


extension Profil : DatesInfo{
    func infoDates(info: Task) {
        name.text! = info._name ?? ""
    }
    
    
}
