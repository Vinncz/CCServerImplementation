import GamePantry

public class DistributePanels {
    
    public weak var coordinator : CompositionRoot?
    public weak var eventRouter : GamePantry.GPEventRouter?
    
    public init ( router: GPEventRouter ) {
        self.eventRouter   = router
    }
    
}

extension DistributePanels : GPEmitsEvents {
    
    public func emit ( _ event: GPEvent ) -> Bool {
        eventRouter?.route(event) ?? false
    }
    
}

extension DistributePanels {
    
    public func distributePanel () {
        let playerComposition  : [MCPeerID] = getPlayers()
        let supportedPanelTypes = getAvailablePanelTypes().shuffled().prefix(playerComposition.count)
        
        for ( index, player ) in playerComposition.enumerated() {
            let panelForThisPlayer = supportedPanelTypes[index].init()
            let distributePanelOrder = AssignPanelEvent (
                toPlayerWithDisplayName : player.displayName,
                panelWithIdOf           : panelForThisPlayer.panelId
            )
            
            if !emit(distributePanelOrder) {
                debug("Failed to distribute panel \(panelForThisPlayer.panelId) to \(player.displayName)")
            }
            
            pushCreatedPanelToCoordinator(panelForThisPlayer)
        }
    }
    
}

extension DistributePanels {
    
    private func pushCreatedPanelToCoordinator ( _ panel: any GamePanel ) {
        coordinator?.panelRuntimeContainer.registerPanel(panel)
    }
    
    private func getPlayers() -> [MCPeerID] {
        coordinator?.playerRuntimeContainer.getWhitelistedPartiesAndTheirState().map { $0.key } ?? []
    }
    
    private func getAvailablePanelTypes() -> [GamePanel.Type] {
        PanelRuntimeContainer.availablePanelTypes
    }
    
}
