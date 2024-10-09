import GamePantry

public struct GamePenalty : Identifiable, Hashable, Sendable {
    
    public let id = UUID()
    public let penalty : Int
    
}

extension GamePenalty {
    
    public static let low    = GamePenalty(penalty: 1)
    public static let medium = GamePenalty(penalty: 2)
    public static let severe = GamePenalty(penalty: 3)
    
}
