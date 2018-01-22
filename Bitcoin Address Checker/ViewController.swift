//
//  ViewController.swift
//  Bitcoin Address Checker
//
//  Created by Carter Belisle on 12/9/17.
//  Copyright © 2017 Carter B. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var balanceLabel: UILabel!
    @IBOutlet var addressLABEL: UILabel!

    @IBOutlet var balance: UILabel!
    
    @IBOutlet var validateLabel: UILabel!
    @IBOutlet var address: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    
        corners.layer.cornerRadius = 10

    }
    @IBOutlet var corners: UIButton!
    
    @IBAction func validateClicked(_ sender: Any) {
        self.validateLabel.font = self.validateLabel.font.withSize(20)
        self.addressLABEL.text = ""
        self.validateLabel.text = ""
        self.balanceLabel.text = ""
        let addressText = address.text
        getStats(x: addressText!)
    }
    func getStats(x: String) -> String {
        print(x)
        let jsonUrlString = "https://api.blockcypher.com/v1/btc/main/addrs/" + x + "/balance"
        guard let url = URL(string: jsonUrlString) else { return x}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            
            do {
                guard let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] else { return }
                
                let keyExists = json["address"] != nil
                
                
                DispatchQueue.main.async(execute: {
                    if keyExists {
                        let address = json["address"]!
                        let addressReal = "\(address)"
                        let balance = json["balance"]!
                        let balanceINT = Double(("\(balance)"))
                        
                        let bitcoinAmount = balanceINT! / 100000000
                        
                        let balanceReal = String(bitcoinAmount) + " BTC"
                        
                        self.addressLABEL.text = "   " + addressReal + "   "
                        self.validateLabel.text = "   is valid!  "
                        self.balanceLabel.text = " " + balanceReal + " "
                        self.balance.text = "Balance:"
                        
                    }
                    else {
                        self.addressLABEL.text = ""
                        self.balance.text = ""
                        self.validateLabel.font = self.validateLabel.font.withSize(50)
                        self.validateLabel.text = "Not Valid!"
                        self.balanceLabel.text = ""
                    }
                })
                
                
            }catch let jsonErr {
                print("Error Serializing.", jsonErr)
            }
            
            
            
            
            
            }.resume()
        return x
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

