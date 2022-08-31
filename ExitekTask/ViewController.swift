//
//  ViewController.swift
//  ExitekTask
//
//  Created by Vitaliy Griza on 31.08.2022.
//

import UIKit
import Then
import SnapKit
import Foundation
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
   

    var filmTitleInput: TextField!
    var filmYearInput: TextField!
    var addFilmButton: UIButton!
    var filmsTableView: UITableView!
    var filmItem = FilmItem()
    var activeTextView: UITextView? = nil
    var alertLabel: UILabel!
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 0.5) {
            for view in self.view.subviews {
                view.alpha = 1
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        view.backgroundColor = .white
        alertLabel = UILabel().then({ label in
            view.addSubview(label)
            label.numberOfLines = 0
            label.textColor = .black
            label.text = ""
            label.alpha = 0
            label.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
                make.centerX.equalToSuperview()
            }
        })
        filmTitleInput = TextField().then({ filmTitleInput in
            view.addSubview(filmTitleInput)
            filmTitleInput.placeholder = "Input film title"
            filmTitleInput.layer.borderWidth = 1
            filmTitleInput.layer.cornerRadius = 10
            filmTitleInput.layer.borderColor = UIColor.lightGray.cgColor
            filmTitleInput.clearButtonMode = .always
            filmTitleInput.delegate = self
            filmTitleInput.backgroundColor = .white
            filmTitleInput.font = .monospacedDigitSystemFont(ofSize: 16, weight: .light)
            filmTitleInput.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
                make.height.equalTo(50)
                make.left.right.equalToSuperview().inset(10)
            }
        })
        
        filmYearInput = TextField().then({ filmYearInput in
            view.addSubview(filmYearInput)
            filmYearInput.placeholder = " Input film year"
            filmYearInput.layer.borderWidth = 1
            filmYearInput.layer.cornerRadius = 10
            filmYearInput.layer.borderColor = UIColor.lightGray.cgColor
            filmYearInput.clearButtonMode = .always
            filmYearInput.delegate = self
            
            filmYearInput.backgroundColor = .white
            filmYearInput.font = .monospacedDigitSystemFont(ofSize: 16, weight: .light)
            filmYearInput.keyboardType = .numberPad
            filmYearInput.snp.makeConstraints { make in
                make.top.equalTo(filmTitleInput.snp.bottom).offset(20)
                make.height.equalTo(50)
                make.left.right.equalToSuperview().inset(10)
            }
        })
        
        addFilmButton = UIButton().then({ addFilmButton in
            view.addSubview(addFilmButton)
            addFilmButton.backgroundColor = .systemBlue
            addFilmButton.layer.cornerRadius = 10
            addFilmButton.setTitle("Add", for: .normal)
            addFilmButton.titleLabel?.font = .monospacedDigitSystemFont(ofSize: 16, weight: .light)
            addFilmButton.addTarget(self, action: #selector(addFilmToList), for: .touchUpInside)
            addFilmButton.snp.makeConstraints { make in
                make.top.equalTo(filmYearInput.snp.bottom).offset(30)
                make.centerX.equalToSuperview()
                make.height.equalTo(40)
                make.width.equalTo(70)
            }
        })
        
        filmsTableView = UITableView().then({ tableView in
            view.addSubview(tableView)
            tableView.delegate = self
            tableView.dataSource = self
            tableView.separatorStyle = .none
            tableView.showsVerticalScrollIndicator = false
            tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.snp.makeConstraints { make in
                make.top.equalTo(addFilmButton.snp.bottom).offset(20)
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        })
        
        for view in view.subviews {
            view.alpha = 0
        }
        
        
    }
    
    @objc func addFilmToList() {
        
        view.endEditing(true)
        
        UIView.animate(withDuration: 0.1) {
            self.addFilmButton.transform = .init(scaleX: 0.85, y: 0.85)
        } completion: { com in
            UIView.animate(withDuration: 0.1) {
                self.addFilmButton.transform = .identity
            }
        }
        
        if self.filmTitleInput.text!.count > 1 && self.filmYearInput.text?.count == 4 {
            let textToInt = self.filmYearInput.text
            self.filmItem.title = self.filmTitleInput.text!.trimmingCharacters(in: .whitespaces)
            self.filmItem.year = Int(textToInt!)
            
//            second way to exclude duplicates
            
//            if AppData.shared.filmArray.count >= 1 {
//                var shouldBeAddedToArray = true
//                for film in AppData.shared.filmArray {
//                    if film.title == filmItem.title {
//                        shouldBeAddedToArray = false
//                        print("duplicate")
//                    }
//                }
//                if shouldBeAddedToArray {
//                    AppData.shared.filmArray.append(filmItem)
//                    AppData.shared.saveData()
//                    filmsTableView.reloadData()
//                }
//            }
//
            
            if AppData.shared.filmArray.count >= 1 {
                
                AppData.shared.filmArray.append(filmItem)
                AppData.shared.filmArray = AppData.shared.filmArray.removingDuplicates(withSame: \.title)
                self.filmYearInput.text = ""
                self.filmTitleInput.text = ""
                AppData.shared.saveData()
                filmsTableView.reloadData()
            } else {
                AppData.shared.filmArray.append(filmItem)
                AppData.shared.saveData()
                self.filmTitleInput.text = ""
                self.filmYearInput.text = ""
                filmsTableView.reloadData()
            }
            
        } else {
            showSimpleAlert(title: "Wrong data", message: "Input correct data")
        }
        

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if AppData.shared.filmArray.count == 0 {
            tableView.setEmptyView(title: "No data", message: "Please add some data")
        } else {
            tableView.restore()
        }
        
        
        
        return AppData.shared.filmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.loadData(film: AppData.shared.filmArray[indexPath.row])
        return cell
    }
    
    func showSimpleAlert(title:String, message: String) {
            
        let alert = UIAlertController(title: title, message: message,         preferredStyle: UIAlertController.Style.alert)

       let yesAction = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
           self.alertLabel.text = "Incorrect data"
           UIView.animate(withDuration: 0.2) {
               self.alertLabel.alpha = 1
           }
    }
     
        let noAction = UIAlertAction(title: "Close", style: .default) { (action) -> Void in
            self.alertLabel.text = ""
            self.alertLabel.alpha = 0
    }
        alert.addAction(yesAction)
        alert.addAction(noAction)
       
        
            self.present(alert, animated: true, completion: nil)
        }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.lightGray.cgColor
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.3) {
            textField.layer.borderColor = UIColor.purple.cgColor
        }
        
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
           // if keyboard size is not available for some reason, dont do anything
           return
        }
        filmsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
      
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
      // move back the root view origin to zero
      self.view.frame.origin.y = 0
    }

}

