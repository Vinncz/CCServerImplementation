import GamePantry

public class AssignPenalties {
    
    public weak var coordinator : CompositionRoot?
    public weak var eventRouter : GamePantry.GPEventRouter?
    public var subscriptions    : Set<AnyCancellable>
    
    public init ( router: GamePantry.GPEventRouter ) {
        self.eventRouter   = router
        self.subscriptions = []
    }
    
}

extension AssignPenalties : GPHandlesEvents {
    
    public func placeSubscription ( on eventType: any GamePantry.GPEvent.Type ) {
        eventRouter?.subscribe(to: eventType)?.sink { event in
            self.handle(event)
        }.store(in: &subscriptions)
    }
    
    private func handle ( _ event: GPEvent ) {
        switch ( event ) {
            case let event as AssignPenaltyEvent:
                handleAssignPenaltyEvent(event)
                break
                
            default:
                debug("Unhandled event: \(event)")
                break
        }
    }
    
}

extension AssignPenalties : GPEmitsEvents {
    
    public func emit ( _ event: GPEvent ) -> Bool {
        return eventRouter?.route(event) ?? false
    }
    
}

extension AssignPenalties {
    
    private func handleAssignPenaltyEvent ( _ event: AssignPenaltyEvent ) {
        self.coordinator?.gameRuntimeContainer.penaltiesProgression.progress = event.associatedPenalty.penalty
    }
    
}
