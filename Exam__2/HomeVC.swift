//
//  HomeVC.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 4/29/21.
//

import UIKit
protocol InfoDel {
    func didinfo(taskinfo: Task)
}

class HomeVC: UIViewController {
    var defaults = UserDefaults.standard
    var newTasks: [Task] = []
    var finishedTasks: [Task] = []
    var archivedTasks: [Task] = []
    var del : InfoDel?
    @IBOutlet weak var searchView: UISearchBar!{
        didSet{
            searchView.delegate = self
        }
    }
    var searching = false
    var filter : [Task] = []
    var allTask : [[Task]] = []
    var index = IndexPath()
    var datePicker = UIDatePicker()
    var section_title: [String] = ["New Tasks", "Finished Tasks", "Archived Tasks"]
    @IBOutlet weak var table: UITableView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableview()
        table.rowHeight = 150
       

      
        
        // Decoder
        if let savedData = defaults.object(forKey: "new") as? Data{
            let decoder = JSONDecoder()
            if let tasks = try? decoder.decode([Task].self, from: savedData){
                newTasks = tasks
                
            }
        }
        if let savedData = defaults.object(forKey: "finish") as? Data{
            let decoder = JSONDecoder()
            if let tasks = try? decoder.decode([Task].self, from: savedData){
                finishedTasks = tasks
                
            }
        }
        if let savedData = defaults.object(forKey: "archived") as? Data{
            let decoder = JSONDecoder()
            if let tasks = try? decoder.decode([Task].self, from: savedData){
                archivedTasks = tasks
            }
        }
          allTask.append(newTasks)
          allTask.append(finishedTasks)
          allTask.append(archivedTasks)
    }
    
 
    
    @IBAction func btn(_ sender: Any) {
        let vc = NewTasks(nibName: "NewTasks", bundle: nil)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        present(vc, animated: true, completion: nil)
        
    }
    func encoder(){
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(newTasks){
            defaults.set(encodedData, forKey: "new")
        }
        
        if let encodedData = try? encoder.encode(finishedTasks){
            defaults.set(encodedData, forKey: "finish")
        }
        
        if let encodedData = try? encoder.encode(archivedTasks){
            defaults.set(encodedData, forKey: "archived")
        }
    }
}


