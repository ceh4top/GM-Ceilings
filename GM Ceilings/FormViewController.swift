//
//  FormViewController.swift
//  GM Ceilings
//
//  Created by GM on 09.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate {
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var clientName: UITextField!
    @IBOutlet weak var clientNameLabel: UILabel!
    
    @IBOutlet weak var clientPhone: UITextField!
    @IBOutlet weak var clientPhoneLable: UILabel!
    
    @IBOutlet weak var clientAddress: UITextField!
    @IBOutlet weak var clientaApartmentNumber: UITextField!
    
    var datePickerView : UIDatePicker! = UIDatePicker()
    @IBOutlet weak var clientDate: UITextField!
    
    var timePickerView : UIPickerView! = UIPickerView()
    var timeArray : [String] = []
    @IBOutlet weak var clientTime: UITextField!
    @IBOutlet weak var clientTimeLabel: UILabel!
    
    @IBOutlet weak var sendData: UIButton!
    
    var focusTextField : UITextField? = nil
    
    var clientAddressMap : String? {
        didSet {
            sendAddress()
        }
    }
    
    var hideScroll : Bool = true
    var constraint = CGFloat(0)
    let user = UserDefaults.getUser()
    
    func datePickerValueChanged(sender:UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        clientDate.text = dateFormatter.string(from: sender.date)
        getTimes(date: clientDate.text!)
    }
    
    @IBAction func touchUpSendData(_ sender: Any) {
        sendDataForServer()
    }
    
    func sendDataForServer() {
        var success = 0
        var parameters: [String : String] = ["Type":"Client"]
        
        if user.login == "" {
            if (clientPhone.text == "") {success = 1}
            
            let phone = clientPhone.text!
            if phone.characters.count < 11 || phone.characters.count > 12 {
                success = 1
            }
        }
        
        if clientTime.text == "" {
            success = 1
        }
        
        if success == 0 {
            if user.login != "" {
                parameters.updateValue(user.id.description, forKey: "user_id")
            }
            else {
                parameters.updateValue(clientName.text!, forKey: "name")
                parameters.updateValue(clientPhone.text!, forKey: "phone")
            }
            
            parameters.updateValue(clientAddress.text!, forKey: "address")
            parameters.updateValue(clientaApartmentNumber.text!, forKey: "apartmentNumber")
            parameters.updateValue(clientDate.text!, forKey: "date")
            parameters.updateValue(clientTime.text!, forKey: "time")
            
            if !Geoposition.isEmpty {
                parameters.updateValue(Geoposition.latitude!.description, forKey: "latitude")
                parameters.updateValue(Geoposition.longitude!.description, forKey: "longitude")
            }
            
            sendDataComplite(parameters: parameters)
        }
        else if success == 1
        {
            Message.Show(title: "Введите данные", message: "Введены не все данные или неправильно. Проверте данные и исправьте", controller: self)
        }
    }
    
    func getTimes(date: String) {
        guard let urlPath = URL(string: "http://test1.gm-vrn.ru/index.php?option=com_gm_ceiling&task=api.getTimes") else { return }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let data = ["date":date]
        guard let httpBody = try? JSONSerialization.data(withJSONObject: data, options: []) else { return }
        
        request.httpBody = httpBody
        
        if !InternetConnection.isConnectedToNetwork() {
            InternetConnection.messageConnection(controller: self)
        }
        else {
            Helper.execTask(request: request) { (status, json) in
                DispatchQueue.main.async {
                    var title = "Сервер не отвечает"
                    var message = "Сервер не отвечает, попробуйте позже."
                    if status {
                        Log.msg(json as Any)
                        if let answerStatus = json?["status"] as? String {
                            if answerStatus == "success" {
                                if let array = json?["times"] as? [String] {
                                    self.timeArray = array
                                    if self.timeArray.count == 0 {
                                        Message.Show(title: "Нет замерщиков", message: "К сожалению на эту дату нет замерщиков, выберите другую дату", controller: self)
                                        self.clientTime.text = ""
                                        self.clientTime.isHidden = true
                                    } else {
                                        self.clientTime.text = self.timeArray[0]
                                        self.timePickerView.selectRow(0, inComponent: 0, animated: false)
                                        self.clientTime.isHidden = false
                                    }
                                }
                            } else {
                                
                                if let t = json?["title"] as? String {
                                    title = t
                                }
                                
                                if let m = json?["message"] as? String {
                                    message = m
                                }
                                
                                Message.Show(title: title, message: message, controller: self)
                            }
                        }
                        
                    }
                    else {
                        Message.Show(title: title, message: message, controller: self)
                    }
                }
            }
        }
    }
    
    func sendDataComplite(parameters: [String : String]) {
        guard let urlPath = URL(string: "http://test1.gm-vrn.ru/index.php?option=com_gm_ceiling&task=api.addNewClient") else { return }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        request.httpBody = httpBody
        
        if !InternetConnection.isConnectedToNetwork() {
            InternetConnection.messageConnection(controller: self)
        }
        else {
            Helper.execTask(request: request) { (status, json) in
                DispatchQueue.main.async {
                    var title : String = ""
                    var message : String = ""
                    var flagBack : Bool = false
                    
                    if status {
                        Log.msg(json as Any)
                        if let statusAnswer = json?["status"] as? String {
                            if statusAnswer == "success" {
                                if self.user.login == "" {
                                    
                                    if let answer = json?["answer"] as? [String : Any] {
                                        if let id = answer["user_id"] as? String {
                                            self.user.id = id
                                        }
                                        if let LP = answer["username"] as? String {
                                            self.user.login = LP
                                            self.user.password = LP
                                        }
                                        if let projectId = answer["project_id"] as? String {
                                            self.measurmentId = projectId
                                        }
                                        self.user.changePassword = false
                                        
                                        UserDefaults.setUser(self.user)
                                    }
                                    
                                    self.clientNameLabel.isHidden = true
                                    self.clientName.isHidden = true
                                    self.clientPhoneLable.isHidden = true
                                    self.clientPhone.isHidden = true
                                }
                                
                                if !self.user.changePassword {
                                    self.performSegue(withIdentifier: "showProfile", sender: self)
                                }
                                else {
                                    flagBack = true
                                }
                                self.saveDataForDB()
                            }
                        }
                        
                        if let t = json?["title"] as? String {
                            title = t
                        }
                        if let m = json?["message"] as? String {
                            message = m
                        }
                    }
                    else {
                        title = "Сервер не отвечает"
                        message = "Сервер не отвечает, попробуйте позже."
                    }
                    
                    Message.Show(title: title, message: message, controller: self)
                    
                    if flagBack {
                        if let nvc = self.navigationController {
                            nvc.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func sendAddress() {
        self.clientAddress?.text = clientAddressMap
    }
    
    var measurmentId = "0"
    func saveDataForDB() {
        let measurment = Measurement()
        measurment.address = self.clientAddress.text! + " кв. " + self.clientaApartmentNumber.text!
        measurment.projectId = measurmentId
        measurment.status = "Ждет замера"
        measurment.dateTime = self.clientDate.text! + " " + self.clientTime.text!
        measurment.projectSum = ""
        
        CoreDataManager.instance.saveContext()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.constraint = self.bottomConstraint.constant
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        self.tabBarController?.tabBar.isHidden = true
        
        let tooBar: UIToolbar = UIToolbar()
        tooBar.items=[
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil),
            UIBarButtonItem.init(title: "ОК", style: UIBarButtonItemStyle.done, target: self, action: #selector(hideKeyboard))]
        tooBar.sizeToFit()
        
        self.clientName.delegate = self
        self.clientAddress.delegate = self
        self.clientPhone.delegate = self
        self.clientDate.delegate = self
        self.clientTime.delegate = self
        self.clientaApartmentNumber.delegate = self
        
        if user.login != "" {
            self.clientName.isHidden = true
            self.clientNameLabel.isHidden = true
            self.clientPhone.isHidden = true
            self.clientPhoneLable.isHidden = true
        }
        
        self.clientName.inputAccessoryView = tooBar
        self.clientAddress.inputAccessoryView = tooBar
        self.clientTime.inputAccessoryView = tooBar
        self.clientDate.inputAccessoryView = tooBar
        self.clientPhone.inputAccessoryView = tooBar
        self.clientaApartmentNumber.inputAccessoryView = tooBar
        
        self.datePickerView.datePickerMode = UIDatePickerMode.date
        self.datePickerView.addTarget(self, action: #selector(datePickerValueChanged), for: UIControlEvents.valueChanged)
        self.datePickerView.locale = Locale.init(identifier: "ru")
        let currentDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())
        self.datePickerView.date = currentDate!
        self.datePickerView.minimumDate = currentDate
        
        self.timePickerView.delegate = self
        
        self.clientDate.inputView = self.datePickerView
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        clientDate.text = dateFormatter.string(from: currentDate!)
        getTimes(date: self.clientDate.text!)
        
        self.timeArray = timeCreate(firstTime: 9, lastTime: 21)
        
        self.clientTime.inputView = self.timePickerView
        self.clientTime.text = timeArray[0]
        
        self.scrollView.delegate = self
        
        sendAddress()
    }
    
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        self.tabBarController?.tabBar.isHidden = false
        super.willMove(toParentViewController: parent)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Agreement" {
            if let fvc = segue.destination as? BrowserViewController {
                fvc.URL = NSURL(string: "http://calc.gm-vrn.ru/index.php?option=com_gm_ceiling&view=info&type=termsofuse")
                fvc.NavTitle = "Соглашение"
            }
        }
        self.navigationItem.title = "Ваши данные"
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if hideScroll {
            self.view.endEditing(true)
        }
    }
    
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if hideScroll {
            self.view.endEditing(true)
        }
        hideScroll = true
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.timeArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        return self.timeArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.clientTime.text = self.timeArray[row]
    }
    
    func timeCreate(firstTime: Int, lastTime: Int) -> [String] {
        var timeArray: [String] = []
        
        for hour in firstTime...lastTime {
            timeArray.append("\(hour):00")
        }
        
        return timeArray
    }
    
    func keyboardWillShow(notification:NSNotification) {
        adjustingHeight(show: true, notification: notification)
    }
    
    func keyboardWillHide(notification:NSNotification) {
        adjustingHeight(show: false, notification: notification)
    }
    
    func adjustingHeight(show: Bool, notification: NSNotification) {
        if show {
            if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            {
                if self.focusTextField != nil {
                    let sizeText = self.focusTextField!.frame.origin.y
                    let heightText = self.focusTextField!.frame.height
                    
                    let sizeView = self.view.bounds.height
                    
                    self.view.frame.origin.y = min(sizeView - (keyboardSize.height + sizeText + heightText + 100), 0)
                }
            }
        }
        else {
            self.view.frame.origin.y = 0
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField {
        case clientPhone:
            return Helper.checkStringByPhone(string: (textField.text?.appending(string))!)
        default:
            return true
        }
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.focusTextField = textField
        return true
    }
}
