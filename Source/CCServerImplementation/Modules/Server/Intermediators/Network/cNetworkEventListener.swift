import GamePantry

public class NetworkEventListener : GPGameEventListener {
    
    public weak var eventRouter: GPEventRouter?
    
    public init ( router: GPEventRouter ) {
        self.eventRouter = router
    }
    
    public func heardNews ( of: MCPeerID, to: MCSessionState ) {
        if !emit (
            GPAcquaintanceStatusUpdateEvent (
                subject : of, 
                status  : to
            )
        ) {
            debug("Failed to emit acquaintance event")
        }
    }
    
    public func heardData ( from peer: MCPeerID, _ data: Data ) {
        if let parsedData = EventParser.parse(data) {
            if !emit(parsedData) {
                debug("Events on the network are received but not shared via the event router")
            }
        }
    }
    
    public func heardIncomingStreamRequest ( from peer: MCPeerID, _ stream: InputStream, withContextOf context: String ) {
        fatalError("not implemented")
        
    }
    
    public func heardIncomingResourceTransfer ( from peer: MCPeerID, withContextOf context: String, withProgress progress: Progress ) {
        fatalError("not implemented")
        
    }
    
    public func heardCompletionOfResourceTransfer ( context: String, sender: MCPeerID, savedAt: URL?, withAccompanyingErrorOf: (any Error)? ) {
        fatalError("not implemented")
        
    }
    
    public func heardCertificate(from peer: MCPeerID, _ certificate: [Any]?, _ certificateHandler: @escaping (Bool) -> Void) {
        fatalError("not implemented")
        
    }
    
}

extension NetworkEventListener : GPEmitsEvents {
    
    public func emit ( _ event: GPEvent ) -> Bool {
        return eventRouter?.route(event) ?? false
    }
    
}