extension HomeVC : UITableViewDelegate, UITableViewDataSource{
    func setupTableview(){
        self.table.delegate = self
        self.table.dataSource = self
        self.table.tableFooterView = UIView()
        self.table.contentInset = .init(top: 20, left: 0, bottom: 50, right: 0)
        table.register(UINib(nibName: "Cell", bundle: nil), forCellReuseIdentifier: "Cell")
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if searching {
            return 1
        } else {
            return section_title.count
        }
        
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching{
            return self.filter.count
        }else{
            if section == 0{
                    return newTasks.count
            }else if section == 1{
                    return finishedTasks.count
            }else{
                    return archivedTasks.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = table.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? Cell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        
        if searching{
            cell.updateCell(task: filter[indexPath.row])
        }else{
            if indexPath.section == 0{
                    cell.updateCell(task: newTasks[indexPath.row])
            }else if indexPath.section == 1{
                    cell.updateCell(task: finishedTasks[indexPath.row])
            }else{
                    cell.updateCell(task: archivedTasks[indexPath.row])
            }
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        index = indexPath
        
        var choosen : Task!
        if indexPath.section == 0{
            choosen = newTasks[indexPath.row]
        }else if indexPath.section == 1{
            choosen = finishedTasks[indexPath.row]
        }else{
            choosen = archivedTasks[indexPath.row]
        }
        
        let alert = UIAlertController(title: "Choosen what to", message: nil, preferredStyle: .actionSheet)
        let finish = UIAlertAction(title: "Finish", style: .default) { (_) in
            choosen.state = .finished
            self.finishedTasks.append(choosen)
            self.newTasks.remove(at: indexPath.row)
            self.allTask[0] = self.newTasks
            self.allTask[1] = self.finishedTasks
            self.allTask[2] = self.archivedTasks
            self.encoder()
            self.table.reloadData()
        }
        
        let info = UIAlertAction(title: "Info", style: .default) { (_) in
            let vc = Info(nibName: "Info", bundle: nil)
            //vc.modalPresentationStyle = .fullScreen
            if indexPath.section == 0{
                vc.setTask(task: self.newTasks[indexPath.row])
            }else if indexPath.section == 1{
                vc.setTask(task: self.finishedTasks[indexPath.row])
            }else{
                vc.setTask(task: self.archivedTasks[indexPath.row])
                
            }
            self.present(vc, animated: true, completion: nil)
        }
        
        let share_email = UIAlertAction(title: "Share by Email", style: .default) { (_) in
            let img = UIImage(named: "list")
            let url = "https://youtube.com"
            let vc = UIActivityViewController(activityItems: ["This is sharing img and url", img, url], applicationActivities: nil)
            self.present(vc, animated: true, completion: nil)
        }
        
        let share_other_way = UIAlertAction(title: "Share by other way", style: .default) { (_) in
            
            let vc = UIActivityViewController(activityItems: ["This is sharing String"], applicationActivities: nil)
            self.present(vc, animated: true, completion: nil)
        }
        let archived = UIAlertAction(title: "Archived", style: .default) { (_) in
            choosen.state = .archived
            self.archivedTasks.append(choosen)
            if indexPath.section == 0{
                self.newTasks.remove(at: indexPath.row)
                self.allTask[0] = self.newTasks
                self.allTask[1] = self.finishedTasks
                self.allTask[2] = self.archivedTasks
                self.encoder()
            }else{
                self.finishedTasks.remove(at: indexPath.row)
                self.allTask[0] = self.newTasks
                self.allTask[1] = self.finishedTasks
                self.allTask[2] = self.archivedTasks
                self.encoder()
            }
            self.table.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (_) in}
        
        let unarchived = UIAlertAction(title: "UnArchived", style: .default) { (_) in
            choosen.state = .new
            self.newTasks.append(choosen)
            if indexPath.section == 1{
                self.finishedTasks.remove(at: indexPath.row)
                self.allTask[0] = self.newTasks
                self.allTask[1] = self.finishedTasks
                self.allTask[2] = self.archivedTasks
                self.encoder()
            }else{
                self.archivedTasks.remove(at: indexPath.row)
                self.allTask[0] = self.newTasks
                self.allTask[1] = self.finishedTasks
                self.allTask[2] = self.archivedTasks
                self.encoder()
            }
            self.table.reloadData()
        }
        
        let unfinish = UIAlertAction(title: "UnFinish", style: .default) { (_) in
            choosen.state = .new
            self.newTasks.append(choosen)
            self.finishedTasks.remove(at: indexPath.row)
            self.allTask[0] = self.newTasks
            self.allTask[1] = self.finishedTasks
            self.allTask[2] = self.archivedTasks
            self.encoder()
            self.table.reloadData()
        }
     
        if indexPath.section == 0{
            alert.addAction(info)
            alert.addAction(finish)
            alert.addAction(archived)
            alert.addAction(share_email)
            alert.addAction(share_other_way)
            
            let del = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                self.newTasks.remove(at: indexPath.row)
                self.encoder()
                self.table.deleteRows(at: [indexPath], with: .automatic)
                self.table.reloadData()
            }
            alert.addAction(del)
            
        }else if indexPath.section == 1{
            alert.addAction(info)
            alert.addAction(unfinish)
            alert.addAction(unarchived)
            alert.addAction(share_email)
            alert.addAction(share_other_way)
            let del = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                self.finishedTasks.remove(at: indexPath.row)
                self.allTask[0] = self.newTasks
                self.allTask[1] = self.finishedTasks
                self.allTask[2] = self.archivedTasks
                self.encoder()
                self.table.deleteRows(at: [indexPath], with: .automatic)
                self.table.reloadData()
            }
            alert.addAction(del)
            
        }else{
            alert.addAction(info)
            alert.addAction(unarchived)
            alert.addAction(share_email)
            alert.addAction(share_other_way)
            let del = UIAlertAction(title: "Delete", style: .destructive) { (_) in
                self.archivedTasks.remove(at: indexPath.row)
                self.allTask[0] = self.newTasks
                self.allTask[1] = self.finishedTasks
                self.allTask[2] = self.archivedTasks
                self.encoder()
                self.table.deleteRows(at: [indexPath], with: .automatic)
                self.table.reloadData()
            }
            alert.addAction(del)
        }
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
 
    
    // MARK: CONTEXMENU
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [self] (_) -> UIMenu? in
            var choosen : Task!
            if indexPath.section == 0{
                choosen = newTasks[indexPath.row]
            }else if indexPath.section == 1{
                choosen = self.finishedTasks[indexPath.row]
            }else{
                choosen = self.archivedTasks[indexPath.row]
            }
            
            if indexPath.section == 0{
                let info = UIAction(title: "Info", image: nil) { (_) in
                    let vc = Info(nibName: "Info", bundle: nil)
                    //vc.modalPresentationStyle = .fullScreen
                    
                    if indexPath.section == 0{
                        vc.setTask(task: self.newTasks[indexPath.row])
                    }else if indexPath.section == 1{
                        vc.setTask(task: self.finishedTasks[indexPath.row])
                    }else{
                        vc.setTask(task: self.archivedTasks[indexPath.row])
                        
                    }
                    self.present(vc, animated: true, completion: nil)
                }
     
                let finish = UIAction(title: "Finish", image: nil) { (_) in
                    choosen.state = .finished
                    self.finishedTasks.append(choosen)
                    self.newTasks.remove(at: indexPath.row)
                    self.allTask[0] = self.newTasks
                    self.allTask[1] = self.finishedTasks
                    self.allTask[2] = self.archivedTasks
                    self.encoder()
                    self.table.reloadData()
                }
                
                let archived = UIAction(title: "Archived", image: nil) { (_) in
                    choosen.state = .archived
                    self.archivedTasks.append(choosen)
                    if indexPath.section == 0{
                        self.newTasks.remove(at: indexPath.row)
                        self.allTask[0] = self.newTasks
                        self.allTask[1] = self.finishedTasks
                        self.allTask[2] = self.archivedTasks
                        self.encoder()
                    }else{
                        self.finishedTasks.remove(at: indexPath.row)
                        self.allTask[0] = self.newTasks
                        self.allTask[1] = self.finishedTasks
                        self.allTask[2] = self.archivedTasks
                        self.encoder()
                    }
                    self.table.reloadData()
                }
    
                let sharemail = UIAction(title: "Share by Email", image: nil) { (_) in
                    let img = UIImage(named: "list")
                    let url = "https://youtube.com"
                    let vc = UIActivityViewController(activityItems: ["This is sharing img and url", img, url], applicationActivities: nil)
                    self.present(vc, animated: true, completion: nil)
                }
               
                let shareorther = UIAction(title: "Share by other way", image: nil) { (_) in
                    let vc = UIActivityViewController(activityItems: ["This is sharing String"], applicationActivities: nil)
                    self.present(vc, animated: true, completion: nil)
                }
              
                let delete = UIAction(title: "Delete", attributes: .destructive) { (_) in
                    self.newTasks.remove(at: indexPath.row)
                    self.allTask[0] = self.newTasks
                    self.allTask[1] = self.finishedTasks
                    self.allTask[2] = self.archivedTasks
                    self.encoder()
                    self.table.deleteRows(at: [indexPath], with: .automatic)
                    self.table.reloadData()
                }
                
                let menu = UIMenu(children: [info, finish, archived, sharemail, shareorther, delete])
                return menu
            }else if indexPath.section == 1{
                
                let info = UIAction(title: "Info", image: nil) { (_) in
                    let vc = Info(nibName: "Info", bundle: nil)
                    //vc.modalPresentationStyle = .fullScreen
                    if indexPath.section == 0{
                        vc.setTask(task: self.newTasks[indexPath.row])
                    }else if indexPath.section == 1{
                        vc.setTask(task: self.finishedTasks[indexPath.row])
                    }else{
                        vc.setTask(task: self.archivedTasks[indexPath.row])
                        
                    }
                    self.present(vc, animated: true, completion: nil)
                }
            
                let unfinish = UIAction(title: "UnFinish", image: nil) { (_) in
                    choosen.state = .finished
                    self.newTasks.append(choosen)
                    self.finishedTasks.remove(at: indexPath.row)
                    self.allTask[0] = self.newTasks
                    self.allTask[1] = self.finishedTasks
                    self.allTask[2] = self.archivedTasks
                    self.encoder()
                    self.table.reloadData()
                }
                
                let unarchived = UIAction(title: "UnArchived", image: nil) { (_) in
                    choosen.state = .new
                    self.archivedTasks.append(choosen)
                    if indexPath.section == 0{
                        self.finishedTasks.remove(at: indexPath.row)
                        self.allTask[0] = self.newTasks
                        self.allTask[1] = self.finishedTasks
                        self.allTask[2] = self.archivedTasks
                        self.encoder()
                    }else{
                        self.archivedTasks.remove(at: indexPath.row)
                        self.allTask[0] = self.newTasks
                        self.allTask[1] = self.finishedTasks
                        self.allTask[2] = self.archivedTasks
                        self.encoder()
                    }
                    self.table.reloadData()
                }
             
                let sharemail = UIAction(title: "Share by Email", image: nil) { (_) in
                    let img = UIImage(named: "list")
                    let url = "https://youtube.com"
                    let vc = UIActivityViewController(activityItems: ["This is sharing img and url", img, url], applicationActivities: nil)
                    self.present(vc, animated: true, completion: nil)
                }

                let shareorther = UIAction(title: "Share by other way", image: nil) { (_) in
                    let vc = UIActivityViewController(activityItems: ["This is sharing String"], applicationActivities: nil)
                    self.present(vc, animated: true, completion: nil)
                }
                
                let delete = UIAction(title: "Delete", attributes: .destructive) { (_) in
                    self.finishedTasks.remove(at: indexPath.row)
                    self.allTask[0] = self.newTasks
                    self.allTask[1] = self.finishedTasks
                    self.allTask[2] = self.archivedTasks
                    self.encoder()
                    self.table.deleteRows(at: [indexPath], with: .automatic)
                    self.table.reloadData()
                }
                
                let menu = UIMenu(children: [info, unfinish, unarchived, sharemail, shareorther, delete])
                return menu
                
                
            }else{
                let info = UIAction(title: "Info", image: nil) { (_) in
                    let vc = Info(nibName: "Info", bundle: nil)
                    //vc.modalPresentationStyle = .fullScreen
                    if indexPath.section == 0{
                        vc.setTask(task: self.newTasks[indexPath.row])
                    }else if indexPath.section == 1{
                        vc.setTask(task: self.finishedTasks[indexPath.row])
                    }else{
                        vc.setTask(task: self.archivedTasks[indexPath.row])
                        
                    }
                    self.present(vc, animated: true, completion: nil)
                }
      
                let unarchived = UIAction(title: "UnArchived", image: nil) { (_) in
                    choosen.state = .new
                    self.newTasks.append(choosen)
                    if indexPath.section == 0{
                        self.archivedTasks.remove(at: indexPath.row)
                        self.allTask[0] = self.newTasks
                        self.allTask[1] = self.finishedTasks
                        self.allTask[2] = self.archivedTasks
                        self.encoder()
                    }else{
                        self.archivedTasks.remove(at: indexPath.row)
                        self.allTask[0] = self.newTasks
                        self.allTask[1] = self.finishedTasks
                        self.allTask[2] = self.archivedTasks
                        self.encoder()
                    }
                    self.table.reloadData()
                }
                
                let sharemail = UIAction(title: "Share by Email", image: nil) { (_) in
                    
                }

                let shareorther = UIAction(title: "Share by other way", image: nil) { (_) in
                    
                }
                
                let delete = UIAction(title: "Delete", attributes: .destructive) { (_) in
                    self.archivedTasks.remove(at: indexPath.row)
                    self.allTask[0] = self.newTasks
                    self.allTask[1] = self.finishedTasks
                    self.allTask[2] = self.archivedTasks
                    self.encoder()
                    self.table.deleteRows(at: [indexPath], with: .automatic)
                    self.table.reloadData()
                }
                
                let menu = UIMenu(children: [info, unarchived, sharemail, shareorther, delete])
                return menu
                
            }
            return UIMenu()
        }
    }
    
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            
        if indexPath.section == 0{
                self.newTasks.remove(at: indexPath.row)
            self.allTask[0] = self.newTasks
            self.allTask[1] = self.finishedTasks
            self.allTask[2] = self.archivedTasks
                self.encoder()
            }else if indexPath.section == 1{
                self.finishedTasks.remove(at: indexPath.row)
                self.allTask[0] = self.newTasks
                self.allTask[1] = self.finishedTasks
                self.allTask[2] = self.archivedTasks
                self.encoder()
            }else{
                self.archivedTasks.remove(at: indexPath.row)
                self.allTask[0] = self.newTasks
                self.allTask[1] = self.finishedTasks
                self.allTask[2] = self.archivedTasks
                self.encoder()
            }
            self.table.reloadData()
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView(frame: .zero)
        v.backgroundColor = .clear
        let lbl = UILabel(frame: CGRect(x: self.view.frame.width / 2-150 / 2, y: 0, width: 150, height: 30))
        v.addSubview(lbl)
        lbl.text = section_title[section]
        lbl.backgroundColor = .systemGray6
        lbl.layer.cornerRadius = 15
        lbl.textColor = .systemGreen
        lbl.textAlignment = .center
        lbl.clipsToBounds = true
        lbl.font = .systemFont(ofSize: 17, weight: .bold)
        if table.numberOfRows(inSection: section) == 0{
            v.isHidden = true
        }else{
            v.isHidden = false
        }
        return v
    }
}


extension HomeVC : NewTask{
    func diddelegate(task: Task) {
        newTasks.append(task)
        encoder()
        allTask[0] = newTasks
        table.reloadData() 
    }
}
extension HomeVC : UISearchResultsUpdating, UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searching = searchText.isEmpty ? false : true
        filter = []
            for i in allTask{
                for j in i {
                    if j.title!.lowercased().contains(searchText.lowercased()) {
                        filter.append(j)
                    }
                }
            }
       
        
        table.reloadData()
        
        
        
        
//        filter = []
//        if searchText == ""{
//
////            filter = newTasks
////            filter = finishedTasks
////            filter = archivedTasks
//        }else{
//
//            filter = newTasks.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
//            filter = finishedTasks.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
//            filter = archivedTasks.filter({$0.title.lowercased().prefix(searchText.count) == searchText.lowercased()})
//        }
    }
    
    
}


