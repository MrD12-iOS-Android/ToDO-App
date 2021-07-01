//
//  Task.swift
//  Exam__2
//
//  Created by Oybek Iskandarov on 4/29/21.
//

import Foundation

enum TaskState : Int, Codable{
    case new
    case finished
    case archived
}
enum TaskPriorety : Int, Codable{
    case high
    case low
    case medium
    case none
}

enum Profil_Data : String, Codable {
    case name
    case realtime
    case autoremove
    case img
}

struct Task : Codable{
    var title : String?
    var desc : String?
    var priority : TaskPriorety?
    var state : TaskState? = .new
    var subtasks : [SubTask]?
    var dates : String?
    var week : String?
    var _name : String?
    var _tme : String?
    var _realtime : String?
    var _birth : String?
    var profildata : Profil_Data?
}
struct SubTask : Codable{
    var title : String
    var desc : String
    var priority : TaskPriorety
}
