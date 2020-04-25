//
//  BLEConnectSuccessViewController.swift
//  HJBLEDemo
//
//  Created by 赵优路 on 2020/4/24.
//  Copyright © 2020 thj. All rights reserved.
//

import UIKit

class BLEConnectSuccessViewController: UIViewController {

    @IBOutlet weak var contentTF: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        BLEManager.shared.didUpdateValueForCharacteristicBlok = { [weak self] (info) in
            
            self?.resultLabel.text = info as? String
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func sendAction(_ sender: Any) {
        contentTF.resignFirstResponder()
        let content = (contentTF.text ?? "").isEmpty ? "thjtest" :  contentTF.text
        BLEManager.shared.writeValue(dict: ["content": content as Any ], characteristic: BLEManager.shared.selectBleData.characteristic)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        contentTF.resignFirstResponder()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
