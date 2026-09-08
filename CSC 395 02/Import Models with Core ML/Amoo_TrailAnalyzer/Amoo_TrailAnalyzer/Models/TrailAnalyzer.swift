import Foundation
import CoreML


struct TrailAnalyzer {
    func predictRisk(trailInfo: TrailInfo) -> Risk {
        do {
            let model = try Linear_Regression(configuration: MLModelConfiguration())


            guard let distance = trailInfo.distance,
                  let terrain = trailInfo.terrain else {
                return .highRisk
            }
            
            let input = Linear_RegressionInput(
                distance: Int64(distance),
                elevation: Int64(trailInfo.elevation ?? 0),
                terrain: terrain.rawValue,
                dangerous: Int64(trailInfo.wildlifeDangerLevel)
            )
            let predictedRisk = try model.prediction(input: input).risk


            switch predictedRisk {
            case 0..<20:
                return .easy
            case 20..<50:
                return .moderate
            case 50..<100:
                return .difficult
            default:
                return .highRisk
            }
        } catch {
            return .highRisk
        }
    }
}
