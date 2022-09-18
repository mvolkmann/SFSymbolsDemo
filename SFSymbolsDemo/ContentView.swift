import SwiftUI

struct ContentView: View {
    @State private var percent = 0.0
    @State private var selectedRenderingMode: String = "palette"
    @State private var selectedSymbol: String = "person.3.sequence.fill"

    private var percentDelta: Double {
        percentDeltaMap[selectedSymbol]!
    }

    private static let third = 1.0 / 3.0
    // Most of the "variable" symbols only use or two colors.
    // Very few currently use three colors.
    private let percentDeltaMap: [String: Double] = [
        "antenna.radiowaves.left.and.right": 0.5,
        "cellularbars": 0.25,
        "dot.radiowaves.right": 0.25,
        "dot.radiowaves.up.forward": 0.25,
        "ellipsis.bubble": third,
        "ellipsis": third,
        "ellipsis.message": third,
        "homekit": 0.25,
        "mic.and.signal.meter.fill": 0.25,
        "person.3.sequence": third,
        "person.3.sequence.fill": third,
        "phone.and.waveform": 0.2,
        "slowmo": 1.0 / 12.0,
        "speaker.wave.3": third,
        "speaker.wave.3.fill": third,
        "square.stack.3d.up.fill": third,
        "target": third,
        "touchid": 1.0 / 6.0,
        "wand.and.rays": 1.0 / 7.0
    ]

    private let renderingModeMap: [String: SymbolRenderingMode] = [
        "monochrome": SymbolRenderingMode.monochrome,
        "hierarchical": SymbolRenderingMode.hierarchical,
        "palette": SymbolRenderingMode.palette,
        "multicolor": SymbolRenderingMode.multicolor
    ]

    var body: some View {
        VStack {
            Text("SF Symbols\nVariable Color Demo")
                .font(.largeTitle)
                .multilineTextAlignment(.center)

            Picker("Symbol", selection: $selectedSymbol) {
                ForEach(
                    percentDeltaMap.keys.sorted(),
                    id: \.self
                ) { systemName in
                    Text(systemName).tag(systemName)
                }
            }
            .onChange(of: selectedSymbol) { _ in percent = 0.0 }

            Picker("Rendering Mode", selection: $selectedRenderingMode) {
                Text("Monochrome").tag("monochrome")
                Text("Hierarchical").tag("hierarchical")
                Text("Palette").tag("palette")
                Text("Multicolor").tag("multicolor")
            }
            .onChange(of: selectedRenderingMode) { _ in percent = 0.0 }

            Spacer()
            Image(systemName: selectedSymbol, variableValue: percent)
                .resizable()
                .scaledToFit()
                .frame(height: 100)
                .padding(.vertical)
                .foregroundStyle(.red, .green, .blue)
                .symbolRenderingMode(
                    renderingModeMap[selectedRenderingMode]
                )
            Spacer()

            HStack(spacing: 30) {
                Button("- ") {
                    if percent > 0 { percent -= percentDelta }
                }
                .disabled(percent <= 0)

                Button("+ ") {
                    if percent < 1 { percent += percentDelta }
                }
                .disabled(percent >= 1)

                Button("Reset") { percent = 0 }
            }
            .font(.system(size: 30))

            Text(String(format: "%.2f", percent) + "%")
        }
        .buttonStyle(.bordered)
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
