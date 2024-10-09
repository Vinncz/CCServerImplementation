import GamePantry

/// Usable by both client-host and the server, to tell each other: that a player wants to join the room
public struct JoinRequestEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let subjectName    : String
    
    public let id             : String = "JoinRequestEvent"
    public let purpose        : String = "Notify the server and the client-host, that a player wants to join the room"
    public let instanciatedOn : Date   = .now
    
    public var payload : [String: Any] = [:]
    
    public init ( requestedBy: String ) {
        subjectName = requestedBy
    }
    
}

extension JoinRequestEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId     = "eventId",
             subjectName = "subjectName"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension JoinRequestEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue     : self.id,
                PayloadKeys.subjectName.rawValue : self.subjectName
            ]
        } ?? Data()
    }
    
}

extension JoinRequestEvent {
    
    public static func construct ( from payload: [String: Any] ) -> JoinRequestEvent? {
        guard 
            "JoinRequestEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let subjectName = payload[PayloadKeys.subjectName.rawValue] as? String 
        else {
            return nil
        }
        
        return JoinRequestEvent(requestedBy: subjectName)
    }
    
}