extension UITableView {
    func setEmptyView(title: String, message: String) {
        let emptyView = UIView().then { emptyView in
            self.backgroundView = emptyView
            emptyView.frame = CGRect(x: self.center.x, y: self.center.y, width: self.bounds.width, height: self.bounds.height)
        }
        let titleLabel = UILabel().then { titleLabel in
            emptyView.addSubview(titleLabel)
            titleLabel.text = title
            titleLabel.numberOfLines = 0
            titleLabel.textColor = .black
            titleLabel.font = .monospacedDigitSystemFont(ofSize: 25, weight: .light)
            titleLabel.backgroundColor = .clear
            titleLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview()
            }
        }
        
        let messageLabel = UILabel().then { messageLabel in
            emptyView.addSubview(messageLabel)
            messageLabel.text = message
            messageLabel.numberOfLines = 0
            messageLabel.textColor = .black
            messageLabel.font = .monospacedDigitSystemFont(ofSize: 20, weight: .light)
            messageLabel.backgroundColor = .clear
            messageLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.centerX.equalToSuperview()
            }
        }
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        
    }
}

extension Sequence {
    func removingDuplicates<T: Hashable>(withSame keyPath: KeyPath<Element, T>) -> [Element] {
        var seen = Set<T>()
        return filter { element in
            guard seen.insert(element[keyPath: keyPath]).inserted else { return false }
            return true
        }
    }
}
class TextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)

    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
