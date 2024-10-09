import GamePantry

public class EntitiesRuntimeContainer {
    
    private let configuration          : GPGameProcessConfiguration
    public  let panelRuntimeContainer  : PanelRuntimeContainer
    public  let gameRuntimeContainer   : GameRuntimeContainer
    public  let playerRuntimeContainer : PlayerRuntimeContainer
    
    public init ( config: GPGameProcessConfiguration ) {
        configuration          = config
        panelRuntimeContainer  = PanelRuntimeContainer()
        gameRuntimeContainer   = GameRuntimeContainer()
        playerRuntimeContainer = PlayerRuntimeContainer()
    }
    
}
