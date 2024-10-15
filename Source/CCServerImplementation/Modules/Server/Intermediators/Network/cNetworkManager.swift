import GamePantry

@Observable public class NetworkManager : GPGameServerNetworkManager, ObservableObject {
    
    public let myself : MCPeerID
    
    public var eventListener     : any GamePantry.GPGameEventListener
    public var eventBroadcaster  : GamePantry.GPGameEventBroadcaster
    public var advertiserService : any GamePantry.GPGameServerAdvertiser
    
    public let gameProcessConfig : GamePantry.GPGameProcessConfiguration
    
    public init ( router: GPEventRouter, config configuration: GPGameProcessConfiguration ) {
        gameProcessConfig = configuration
        
        let myself = MCPeerID(displayName: "CCServer-\(configuration.gameVersion)")
        self.myself = myself
        
        let el = NetworkEventListener(router: router)
        let eb = NetworkEventBroadcaster(serves: myself, router: router)
        let ad = GameServerAdvertiser(serves: myself, configuredWith: configuration, router: router)
        
        self.eventListener     = el
        self.eventBroadcaster  = eb.pair(el)
        self.advertiserService = ad
        
        self.eventListener$     = el
        self.eventBroadcaster$  = eb
        self.advertiserService$ = ad
    }
    
    @ObservationIgnored @Published public var eventListener$     : any GamePantry.GPGameEventListener
    @ObservationIgnored @Published public var eventBroadcaster$  : GamePantry.GPGameEventBroadcaster
    @ObservationIgnored @Published public var advertiserService$ : any GamePantry.GPGameServerAdvertiser
    
}
