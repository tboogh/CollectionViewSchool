import Foundation
import SwiftUI

class Model: Identifiable, Hashable, ObservableObject, Equatable {
        
    init(id: Int, heightChangeAction: @escaping (CGFloat) -> Void) {
        self.id = id
        self.heightChangeAction = heightChangeAction
        self.color = BackgroundColor.allCases.randomElement()?.color ?? .pink
    }
    
    let heightChangeAction: (CGFloat) -> Void
    let id: Int
    let color: Color
    @Published var height: CGFloat = 100
    
    func makeBiggler() {
        height = min(400, height + 10)
        heightChangeAction(height)
    }
    
    func makeSmaller() {
        height = max(100, height - 10)
        heightChangeAction(height)
    }
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
