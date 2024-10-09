import GamePantry

public class PlayerConnectionResponder {
    
    public weak var coordinator : CompositionRoot?
    public weak var eventRouter : GamePantry.GPEventRouter?
    public var subscriptions    : Set<AnyCancellable>
    
    public init ( router: GamePantry.GPEventRouter ) {
        self.eventRouter   = router
        self.subscriptions = []
    }
    
}

extension PlayerConnectionResponder : GPHandlesEvents {
    
    public func placeSubscription ( on eventType: any GamePantry.GPEvent.Type ) {
        eventRouter?.subscribe(to: eventType)?.sink { event in
            self.handle(event)
        }.store(in: &subscriptions)
    }
    
    private func handle ( _ event: GPEvent ) {
        switch ( event ) {
            case let event as GPAcquaintanceEvent:
                handleAcquaintanceEvent(event)
                break
                
            default:
                debug("Unhandled event: \(event)")
                break
        }
    }
    
}

extension PlayerConnectionResponder : GPEmitsEvents {
    
    public func emit ( _ event: GPEvent ) -> Bool {
        eventRouter?.route(event) ?? false
    }
    
}

extension PlayerConnectionResponder {
    
    private func handleAcquaintanceEvent ( _ event: GPAcquaintanceEvent ) {
        coordinator?.playerRuntimeContainer.update(event.subject, state: event.status)
    }
    
}
