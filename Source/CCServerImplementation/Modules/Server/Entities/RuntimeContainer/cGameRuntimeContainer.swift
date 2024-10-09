import GamePantry

public class GameRuntimeContainer {
    
    public let penaltiesProgression : PenaltiesProgression
    public let tasksProgression     : TasksProgression
    
    public init ( taskLimit: Int = 0, penaltyLimit: Int = 0 ) {
        self.penaltiesProgression = PenaltiesProgression (limit: penaltyLimit)
        self.tasksProgression     = TasksProgression     (limit: taskLimit)
    }
    
}
