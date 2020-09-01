import Foundation
import CoreBluetooth



class BluetoothManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var cbCentralManager: CBCentralManager!
    var targetPeripheral: CBPeripheral? = nil
    var mouseInfoCharacteristic: CBCharacteristic? = nil
    var mouseActionCharacteristic: CBCharacteristic? = nil
    var targetDescriptor: CBDescriptor? = nil
    let serviceUUID = [CBUUID(string: "d84315a7-3e95-4da6-8110-c28285cd8e2b")]
    let mouseInfoCharacteristicUUID = CBUUID(string: "c7e75734-e6ab-11ea-adc1-0242ac120002")
    let mouseActionCharacteristicUUID = CBUUID(string: "b8a71aee-4e1c-4f4f-91da-4e10ce658cb0")
    let cccdUUID = CBUUID(string: CBUUIDClientCharacteristicConfigurationString)
    
    var listener: BluetoothListener
    
    init (listener: BluetoothListener) {
        self.listener = listener
        super.init()
        cbCentralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOff:
            print("POWERED OFF")
            break
        case .poweredOn:
            print("POWERED ON")
            self.scan()
            break
        case .resetting:
            print("RESETTING")
            break
        case .unauthorized:
            print("UN Authorized")
            break
        case .unknown:
            print("unknown")
            break
        case .unsupported:
            print("not supported")
            break
        default:
            print("?")
        }
    }

    func scan() {
        if (!cbCentralManager.isScanning) {
            print("start scan")
            self.targetPeripheral = nil
            self.mouseInfoCharacteristic = nil
            self.mouseActionCharacteristic = nil
            self.targetDescriptor = nil
            cbCentralManager.scanForPeripherals(withServices: serviceUUID, options: nil)
        } else {
            print("doing scan...")
        }

    }
    
    // call this when manager found peripheral devices
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("found peripheral devices")
        print("next, it try to connecting to peripheral device...")
        self.targetPeripheral = peripheral
        self.cbCentralManager.connect(self.targetPeripheral!, options: nil)
        cbCentralManager.stopScan()
    }
    
    
    // call this when self connect to peripheral device
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("succeeded connecting")
        print("next, it try to discovering service...")
        targetPeripheral?.delegate = self  // サーバから何かある度にイベントを受け取れるようにデリゲートをセット
        targetPeripheral?.discoverServices(serviceUUID)
    }
    
    // call this when it discovered services
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("failed discovering services")
            print(error!)
            return
        }
        
        print("found any services")
        print("service count: ", peripheral.services?.count ?? 0)
        for service in peripheral.services ?? [] {
            if(service.uuid.uuidString == serviceUUID[0].uuidString) {
                targetPeripheral?.discoverCharacteristics(nil, for: service)
             }
        }
        print("next, it try to discovering characteristics...")
    }
    
    
    // call this when it discovered characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("found any characteristics")
        print("characteristic count:", service.characteristics!.count)
        for characreristic in service.characteristics!{
            switch characreristic.uuid {
                
            case mouseInfoCharacteristicUUID:
                self.mouseInfoCharacteristic = characreristic
                self.targetPeripheral?.discoverDescriptors(for: characreristic)
                break
                
            case mouseActionCharacteristicUUID:
                self.mouseActionCharacteristic = characreristic
                self.targetPeripheral?.discoverDescriptors(for: characreristic)
                break
                
            default:
                break
            }
        }
        print("next, it try to discovering descriptors...")
    }
    
    // call this when it discovered descriptors
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        print("found any descriptors")
        for descriptor in characteristic.descriptors ?? [] {
            if descriptor.uuid == cccdUUID {
                print("exist cccd")
                self.setNotify(targetChara: characteristic)
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnect")
        self.scan()
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("connection failed")
        self.scan()
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("failed writing process")
            print(error!)
            return
        }
        
        print("write value", characteristic.value ?? "NULL")
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        for service in invalidatedServices {
            print("modify service - service UUID: \(service.uuid)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let e = error {
            print("Error: on update value", e)
            return
        }
        
        switch characteristic.uuid {
        case mouseInfoCharacteristicUUID:
            if let data = characteristic.value {
                self.listener.notifyCursor(data: data)
            } else {
                print("Characteristic data: NONE")
            }
            break
        
        case mouseActionCharacteristicUUID:
            if let data = characteristic.value {
                self.listener.notifyAction(data: data)
            } else {
                print("Characteristic data: NONE")
            }
            break
            
        default:
            break
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if let e = error {
            print("Error: on update notification state for")
            print(e)
            return
        }

        print("OK: Update enable notification state")
    }
    
    func setNotify(targetChara: CBCharacteristic) {
        if (targetChara.isNotifying == false) {
            self.targetPeripheral?.setNotifyValue(true, for: targetChara)
        } else {
            print("the characteristic is already notifying");
        }
    }
    
    func disconnect() {
        self.cbCentralManager.cancelPeripheralConnection(self.targetPeripheral!)
    }
}
