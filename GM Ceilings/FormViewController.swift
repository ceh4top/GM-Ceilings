//
//  FormViewController.swift
//  GM Celings
//
//  Created by GM on 09.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var check: UISwitch!
    @IBOutlet weak var clientName: UITextField!
    @IBOutlet weak var clientPhone: UITextField!
    @IBOutlet weak var clientAddress: UITextField!
    @IBOutlet weak var clientaApartmentNumber: UITextField!
    @IBOutlet weak var clientDataTime: UIDatePicker!
    @IBOutlet weak var sendData: UIButton!
    
    var clientAddressMap : String? {
        didSet {
            sendAddress()
        }
    }
    @IBAction func touchUpSendData(_ sender: Any) {
        sendDataForServer()
    }
    
    func sendDataForServer() {
        var success = 0
        var parameters: [String : String] = ["Type":"Client"]
        
        if (clientName.text == "") {success = 1}
        if (clientPhone.text == "") {success = 1}
        if (clientAddress.text == "") {success = 1}
        
        let phone = clientPhone.text!
        if phone.characters.count < 10 || phone.characters.count > 12 {
            success = 1
        }
        
        if !check.isOn {
            Message.Show(title: "Соглашение", message: "Для записи на замер, нам нужно согласие на обработку ваших данных", controller: self)
            success = 2
        }
        
        if success == 0 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
            let strDate = dateFormatter.string(from: clientDataTime.date)
            
            parameters.updateValue(clientName.text!, forKey: "Name")
            parameters.updateValue(clientPhone.text!, forKey: "Phone")
            parameters.updateValue(clientAddress.text!, forKey: "Address")
            parameters.updateValue(clientaApartmentNumber.text!, forKey: "ApartmentNumber")
            parameters.updateValue(strDate, forKey: "Date")
            
            sendDataComplite(parameters: parameters)
        }
        else if success == 1
        {
            Message.Show(title: "Введите данные", message: "Введены не все данные или неправильно. Проверте данные и исправьте", controller: self)
        }
    }
    
    func sendDataComplite(parameters: [String : String]) {
        guard let urlPath = URL(string: "http://test1.gm-vrn.ru/index.php?option=com_gm_ceiling&task=api.addNewClient") else { return }
        
        var request = URLRequest(url: urlPath)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        
        request.httpBody = httpBody
        
        execTask(request: request) { (status, json) in
            print("Answer: \(json)")
            DispatchQueue.main.async {
                var title : String = ""
                var message : String = ""
                
                if status == 1 {
                    title = "Нет подключения к интернету"
                    message = "Для успешной работы приложения, необходимо быть подключенным к сети интернет."
                }
                else if status == 2 {
                    if let t = json?["title"] as? String {
                        title = t
                    }
                    if let m = json?["message"] as? String {
                        message = m
                    }
                    self.saveDataForDB()
                }
                else if status == 3 {
                    title = "Сервер не отвечает"
                    message = "Сервер не отвечает, попробуйте позже."
                }
                
                Message.Show(title: title, message: message, controller: self)
            }
        }
        
    }
    
    func sendAddress() {
        self.clientAddress?.text = clientAddressMap
    }
    
    func saveDataForDB() {
        let measurment = EMeasurement()
        measurment.address = clientAddress.text
        measurment.dateTimeMeasurement = clientDataTime.date as NSDate?
        
        let user = EUser()
        user.name = clientName.text
        user.phone = clientPhone.text
        user.addToMeasurement(measurment)
        
        CoreDataManager.instance.saveContext()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendAddress()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func execTask(request: URLRequest, taskCallback: @escaping (Int,
        AnyObject?) -> ()) {
        if !InternetConnection.isConnectedToNetwork() {
            taskCallback(1, nil)
            return
        }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
            if let data = data {
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    let json = try? JSONSerialization.jsonObject(with: data, options: [])
                    taskCallback(2, json as AnyObject?)
                } else {
                    taskCallback(3, nil)
                }
            }
        }).resume()
    }
}
