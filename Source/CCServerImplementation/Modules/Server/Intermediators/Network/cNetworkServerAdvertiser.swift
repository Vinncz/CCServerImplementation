import GamePantry

public class GameServerAdvertiser : GPGameServerAdvertiser {
    
    public var eventRouter : GPEventRouter?
    
    public init ( serves: MCPeerID, config: GPGameProcessConfiguration, router: GPEventRouter ) {
        super.init(serves: serves, serviceType: config.serviceType)
    }
    
    public func unableToAdvertise ( error: any Error ) {
        if !emit (
            UnableToAdvertiseEvent (
                dueTo: error.localizedDescription
            )
        ) {
            debug("Failed to tell the system that advertising failed with error: \(error)")
        }
    }

    public func didReceiveAdmissionRequest ( from peer: MCPeerID, withContext: Data?, admitterObject: @escaping (Bool, MCSession?) -> Void ) {
        if !emit (
            JoinRequestEvent (
                requestedBy: peer.displayName
            )
        ) {
            debug("Failed to tell the system that a request to admit \(peer.displayName) was received")
        }
    }
    
}

extension GameServerAdvertiser : GPEmitsEvents {
    
    public func emit ( _ event: any GamePantry.GPEvent ) -> Bool {
        eventRouter?.route(event) ?? false
    }
    
}
