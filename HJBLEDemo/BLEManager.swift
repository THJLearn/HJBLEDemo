//
//  BLEManager.swift
//  HJBLEDemo
//
//  Created by 赵优路 on 2020/4/24.
//  Copyright © 2020 thj. All rights reserved.
//

import Foundation
import CoreBluetooth
class BLEManager: NSObject {
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic?
    var peripheralManager: CBPeripheralManager?
    var names = [String]()
    var advertisementDatas = [[String : Any]]()
    var peripherals = [CBPeripheral]()
    var managerState:CBManagerState?
    var characteristics: [CBCharacteristic]?
    var selectBleData = SelectBleData()
    public static let shared = BLEManager()
    var centralScanBlok: (() -> ())?
    var discoverCharacteristicsForserviceBlok: (() -> ())?
    var didDiscoverServicesBlock: (() -> ())?
    
    
    public override init() {
        super.init()
        initBLE()
    }
    func initBLE() {
        centralManager = CBCentralManager.init(delegate: self, queue: nil)
    }
    /// 开始扫描
    func startScan() {
        switch managerState {
        case .poweredOn:
            centralManager?.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("error")
        }
        
    }
    /// 停止扫描
    func stopScan()  {
        centralManager?.stopScan()
    }
    /// 搜索服务特征
    func discoverCharacteristics(peripheral: CBPeripheral? = nil,for service: CBService)  {
        if peripheral == nil {
            selectBleData.peripheral?.discoverCharacteristics(nil, for: service)
        } else {
            peripheral?.discoverCharacteristics(nil, for: service)
        }
    }
    /// 发送数据
    func writeValue( peripheral: CBPeripheral? = nil, dict: [String : Any]?, characteristic: CBCharacteristic, type: CBCharacteristicWriteType = .withResponse)  {
        if peripheral == nil {
            selectBleData.peripheral?.writeValue(Parater.covertStringToData(str: "123") ?? Data(), for: characteristic, type: .withResponse)
        } else {
            peripheral?.writeValue(Parater.covertStringToData(str: "123") ?? Data(), for: characteristic, type: type)
        }
    }
}
struct SelectBleData {
    var name: String?
    var peripheral: CBPeripheral?
    var characteristics: [CBCharacteristic] = [CBCharacteristic]()
    var services: [CBService] = [CBService]()
}

extension BLEManager:CBCentralManagerDelegate {
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        managerState = centralManager?.state
        switch central.state {
        case .unknown:
            print("未知的")
        case .resetting:
            print("重置中")
        case .unsupported:
            print("不支持")
        case .unauthorized:
            print("未验证")
        case .poweredOff:
            print("未启动")
        case .poweredOn:
            print("可用")
             centralManager?.scanForPeripherals(withServices: nil, options: nil)
        default:
            print("error")
            
        }
    }
    
    /// 发现
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //        print(advertisementData)
            let peripheralName = peripheral.identifier.description
            let name =  peripheral.name ?? ""
            if !peripherals.contains(peripheral){
                print("centralManager--name------",peripheralName,"advertisementData--------",advertisementData)
                if  name.isEmpty {
                    names.append(peripheralName)
                } else {
                    names.append(name)
                }
                
                advertisementDatas.append(advertisementData)
                peripherals.append(peripheral)
                centralScanBlok?()
            }
        print(peripheral)
        print(advertisementData)
//        print(advertisementData)
        
    }
    /// 连接成功
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("连接外设成功！",peripheral.name ?? "");
        peripheral.delegate = self
        peripheral.discoverServices(nil)
    }
    /// 连接失败
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("失败了")
    }
    /// 断开
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("断开了")
    }
    //    /// 实现此代理重新连接  是需要在 background modes勾选 uses bluetooths LE accessories  权限
    //    func centralManager(_ central: CBCentralManager, willRestoreState dict: [String : Any]) {
    //
    //    }
    func centralManager(_ central: CBCentralManager, didUpdateANCSAuthorizationFor peripheral: CBPeripheral) {
        
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        
    }

    
}
extension BLEManager:CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("peripheral---name--",peripheral.name ?? "")
    }
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("peripheral---name--",peripheral.name ?? "")
    }
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        print("peripheral---0--",peripheral.name ?? "")
        selectBleData.services = peripheral.services ?? [CBService]()
        didDiscoverServicesBlock?()
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("peripheral--2---",peripheral.name ?? "")
        
        selectBleData.characteristics = service.characteristics ?? [CBCharacteristic]()
        discoverCharacteristicsForserviceBlok?()
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        print("--------didDiscoverIncludedServicesFor service--------")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("--------didDiscoverDescriptorsFor characteristic--------")
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print("--------didUpdateNotificationStateFor characteristi--4---")
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("--------didUpdateValueFor characteristi--4---")
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("--------didUpdateNotificationStateFor characteristi--4---")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if (error != nil) {
            print(error?.localizedDescription as Any)
        } else {
            print("xxxxxxxx写成功")
        }
    }
}
