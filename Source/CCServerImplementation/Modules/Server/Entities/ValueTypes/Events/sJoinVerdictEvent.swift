import GamePantry

public struct JoinVerdictEvent : GPEvent, GPSendableEvent, GPReceivableEvent {
    
    public let subjectName    : String
    public let isAdmitted     : Bool
    
    public let id             : String = "JoinVerdictEvent"
    public let purpose        : String = "Notify the server that the client-host has drafted a verdict for a player's join request"
    public let instanciatedOn : Date   = .now
    
    public var payload        : [String: Any] = [:]
    
    public init ( forName: String, verdict: Bool ) {
        subjectName = forName
        isAdmitted = verdict
    }
    
}

extension JoinVerdictEvent {
    
    public enum PayloadKeys : String, CaseIterable {
        case eventId     = "eventId",
             subjectName = "subjectName",
             isAdmitted  = "isAdmitted"
    }
    
    public func value ( for key: PayloadKeys ) -> Any? {
        payload[key.rawValue]
    }
    
}

extension JoinVerdictEvent {
    
    public func representedAsData () -> Data {
        dataFrom {
            [
                PayloadKeys.eventId.rawValue     : self.id,
                PayloadKeys.subjectName.rawValue : self.subjectName,
                PayloadKeys.isAdmitted.rawValue  : self.isAdmitted.description
            ]
        } ?? Data()
    }
    
}

extension JoinVerdictEvent {
    
    public static func construct ( from payload: [String : Any] ) -> JoinVerdictEvent? {
        guard 
            "JoinVerdictEvent" == payload[PayloadKeys.eventId.rawValue] as? String,
            let subjectName = payload[PayloadKeys.subjectName.rawValue] as? String,
            let isAdmitted  = Bool(payload[PayloadKeys.isAdmitted.rawValue] as? String ?? "false")
        else {
            return nil
        }
        
        return JoinVerdictEvent(forName: subjectName, verdict: isAdmitted)
    }
    
}
