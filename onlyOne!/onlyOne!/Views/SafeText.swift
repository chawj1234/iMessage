import SwiftUI

struct SafeText: View {
    private let text: String
    private let font: Font?
    private let weight: Font.Weight?
    private let color: Color?
    private let alignment: TextAlignment
    private let lineLimit: Int?
    
    init(
        _ text: String,
        font: Font? = nil,
        weight: Font.Weight? = nil,
        color: Color? = nil,
        alignment: TextAlignment = .center,
        lineLimit: Int? = nil
    ) {
        // 텍스트 안전성 검증
        self.text = text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? " " : text
        self.font = font
        self.weight = weight
        self.color = color
        self.alignment = alignment
        self.lineLimit = lineLimit
    }
    
    var body: some View {
        Text(text)
            .font(font)
            .fontWeight(weight)
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
            .lineLimit(lineLimit)
    }
}

struct SafeTextModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .animation(.easeInOut(duration: 0.3), value: UUID())
    }
}

extension View {
    func safeTextTransition() -> some View {
        modifier(SafeTextModifier())
    }
} 