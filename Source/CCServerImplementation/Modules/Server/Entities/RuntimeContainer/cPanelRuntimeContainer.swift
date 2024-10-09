import GamePantry

public class PanelRuntimeContainer {
    
    private var registeredPanels : [GamePanel]
    private var playerMapping    : [MCPeerID: GamePanel]
    
    public init () {
        self.registeredPanels = []
        self.playerMapping    = [:]
    }
    
}

extension PanelRuntimeContainer {
    
    public struct AvailablePanelTypes {
        static let cablesPanel   = CablesPanel.self
        static let symbolsPanel  = SymbolsPanel.self
        static let switchesPanel = SwitchesPanel.self
    }
    
    public static let availablePanelTypes : [GamePanel.Type] = [
        CablesPanel.self,
        SymbolsPanel.self,
        SwitchesPanel.self,
    ]
}

extension PanelRuntimeContainer {
    
    public func getRegisteredPanelTypes () -> [String] {
        self.registeredPanels.map { $0.panelId }
    }
    
    public func getRegisteredPanels () -> [GamePanel] {
        self.registeredPanels
    }
    
    public func getPanel ( panelId: String ) -> GamePanel? {
        self.registeredPanels.first { $0.panelId == panelId }
    }
    
}

extension PanelRuntimeContainer {
    
    public func registerPanel ( _ panel: GamePanel ) {
        self.registeredPanels.append(panel)
    }
    
}
