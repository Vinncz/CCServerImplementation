import GamePantry

public class HostSignalResponder {
    
    public weak var coordinator : CompositionRoot?
    public weak var eventRouter : GamePantry.GPEventRouter?
    public var subscriptions    : Set<AnyCancellable>
    
    public init ( router: GPEventRouter ) {
        self.eventRouter   = router
        self.subscriptions = []
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
    }
    
}

extension HostSignalResponder : GPHandlesEvents {
    
    public func placeSubscription ( on eventType: any GPEvent.Type ) {
        eventRouter?.subscribe(to: eventType)?.sink { event in
            self.handle(event)
        }.store(in: &subscriptions)
    }
    
    private func handle ( _ event: GPEvent ) {
        switch ( event ) {
            case let event as CommenceGameStartEvent:
                respondToGameStartRequest(event)
                break
                
            default:
                debug("Unhandled event: \(event)")
                break
        }
    }
    
}

extension HostSignalResponder {
    
    private func respondToGameStartRequest ( _ event: CommenceGameStartEvent) {
        guard 
            event.signingKey == coordinator?.playerRuntimeContainer.getAcquaintancedPartiesAndTheirState().first?.key.displayName
        else {
            debug("A requestor, who is not the host, tried to signal the start of the game")
            return
        }
        
        coordinator?.startGame()
    }
    
}
