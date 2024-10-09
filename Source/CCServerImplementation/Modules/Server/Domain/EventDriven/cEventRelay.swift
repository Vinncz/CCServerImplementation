import GamePantry

public class EventRelay {
    
    public weak var coordinator : CompositionRoot?
    public weak var eventRouter : GamePantry.GPEventRouter?
    public var subscriptions    : Set<AnyCancellable>
    
    public init ( router: GPEventRouter ) {
        self.eventRouter   = router
        self.subscriptions = []
    }
    
}

extension EventRelay : GPHandlesEvents {
    
    public func placeSubscription ( on eventType: any GamePantry.GPEvent.Type ) {
        eventRouter?.subscribe(to: eventType)?.sink { event in
            self.handle(event)
        }.store(in: &subscriptions)
    }
    
    private func handle ( _ event: GPEvent ) {
        if let event = event as? any GPSendableEvent {
            relayToClientHost(event)
        } else {
            debug("Unhandled event: \(event)")
        }
    }
    
}

extension EventRelay {
    
    private func relayToClientHost ( _ event: any GPSendableEvent ) {
        if let clientHost = findClientHost() {
            try? coordinator?
                    .networkManager
                    .eventBroadcaster
                    .broadcast (
                        event.representedAsData(), 
                        to: [clientHost]
                    )
        }
    }
    
    private func findClientHost() -> MCPeerID? {
        // TODO: Use case need not to know about the internal structure of the coordinator
        coordinator?.playerRuntimeContainer.getWhitelistedPartiesAndTheirState().first?.key
    }
    
}
