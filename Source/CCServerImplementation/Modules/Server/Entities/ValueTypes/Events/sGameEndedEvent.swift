import GamePantry

public struct GameEndedEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let effectiveOn     : String
    
    public let id              : String = "GameEndedEvent"
    public let purpose         : String = "Notify the client that the game had ended"
    public let instanciatedOn  : Date   = .now
    
    public var payload         : [String : Any] = [:]
    
    public init ( effectiveOn activeOn: Date ) {
        effectiveOn = activeOn.ISO8601Format()
    }
    
}

extension GameEndedEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId     = "eventId",
             effectiveOn = "effectiveOn"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension GameEndedEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue     : self.id,
                PayloadKeys.effectiveOn.rawValue : self.effectiveOn
            ]
        } ?? Data()
    }
    
}

extension GameEndedEvent {
    
    public static func construct ( from payload: [String : Any] ) -> GameEndedEvent? {
        guard
            "GameEndedEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let effectiveOn = payload[PayloadKeys.effectiveOn.rawValue] as? String
        else {
            return nil
        }
        
        let dateFormatter = ISO8601DateFormatter()
        guard let effectiveOn = dateFormatter.date(from: effectiveOn) else {
            return nil
        }
        
        return GameEndedEvent(effectiveOn: effectiveOn)
    }
    
}
