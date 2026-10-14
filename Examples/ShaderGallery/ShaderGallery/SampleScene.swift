// A landscape drawn in code, used as the picture the gallery and the README screenshots apply
// effects to. Drawing it keeps the repository free of photos with unclear licenses, and every
// screenshot can be regenerated from source.

import SwiftUI

struct SampleScene: View {
    var body: some View {
        Canvas { context, size in
            let width = size.width
            let height = size.height
            let horizon = height * 0.62

            // Sky.
            context.fill(
                Path(CGRect(x: 0, y: 0, width: width, height: horizon)),
                with: .linearGradient(
                    Gradient(colors: [Color(red: 0.05, green: 0.16, blue: 0.42), Color(red: 0.36, green: 0.64, blue: 0.95)]),
                    startPoint: .zero,
                    endPoint: CGPoint(x: 0, y: horizon)
                )
            )

            // Sun.
            let sun = CGRect(x: width * 0.66, y: height * 0.14, width: height * 0.22, height: height * 0.22)
            context.fill(Path(ellipseIn: sun), with: .color(Color(red: 1, green: 0.86, blue: 0.5)))

            // Mountains, back to front.
            let ranges: [(peaks: [CGFloat], base: CGFloat, color: Color)] = [
                ([0.35, 0.18, 0.42, 0.22, 0.38], horizon, Color(red: 0.24, green: 0.39, blue: 0.66)),
                ([0.55, 0.36, 0.5, 0.3, 0.52, 0.44], horizon, Color(red: 0.11, green: 0.24, blue: 0.48)),
            ]
            for range in ranges {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: range.base))
                for (index, peak) in range.peaks.enumerated() {
                    let x = width * CGFloat(index) / CGFloat(range.peaks.count - 1)
                    path.addLine(to: CGPoint(x: x, y: height * peak))
                }
                path.addLine(to: CGPoint(x: width, y: range.base))
                path.closeSubpath()
                context.fill(path, with: .color(range.color))
            }

            // Lake with the sun's reflection.
            context.fill(
                Path(CGRect(x: 0, y: horizon, width: width, height: height - horizon)),
                with: .linearGradient(
                    Gradient(colors: [Color(red: 0.16, green: 0.42, blue: 0.78), Color(red: 0.02, green: 0.1, blue: 0.3)]),
                    startPoint: CGPoint(x: 0, y: horizon),
                    endPoint: CGPoint(x: 0, y: height)
                )
            )
            for line in 0..<5 {
                let y = horizon + CGFloat(line + 1) * (height - horizon) / 7
                let lineWidth = sun.width * (1 - CGFloat(line) * 0.15)
                let rect = CGRect(x: sun.midX - lineWidth / 2, y: y, width: lineWidth, height: 3)
                context.fill(Path(roundedRect: rect, cornerRadius: 1.5), with: .color(Color(red: 1, green: 0.86, blue: 0.5).opacity(0.7)))
            }

            // A boat.
            var hull = Path()
            let boatX = width * 0.22
            let boatY = horizon + (height - horizon) * 0.45
            hull.move(to: CGPoint(x: boatX - 26, y: boatY))
            hull.addLine(to: CGPoint(x: boatX + 26, y: boatY))
            hull.addLine(to: CGPoint(x: boatX + 18, y: boatY + 9))
            hull.addLine(to: CGPoint(x: boatX - 18, y: boatY + 9))
            hull.closeSubpath()
            context.fill(hull, with: .color(.white))
            var sail = Path()
            sail.move(to: CGPoint(x: boatX, y: boatY - 40))
            sail.addLine(to: CGPoint(x: boatX + 22, y: boatY - 4))
            sail.addLine(to: CGPoint(x: boatX, y: boatY - 4))
            sail.closeSubpath()
            context.fill(sail, with: .color(.white))
        }
    }
}
