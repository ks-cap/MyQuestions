//
//  SecondViewController.swift
//  MyQuestions
//
//  Created by 佐藤賢 on 2017/05/09.
//  Copyright © 2017年 佐藤賢. All rights reserved.
//

import UIKit
import RealmSwift

class SecondViewController: UIViewController,UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
  
  var questionItem: Results<RealmDB>!
  var categoryItem: Results<CategoryDB>!
  var categoryString: [String?] = []  // Pickerに格納されている文字列
  var didCategorySelect = String()    // Pickerで選択した文字列の格納場所
  var count: Int = 0                  // CategoryDBに保存してあるデータ数
  var i: Int = 0                      // 比較する変数
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    let realm = try! Realm()
    let realms = try! Realm()
    questionItem = realm.objects(RealmDB.self)
    categoryItem = realms.objects(CategoryDB.self)
    
    count = categoryItem.count
    // CategoryDBに保存してある値を配列に格納
    while count>i {
      let object = categoryItem[i]
      categoryString += [object.name]
      i += 1
    }
    // 初期化
    i = 0

    if (categoryString.isEmpty == false) {
      categoryPickerView.selectRow(0, inComponent: 0, animated: true)
      didCategorySelect = categoryString[0]!
    }
    
    // levelの初期値
    nowLevel.text = "5"
  }
  
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let realms = try! Realm()
    categoryItem = realms.objects(CategoryDB.self)
    // 変更後の数
    let recount: Int = categoryItem.count
    // 変更前の数と比べる
    if(recount != count){
      // 配列の中身を初期化
      categoryString = []
      // CategoryDBに保存してある値を配列にあるだけ再度格納
      while recount>i {
        let object = categoryItem[i]
        categoryString += [object.name]
        i += 1
      }
      // 比較する変数の初期化
      i = 0
      count = recount
      categoryPickerView.selectRow(recount, inComponent: 0, animated: true)
      categoryPickerView.reloadAllComponents()
    }
    
  }
  
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var questionLabel: UILabel!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var categoryLabel: UILabel!
  @IBOutlet weak var levelLabel: UILabel!
  @IBOutlet weak var nowLevel: UILabel!
  
  @IBOutlet weak var titleTextView: UITextField!
  @IBOutlet weak var questionTextView: UITextField!
  @IBOutlet weak var answerTextView: UITextField!
  @IBOutlet weak var categoryPickerView: UIPickerView!
  
  @IBAction func addCategoryButton(_ sender: Any) {
    let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    appDelegate.pop = "Second"
    performSegue(withIdentifier: "addCategorySegue", sender: nil)
  }
  
  @IBAction func tapScreen(_ sender: Any) {
    self.view.endEditing(true)
  }
  
  @IBAction func levelSlider(_ sender: UISlider) {
    nowLevel.text = String(Int(sender.value))
  }
  
  // pickerViewの列数
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }
  // pickerViewの行数
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return categoryString.count
  }
  // pickerViewのセルを表示
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return categoryString[row]
  }
  // pickerViewのセルを選択
  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    if let didCategoryString = categoryString[row] {
      didCategorySelect = didCategoryString
    }
  }
  
  
  // データを保存
  @IBAction func saveButton(_ sender: Any) {
    // 未入力項目がないか確認
    if (titleTextView.text != "" || questionTextView.text != ""
      || answerTextView.text != "" || didCategorySelect == "選択してください"){
      
      // 新しいインスタンスを生成
      let newRealmDB = RealmDB()
      // textField等に入力したデータをnewRealmDBに代入
      newRealmDB.title = titleTextView.text!
      newRealmDB.question = questionTextView.text!
      newRealmDB.answer = answerTextView.text!
      newRealmDB.category = didCategorySelect
      newRealmDB.level = nowLevel.text!
      // 既にデータが他に作成してある場合
      if questionItem.count != 0 {
        newRealmDB.id = questionItem.max(ofProperty: "id")! + 1
      }
      
      // 上記で代入したテキストデータを永続化
      let realm = try! Realm()
      questionItem = realm.objects(RealmDB.self)
      try! realm.write({ () -> Void in
        realm.add(newRealmDB, update: false)
      })
      // 保存したことを知らせるアラート表示
      let alertController = UIAlertController(title: "保存しました", message: "問題一覧に戻ります", preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
      reset()
      
    }else {
      // 未入力を知らせるアラート表示
      let alertController = UIAlertController(title: "未入力項目が存在します", message: nil, preferredStyle: .alert)
      let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
      alertController.addAction(alertAction)
      present(alertController, animated: true, completion: nil)
    }
  }
  
  // 入力項目を全てリセット
  func reset() {
    titleTextView.text! = String()
    questionTextView.text! = String()
    answerTextView.text! = String()
    categoryPickerView.selectRow(0, inComponent: 0, animated: false)
    nowLevel.text! = String()
  }
  
  // Doneボタンを押した際キーボードを閉じる
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
}

