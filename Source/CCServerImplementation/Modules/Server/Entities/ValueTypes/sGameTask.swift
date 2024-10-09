import GamePantry

public struct GameTask : Identifiable, Hashable, Sendable {
    
    public let id = UUID()
    public let prompt             : String
    public let completionCriteria : [String]
    public let duration           : TimeInterval
    
}
