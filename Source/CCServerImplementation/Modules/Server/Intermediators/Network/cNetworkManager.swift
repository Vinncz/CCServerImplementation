import GamePantry

public class NetworkManager : GPGameServerNetworkManager {
    
    public let myself : MCPeerID
    
    public let eventListener     : any GamePantry.GPGameEventListener
    public let eventBroadcaster  : GamePantry.GPGameEventBroadcaster
    public var advertiserService : any GamePantry.GPGameServerAdvertiser
    
    public let gameProcessConfig : GamePantry.GPGameProcessConfiguration
    
    public init ( router: GPEventRouter, config configuration: GPGameProcessConfiguration ) {
        myself                 = MCPeerID(displayName: "CCServer-\(configuration.gameVersion)")
        
        self.eventListener     = NetworkEventListener(router: router)
        self.eventBroadcaster  = NetworkEventBroadcaster(serves: myself, router: router).pair(self.eventListener)
        self.advertiserService = GameServerAdvertiser(serves: myself, config: configuration, router: router)
        
        self.gameProcessConfig = configuration
        
        eventListener.startListening(eventListener)
    }
    
}
