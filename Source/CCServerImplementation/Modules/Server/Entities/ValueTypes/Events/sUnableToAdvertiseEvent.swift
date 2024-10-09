import GamePantry

public struct UnableToAdvertiseEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let cause          : String
    
    public let id             : String = "UnableToAdvertiseEvent"
    public let purpose        : String = "Notify the server and the client-host, that the room they're hosting, is unable to be discovered in the network"
    public let instanciatedOn : Date   = .now
    
    public var payload        : [String: Any] = [:]
    
    public init ( dueTo: String ) {
        cause = dueTo
    }
    
}

extension UnableToAdvertiseEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId = "eventId",
             error   = "error"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension UnableToAdvertiseEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue : self.id,
                PayloadKeys.error.rawValue   : self.cause
            ]
        } ?? Data()
    }
    
}

extension UnableToAdvertiseEvent {
    
    public static func construct ( from payload: [String : Any] ) -> UnableToAdvertiseEvent? {
        guard 
            "UnableToAdvertiseEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let errorMsg = payload[PayloadKeys.error.rawValue] as? String
        else {
            return nil
        }
        
        return UnableToAdvertiseEvent(dueTo: errorMsg)
    }
    
}
