import GamePantry

public class PlayerTaskReportResponder {
    
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

extension PlayerTaskReportResponder : GPHandlesEvents {
    
    public func placeSubscription ( on eventType: any GamePantry.GPEvent.Type ) {
        eventRouter?.subscribe(to: eventType)?.sink { event in
            self.handle(event)
        }.store(in: &subscriptions)
    }
    
    private func handle ( _ event: GPEvent ) {
        switch ( event ) {
            case let event as TaskReportEvent:
                handlePlayerTaskReportEvent(event)
                break
                
            default:
                debug("Unhandled event: \(event)")
                break
        }
    }
    
}

extension PlayerTaskReportResponder : GPEmitsEvents {
    
    public func emit ( _ event: GPEvent ) -> Bool {
        return eventRouter?.route(event) ?? false
    }
    
}

extension PlayerTaskReportResponder {
    
    private func handlePlayerTaskReportEvent ( _ event: TaskReportEvent ) {
        let playerIsNotBlacklisted : Bool = coordinator?.playerRuntimeContainer.getPlayer(named: event.submitterName)?.isBlacklisted ?? false
        
        guard playerIsNotBlacklisted else { return }
    }
    
}
