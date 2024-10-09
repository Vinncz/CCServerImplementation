import GamePantry

public struct CommenceGameStartEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let signingKey     : String
    
    public let id             : String = "CommenceGameStartEvent"
    public let purpose        : String = "Only sent by client-host to server, indicating that it require for the game to be commenced"
    public let instanciatedOn : Date   = .now
    
    public var payload        : [String : Any] = [:]
    
    public init ( authorizedBy: String ) {
        signingKey = authorizedBy
    }
    
}

extension CommenceGameStartEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId    = "eventId",
             signingKey = "signingKey"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension CommenceGameStartEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue    : self.id,
                PayloadKeys.signingKey.rawValue : self.signingKey
            ]
        } ?? Data()
    }
    
}

extension CommenceGameStartEvent {
    
    public static func construct ( from payload: [String : Any] ) -> CommenceGameStartEvent? {
        guard
            "CommenceGameStartEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let signingKey = payload[PayloadKeys.signingKey.rawValue] as? String
        else {
            return nil
        }
        
        return CommenceGameStartEvent(authorizedBy: signingKey)
    }
    
}
