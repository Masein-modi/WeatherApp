//
//  ViewController.swift
//  WeatherApp
//
//  Created by Masein Mody on 4/3/18.
//  Copyright © 2018 Masein Mody. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var message = ""

    @IBOutlet weak var cityName: UITextField!
    @IBOutlet weak var messageLabel: UILabel!

    @IBAction func toSubmit(_ sender: Any) {
        let url = URL(string: "https://www.weather-forecast.com/locations/"+cityName.text!+"/forecasts/latest")
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request){
            data , request , error in
            if error != nil {
                print(error as Any)
            }else{
                if let unwrappedData = data{
                    let dataString = NSString(data: unwrappedData, encoding: String.Encoding.utf8.rawValue)
                    var stringSeperator = "<span class=\"b-forecast__table-description-title\">"
                    if let dataComponent = dataString?.components(separatedBy: stringSeperator){
                        if dataComponent.count > 1 {
                            stringSeperator = "<span class=\"phrase\">"
                            var tempString : NSString? = dataComponent[1] as NSString
                            if let newDataComponent = tempString?.components(separatedBy: stringSeperator){
                                stringSeperator = "</span>"
                                tempString = newDataComponent[1] as NSString
                                if let newNewDataComponent = tempString?.components(separatedBy: stringSeperator){
                                    self.message = newNewDataComponent[0].replacingOccurrences(of: "&deg;C", with: "℃")
                                }
                            }
                        }
                    }
                }
                if self.message == "" {
                    self.message = "The weather could'nt be found. "
                }
            }
            DispatchQueue.main.sync(execute: {
                self.messageLabel.text = self.message
            })
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
