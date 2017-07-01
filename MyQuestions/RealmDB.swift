//
//  RealmDB.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/09.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDB: Object {
    
  dynamic var id: Int = 0
  dynamic var title: String = ""
  dynamic var question: String = ""
  dynamic var answer: String = ""
  dynamic var category: String = ""
  dynamic var level: String = ""
  dynamic var correctMark: Int = 0
  dynamic var wrongMark: Int = 0
  dynamic var date = NSDate()

//  convenience init(name: String) {
//    self.init()
//    self.title = title
//    self.question = question
//    self.answer = answer
//    self.category = category
//    self.level = level
//    self.correctMark = correctMark
//    self.wrongMark = wrongMark
//    self.date = date
//  }
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
}
