//
//  BLEManager.swift
//  HJBLEDemo
//
//  Created by 赵优路 on 2020/4/24.
//  Copyright © 2020 thj. All rights reserved.
//

import Foundation
import CoreBluetooth
enum BLEUUIDTYPE {
    case DeviceInformation //= "180A"
    case CurrentTime // = "1805"
    case Battery //= "180F"
}

class BLEManager: NSObject {
    var centralManager: CBCentralManager?
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
    var didUpdateValueForCharacteristicBlok: ((_ info:Any) -> ())?
    
    
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
    func cancelPeripheralConnection(){
        if let peripheral = selectBleData.peripheral {
            centralManager?.cancelPeripheralConnection(peripheral)
        }
        
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
        
//        let data = Parater.covertStringToData(str: "thjde") ?? Data()
        let data = Parater.covertDicToData(dic: dict) ?? Data()
        /// Parater.covertStringToData(str: "123") ?? Data()
        if peripheral == nil {
            selectBleData.peripheral?.writeValue(data, for: characteristic, type: .withResponse)
        } else {
            peripheral?.writeValue(data, for: characteristic, type: type)
        }
    }
    /// 获取设备版本号
    func getVersion(characteristic: CBCharacteristic) {
        let  data = Tool().hex(toBytes: "088573")
        selectBleData.peripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }
    
    /// 获取电量
    func getBattery(characteristic: CBCharacteristic) {
        
        let  data = Tool().hex(toBytes: "88096F")
        selectBleData.peripheral?.writeValue(data, for: characteristic, type: .withResponse)
    }
}
struct SelectBleData {
    var name: String?
    var peripheral: CBPeripheral?
    var characteristic: CBCharacteristic!
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
            print("++++state+++error")
            
        }
    }
    
    /// 发现
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        //        print(advertisementData)
       
//        if peripheralName == "747E8675-6040-B183-6F5A-4FFF5F7505B4" ||  name == "iPhone" {
        
            if !peripherals.contains(peripheral){
                let peripheralName = peripheral.identifier.uuidString
                       var name =  peripheral.name ?? ""
                       print(peripheralName,"name==",name)
                
                if  name.isEmpty {
                    name = peripheralName
                }
                
                if  let arr =  advertisementData["kCBAdvDataServiceUUIDs"] as? Array<CBUUID>  {
                    print("##########################")
                    for cuuuid in  arr {
                        if cuuuid.uuidString == "CDD1" {
                            name = "想要的Ble"
                        }
                    }
                    
                }
                names.append(name)
            
                advertisementDatas.append(advertisementData)
                peripherals.append(peripheral)
                centralScanBlok?()
                print("****************** centralManager")
                print("--------peripheral-------",peripheral)
                print("--------peripheral services-------",peripheral.services ?? [CBService]())
                print("--------advertisementData-------",advertisementData)
                print("--------rssi-------",RSSI)
                
                print(" centralManager *******************")
                
            }
            
//        }
        
        
        
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
        print("--------didUpdateANCSAuthorizationFor --")
    }
    
    func centralManager(_ central: CBCentralManager, connectionEventDidOccur event: CBConnectionEvent, for peripheral: CBPeripheral) {
        print("--------connectionEventDidOccur --")
    }
    
    
}
extension BLEManager:CBPeripheralDelegate {
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("-------- peripheral---->1 didModifyServices --------   ")
    }
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("---------------- peripheral---->2 peripheralDidUpdateName ----------")
    }
    func peripheralIsReady(toSendWriteWithoutResponse peripheral: CBPeripheral) {
        print("----------------peripheral---->3 toSendWriteWithoutResponse ----------")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("----------------peripheral---->4 didDiscoverServices ----------")
        selectBleData.services = peripheral.services ?? [CBService]()
        print(peripheral.services as Any)
        
//        for serv in (peripheral.services ?? [CBService]()) {
//
//            if serv.uuid.uuidString == "CDD1" {
//                selectBleData.services = [serv]
//            }
//        }
        didDiscoverServicesBlock?()
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("----------------peripheral---->5 didDiscoverCharacteristicsFor ----------")
        print(service.characteristics as Any)
        selectBleData.characteristics = service.characteristics ?? [CBCharacteristic]()
        discoverCharacteristicsForserviceBlok?()
        for character in service.characteristics! {
            if character.uuid.uuidString == "CDD2" {
                peripheral.setNotifyValue(true, for: character)
                 peripheral.readValue(for: character)
            }
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        print("----------------peripheral---->6 didDiscoverIncludedServicesFor ----------")
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("----------------peripheral---->7 didDiscoverDescriptorsFor characteristic----------")
        print(characteristic)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        print("----------------peripheral---->8 didUpdateValueFor descriptor----------")
        print(descriptor)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("----------------peripheral---->9 didUpdateValueFor characteristic----------")
        print(characteristic)
        if let vaue = characteristic.value {
           let info = String.init(data: vaue, encoding: String.Encoding.utf8)
            print("读到的数据为------",info as Any)
            didUpdateValueForCharacteristicBlok?(info)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        print("----------------peripheral---->10 didUpdateNotificationStateFor characteristic----------")
        
        print(characteristic)
        if let vaue = characteristic.value {
            var infoBytes = [UInt8](vaue)
            var infoVal:Int = Int.init(infoBytes[0])
            NSLog("获取的值为：%d\n", infoVal)
        }
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("----------------peripheral---->11 didWriteValueFor descriptor----------")
        print(descriptor)
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        print("----------------peripheral---->12 didWriteValueFor characteristic----------")
        if (error == nil) {
            print("xxxxxxxx写成功")
        } else {
            print(error as Any)
            print(error?.localizedDescription as Any)
        }
    }
}

extension CBUUID {
    
}
