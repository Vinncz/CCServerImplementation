import GamePantry

public class PenaltiesProgression {
    
    public let limit    : Int
    public var progress : Int
    
    public init ( limit: Int, startingAt: Int = 0 ) {
        self.limit    = limit
        self.progress = startingAt
    }
    
}
