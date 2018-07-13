import UIKit

enum DeviceType: String {
    case undefined = "0"
    case android = "1"
    case ios = "2"
}

class Message: NSObject, NSCoding {
    var sender: String
    var text: String
    var received: Bool
    var date: Date
    var mesh: Bool
    var broadcast: Bool
    var deviceType: DeviceType
    
    override required public init() {
        self.sender = ""
        self.text = ""
        self.received = false
        self.date = Date()
        self.mesh = false
        self.broadcast = false
        self.deviceType = .undefined
    }
    
    required public init(coder decoder: NSCoder) {
        self.sender =  decoder.decodeObject(forKey: "sender") as! String
        self.text = decoder.decodeObject(forKey: "text") as! String
        self.received = Bool(decoder.decodeBool(forKey: "received") )
        self.date = decoder.decodeObject(forKey: "date") as! Date
        self.mesh = Bool(decoder.decodeBool(forKey: "mesh") )
        self.broadcast = Bool(decoder.decodeBool(forKey: "broadcast") )
        self.deviceType = DeviceType(rawValue: decoder.decodeObject(forKey: "type") as! String)!
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(self.sender, forKey: "sender")
        encoder.encode(self.text, forKey: "text")
        encoder.encode(self.received, forKey: "received")
        encoder.encode(self.date, forKey: "date")
        encoder.encode(self.mesh, forKey: "mesh")
        encoder.encode(self.broadcast, forKey: "broadcast")
        encoder.encode(self.deviceType.rawValue, forKey: "type")
    }
    
}
