import GamePantry

final public class ServerComposer {
    
    static let configuration = GamePantry.GPGameProcessConfiguration (
        debugEnabled : true,
        gameName     : "Criminal Crew",
        gameVersion  : "v0.1.0-alpha",
        serviceType  : "criminal-crew"
    )
    
    public let router         : GamePantry.GPEventRouter
    public let networkManager : NetworkManager
    public let localStorage   : GamePantry.GPGameTemporaryStorage
    
    public let comUC_penaltyAssigner : PenaltyAssigner
    public let comUC_taskGenerator   : TaskGenerator
    public let comUC_taskAssigner    : TaskAssigner
    public let comUC_panelAssigner   : PanelAssigner
    
    public let evtUC_eventRelayer              : EventRelayer
    public let evtUC_hostSignalResponder       : HostSignalResponder
    public let evtUC_taskReportResponder       : PlayerTaskReportResponder
    public let evtUC_playerConnectionResponder : PlayerConnectionResponder
    
    // public let dmnUC_gameContinuumObserver   : GameContinuumDaemon
    // public let dmnUC_quickTimeEventInitiator : QuickTimeEventDaemon
    
    public let ent_playerRuntimeContainer : PlayerRuntimeContainer
    public let ent_panelRuntimeContainer  : PanelRuntimeContainer
    public let ent_gameRuntimeContainer   : GameRuntimeContainer
    
    public init () {
        router                   = GamePantry.GPEventRouter()
        networkManager           = NetworkManager(router: router, config: Self.configuration)
        localStorage             = LocalTemporaryStorage()
        
        comUC_penaltyAssigner    = PenaltyAssigner()
        comUC_taskAssigner       = TaskAssigner()
        comUC_taskGenerator      = TaskGenerator()
        comUC_panelAssigner      = PanelAssigner()
        
        evtUC_eventRelayer              = EventRelayer()              // Relayer done
        evtUC_hostSignalResponder       = HostSignalResponder()       // Relayer done
        evtUC_taskReportResponder       = PlayerTaskReportResponder() // Relayer done
        evtUC_playerConnectionResponder = PlayerConnectionResponder() // Relayer done
        
        // dmnUC_gameContinuumObserver   = GameContinuumDaemon()
        // dmnUC_quickTimeEventInitiator = QuickTimeEventDaemon()
        
        ent_playerRuntimeContainer = PlayerRuntimeContainer()
        ent_panelRuntimeContainer  = PanelRuntimeContainer()
        ent_gameRuntimeContainer   = GameRuntimeContainer()
    }
    
}

extension ServerComposer {
    
    private func coordinate () {
        let eventRelayerRelay = EventRelayer.Relay (
            eventRouter      : self.router,
            playerRegistry   : self.ent_playerRuntimeContainer,
            eventBroadcaster : self.networkManager.eventBroadcaster
        )
        evtUC_eventRelayer.relay = eventRelayerRelay
        
        let hostSignalResponderRelay = HostSignalResponder.Relay (
            gameProcessConfig      : Self.configuration,
            eventRouter            : self.router,
            eventBroadcaster       : self.networkManager.eventBroadcaster,
            taskAssigner           : self.comUC_taskAssigner,
            taskGenerator          : self.comUC_taskGenerator,
            panelAssigner          : self.comUC_panelAssigner,
            panelRuntimeContainer  : self.ent_panelRuntimeContainer,
            playerRuntimeContainer : self.ent_playerRuntimeContainer,
            gameRuntimeContainer   : self.ent_gameRuntimeContainer,
            admitPlayer            : { playerName, decideToAdmit in
                guard let playerRequest = self.networkManager.advertiserService.pendingRequests.first(where: { $0.requestee.displayName == playerName }) else {
                    debug("HostSignalResponder is unable to admit the player: the request record is missing or not found")
                    return
                }
                
                if decideToAdmit {
                    self.networkManager.eventBroadcaster.approve(playerRequest.resolve(to: .admit))
                    debug("Admitted the player named: \(playerName)")
                } else {
                    self.networkManager.eventBroadcaster.approve(playerRequest.resolve(to: .reject))
                    self.networkManager.advertiserService.pendingRequests.removeAll { $0.requestee.displayName == playerName }
                    debug("Rejected the player named: \(playerName), and removed their request")
                }
            },
            terminatePlayer        : { terminationEvent in
                guard let playerToBeTerminated = self.ent_playerRuntimeContainer.getAcquaintancedPartiesAndTheirState().first(where: { $0.key.displayName == terminationEvent.subject })?.key else {
                    debug("HostSignalResponder is unable to admit the player: the request record is missing or not found")
                    return
                }
                
                do {
                    try self.networkManager.eventBroadcaster.broadcast(terminationEvent.representedAsData(), to: [playerToBeTerminated])
                    debug("HostSignalResponder broadcasted the termination event to the player named: \(playerToBeTerminated.displayName): \(terminationEvent.representedAsData())")
                } catch {
                    debug("HostSignalResponder is unable to terminate the player: \(error)")
                }
            }
        )
        evtUC_hostSignalResponder.relay = hostSignalResponderRelay
        
        let taskReportResponderRelay = PlayerTaskReportResponder.Relay (
            eventRouter          : self.router,
            gameRuntimeContainer : self.ent_gameRuntimeContainer
        )
        evtUC_taskReportResponder.relay = taskReportResponderRelay
        
        let playerConnectionResponderRelay = PlayerConnectionResponder.Relay (
            eventRouter            : self.router,
            playerRuntimeContainer : self.ent_playerRuntimeContainer
        )
        evtUC_playerConnectionResponder.relay = playerConnectionResponderRelay
    }
    
}
