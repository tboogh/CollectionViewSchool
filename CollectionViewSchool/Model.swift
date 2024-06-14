import Foundation
import SwiftUI

class Model: Identifiable, Hashable, ObservableObject, Equatable {
    
    init(id: Int) {
        self.id = id
        self.color = BackgroundColor.allCases.randomElement()?.color ?? .pink
    }
    
    let id: Int
    let color: Color
    
    static func == (lhs: Model, rhs: Model) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
