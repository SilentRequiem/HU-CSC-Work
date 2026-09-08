import SwiftUI


struct RiskCard: View {
    @State var risk: Risk


    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(risk.image)
                    .resizable()
                    .frame(width: 30, height: 30)
                Text(risk.rawValue)
                    .font(.title2)
            }
            Text(risk.description)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(.white, in: RoundedRectangle(cornerRadius: 12))
    }
}


#Preview {
    let prediction = TrailAnalyzer().predictRisk(trailInfo: .sample)
    RiskCard(risk: prediction)
}
