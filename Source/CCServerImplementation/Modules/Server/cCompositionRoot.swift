import GamePantry

final public class CompositionRoot {
    
    static let configuration = GamePantry.GPGameProcessConfiguration (
        debugEnabled : true,
        gameName     : "Criminal Crew",
        gameVersion  : "v0.1.0-alpha",
        serviceType  : "criminal-crew"
    )
    
    /// MARK: -- Dependencies
    let router                 : GamePantry.GPEventRouter
    let networkManager         : NetworkManager
    let localStorage           : GamePantry.GPGameTemporaryStorage
    
    /// MARK: -- Use Cases
    // Commanded
    let assignPenaltiesUC           : AssignPenalties
        let assignTasksUC               : AssignTasks
        let distributePanelsUC          : DistributePanels
    // Event-based
    let relayToHostUC               : EventRelay
        let hostSignalResponderUC       : HostSignalResponder
        let playerTaskReportResponderUC : PlayerTaskReportResponder
        let playerConnectionResponderUC : PlayerConnectionResponder
    // Daemon
    let gameContinuumDaemonUC       : GameContinuumDaemon
        let quickTimeEventDaemonUC      : QuickTimeEventDaemon
    
    /// MARK: -- Entities
    let playerRuntimeContainer : PlayerRuntimeContainer
    let panelRuntimeContainer  : PanelRuntimeContainer
    let gameRuntimeContainer   : GameRuntimeContainer
    
    public init () {
        self.router                   = GamePantry.GPEventRouter()
        self.networkManager           = NetworkManager(router: router, config: Self.configuration)
        self.localStorage             = LocalTemporaryStorage()
        
        self.playerRuntimeContainer   = PlayerRuntimeContainer()
        self.panelRuntimeContainer    = PanelRuntimeContainer()
        self.gameRuntimeContainer     = GameRuntimeContainer()
        
        self.relayToHostUC               = EventRelay                (router: router)
        self.hostSignalResponderUC       = HostSignalResponder       (router: router)
        self.playerTaskReportResponderUC = PlayerTaskReportResponder (router: router)
        self.playerConnectionResponderUC = PlayerConnectionResponder (router: router)
        
        self.assignTasksUC               = AssignTasks            (router: router)
        self.distributePanelsUC          = DistributePanels       (router: router)
        self.assignPenaltiesUC           = AssignPenalties        (router: router)
        
        self.gameContinuumDaemonUC       = GameContinuumDaemon    (router: router)
        self.quickTimeEventDaemonUC      = QuickTimeEventDaemon   (router: router)
        
        finishConfiguringPlayerRuntimeResponder()
        finishConfiguringAssignTask()
        finishConfiguringDistributePanel()
    }
    
}

extension CompositionRoot {
    
    private func finishConfiguringAssignPenalties () {
        assignPenaltiesUC.coordinator = self
        assignPenaltiesUC.placeSubscription(on: AssignPenaltyEvent.self)
    }
    
    private func finishConfiguringAssignTask () {
        assignTasksUC.coordinator = self
        assignTasksUC.placeSubscription(on: AssignTaskEvent.self)
    }
    
    private func finishConfiguringDistributePanel () {
        distributePanelsUC.coordinator = self
    }
    
    private func finishConfiguringPlayerRuntimeResponder () {
        playerConnectionResponderUC.coordinator = self
        playerConnectionResponderUC.placeSubscription(on: GPAcquaintanceEvent.self)
        playerConnectionResponderUC.placeSubscription(on: GPBlacklistedEvent.self)
        playerConnectionResponderUC.placeSubscription(on: GPTerminationEvent.self)
    }
    
}

extension CompositionRoot {
    
    public func startGame () {
        distributePanelsUC.distributePanel()
        // mix-up tasks
        // assign those initial tasks
        // signal play command
    }
    
}
