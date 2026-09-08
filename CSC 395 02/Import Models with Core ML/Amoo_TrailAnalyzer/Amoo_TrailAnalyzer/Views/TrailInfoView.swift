import SwiftUI


struct TrailInfoView: View {
    @Binding var trailInfo: TrailInfo


    var body: some View {
        VStack {
            TrailField(iconName: "figure.hiking", label: "Distance") {
                TextField("kilometers", value: $trailInfo.distance, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }


            TrailField(iconName: "mountain.2.fill", label: "Elevation Change") {
                TextField("meters", value: $trailInfo.elevation, format: .number)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
            }


            TrailField(iconName: "shoe.fill", label: "Terrain") {
                Picker("Terrain", selection: $trailInfo.terrain) {
                    ForEach(Terrain.allCases) { terrain in
                        Text(terrain.rawValue.capitalized)
                            .tag(terrain)
                    }
                }
                .tint(Color.black)
                .background(RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.15))
                    .opacity(trailInfo.terrain == nil ? 0.0 : 1.0)
                )
            }


            TrailField(iconName: "exclamationmark.triangle.fill", label: "Danger from wildlife") {
                Picker("Danger from wildlife", selection: $trailInfo.wildlifeDangerLevel) {
                    Text("Low")
                        .tag(TrailInfo.lowDanger)
                    Text("High")
                        .tag(TrailInfo.highDanger)
                }
                .frame(width: 110)
                .pickerStyle(.segmented)
            }
        }
    }
}


#Preview {
    @Previewable @State var trailInfo = TrailInfo.empty
    TrailInfoView(trailInfo: $trailInfo)
        .trailTheme()
}
