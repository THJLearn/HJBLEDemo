//
//  BleDetailViewController.swift
//  HJBLEDemo
//
//  Created by 赵优路 on 2020/4/24.
//  Copyright © 2020 thj. All rights reserved.
//

import UIKit

class BleDetailViewController: UIViewController {

   override func viewDidLoad() {
            super.viewDidLoad()
            self.title = "services list"
            setupUI()
            BLEManager.shared.didDiscoverServicesBlock = { [weak self] in
               self?.tableView.reloadData()
           }
        }
        fileprivate func setupUI() {
            self.view.addSubview(self.tableView)
            tableView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
            tableView.reloadData()
        }
        lazy var tableView: UITableView = {
            let view = UITableView(frame: .zero, style: .plain)
            view.delegate = self
            view.dataSource = self
            view.separatorStyle = .none
            view.backgroundColor = UIColor.white
            view.tableFooterView = UIView()
            return view
        }()

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension BleDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let service  = BLEManager.shared.selectBleData.services[indexPath.row]
        self.navigationController?.pushViewController(BleCharacteristicsViewController(), animated: true)
        BLEManager.shared.discoverCharacteristics(for: service)
    }
}
extension BleDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BLEManager.shared.selectBleData.services.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        ///CBCharacteristic
        let service = BLEManager.shared.selectBleData.services[indexPath.row]
        cell.textLabel?.text = (BLEManager.shared.selectBleData.name ?? "")  + service.uuid.uuidString
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
}
