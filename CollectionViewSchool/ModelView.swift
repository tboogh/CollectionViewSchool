import SwiftUI

struct ModelView: View {
    
    @ObservedObject var model: Model
    
    var body: some View {
        Text("Model: \(model.id)")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(model.color)
    }
}

#Preview {
    ModelView(model: Model(id: 321))
}

enum BackgroundColor: CaseIterable {
    
    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink
    case brown
}

extension BackgroundColor {
        
    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .mint: return .mint
        case .teal: return .teal
        case .cyan: return .cyan
        case .blue: return .blue
        case .indigo: return .indigo
        case .purple: return .purple
        case .pink: return .pink
        case .brown: return .brown
        }
    }
}
