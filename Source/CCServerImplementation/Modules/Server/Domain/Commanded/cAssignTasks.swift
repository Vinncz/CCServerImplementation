import GamePantry

public class AssignTasks {
    
    public weak var coordinator : CompositionRoot?
    public weak var eventRouter : GamePantry.GPEventRouter?
    public var subscriptions    : Set<AnyCancellable>
    
    public init ( router: GamePantry.GPEventRouter ) {
        self.eventRouter   = router
        self.subscriptions = []
    }
    
}

extension AssignTasks : GPHandlesEvents {
    
    public func placeSubscription ( on eventType: any GamePantry.GPEvent.Type ) {
        eventRouter?.subscribe(to: eventType)?.sink { event in
            self.handle(event)
        }.store(in: &subscriptions)
    }
    
    private func handle ( _ event: GPEvent ) {
        switch ( event ) {
            case let event as AssignTaskEvent:
                handleAssignTaskEvent(event)
                break
                
            default:
                debug("Unhandled event: \(event)")
                break
        }
    }
    
}

extension AssignTasks : GPEmitsEvents {
    
    public func emit ( _ event: GPEvent ) -> Bool {
        return eventRouter?.route(event) ?? false
    }
    
}

extension AssignTasks {
    
    private func handleAssignTaskEvent ( _ event: AssignTaskEvent ) {
        let playerComposition = getConnectedPlayers()
        let panelComposition  = getPanelComposition()
        
        
    }
    
    private func getConnectedPlayers() -> [MCPeerID] {
        coordinator?
            .playerRuntimeContainer
            .getWhitelistedPartiesAndTheirState()
            .filter { _, state in
                state == .connected 
            }
            .map { whom, _ in
                whom
            } ?? []
    }
    
    private func getPanelComposition() -> [GamePanel] {
        coordinator?
            .panelRuntimeContainer
            .getRegisteredPanels() ?? []
    }
    
}
