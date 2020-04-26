//
//  BleViewController.swift
//  HJBLEDemo
//
//  Created by 赵优路 on 2020/4/24.
//  Copyright © 2020 thj. All rights reserved.
//

import UIKit
class BleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        BLEManager.shared.startScan()
        BLEManager.shared.centralScanBlok = { [weak self] in
            self?.tableView.reloadData()
        }
        
//        centralManager = CBCentralManager.init(delegate: self, queue: nil)
        // Do any additional setup after loading the view.
    }
    deinit {
        BLEManager.shared.cancelPeripheralConnection()
        BLEManager.shared.names.removeAll()
        BLEManager.shared.peripherals.removeAll()
        BLEManager.shared.selectBleData =  SelectBleData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BLEManager.shared.names.removeAll()
        BLEManager.shared.peripherals.removeAll()
        BLEManager.shared.startScan()
//        BLEManager.shared.cancelPeripheralConnection()
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

}
extension BleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BLEManager.shared.names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = BLEManager.shared.names[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44;
    }
    
}
extension BleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// 停止扫描
        BLEManager.shared.stopScan()
        let peripheral = BLEManager.shared.peripherals[indexPath.row]
        BLEManager.shared.selectBleData.name = peripheral.name
        BLEManager.shared.selectBleData.peripheral = peripheral
        BLEManager.shared.centralManager?.connect(peripheral, options: nil)
        self.navigationController?.pushViewController(BleDetailViewController(), animated: true)
    }
}
