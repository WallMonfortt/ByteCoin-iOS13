//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

//UIPickerViewDataSource is used to handle the picker
class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, CoinManagerDelegate {
    func didUpdateCoinPrice(price: String, currency: String) {
        DispatchQueue.main.async {
            self.bitCoinLabel.text = price
            self.currencyLabel.text = currency
        }
    }
    
    func didFailWithError(_ error: any Error) {
        print(error)
    }
    
    
//    UIPickerViewDelegate is for interact with the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
//        This method is for determine how many columns we want in our picker.
    }
    
    var coinManager = CoinManager()
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
//        This is for how many rows this picker should have using the pickerView:numberOfRowsInComponent: method.
    }
    

    @IBOutlet weak var bitCoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPcker: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        coinManager.delegate = self
        currencyPcker.dataSource = self
        currencyPcker.delegate = self
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(coinManager.currencyArray[row])
        let currencyName = coinManager.currencyArray[row]
        print(row)
        coinManager.getCoinPrice(for: currencyName)
    }


}
