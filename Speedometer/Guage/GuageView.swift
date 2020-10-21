//
//  GuageView.swift
//  Speedometer
//
//  Created by Denny Mathew on 21/10/20.
//  Copyright © 2020 Densigns. All rights reserved.
//

import Foundation
import SwiftUI
// MARK: - Gauge View
struct GaugeView: View {
    let coveredRadius: Double // 0 - 360
    let maxValue: Int
    let steperSplit: Int
    private var tickCount: Int {
        maxValue/steperSplit
    }
    
    @Binding var value: Double
    var body: some View {
        ZStack {
            Text("\(value, specifier: "%0.0f")")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(Color.orange)
                .offset(x:0, y: 40)
            Needle()
                .fill(Color.red)
                .frame(width: 140, height: 6)
                .offset(x: -70, y: 0)
                .rotationEffect(.init(degrees: getAngle(value: value)), anchor: .center)
                .animation(.linear)
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.red)
            ForEach(0..<tickCount*2 + 1) { tick in
                self.tick(at: tick, totalTicks: self.tickCount*2)
            }
            ForEach(0..<tickCount + 1) { tick in
                self.tickText(at: tick, text: "\(self.steperSplit*tick)")
            }
        }.frame(width: 300, height: 300, alignment: .center)
    }
    
    func getAngle(value: Double) -> Double {
        return (value/Double(maxValue))*coveredRadius - coveredRadius/2 + 90
    }
    
    func colorMix(percent: Int) -> Color {
        let p = Double(percent)
        let tempG = (100.0-p)/100
        let g: Double = tempG < 0 ? 0 : tempG
        let tempR = 1+(p-100.0)/100.0
        let r: Double = tempR < 0 ? 0 : tempR
        return Color.init(red: r, green: g, blue: 0)
    }
    func tick(at tick: Int, totalTicks: Int) -> some View {
        let percent = (tick * 100)/totalTicks
        let startAngle = coveredRadius/2 * -1
        let stepper = coveredRadius/Double(totalTicks)
        let rotation = Angle.degrees(startAngle + stepper * Double(tick))
        return VStack {
            Rectangle()
            .fill(colorMix(percent: percent))
                .frame(width: tick % 2 == 0 ? 5 : 3, height: tick % 2 == 0 ? 20 : 10)
            Spacer()
        }.rotationEffect(rotation)
    }
    func tickText(at tick: Int, text: String) -> some View {
        let percent = (tick * 100) / tickCount
        let startAngle = coveredRadius/2 * -1 + 90
        let stepper = coveredRadius/Double(tickCount)
        let rotation = startAngle + stepper * Double(tick)
        return Text(text).foregroundColor(colorMix(percent: percent)).rotationEffect(.init(degrees: -1 * rotation), anchor: .center).offset(x: -115, y: 0).rotationEffect(Angle.degrees(rotation))
    }
}
// MARK: - Needle View
struct Needle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.height/2))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
        return path
    }
}
// MARK: - Content View
struct ContentView: View {
    @State private var value = 25.0
    private var maxValue = 140
    var body: some View {
        VStack {
            GaugeView(coveredRadius: 225, maxValue: maxValue, steperSplit: 10, value: $value)
            Slider.init(value: $value, in: 0...Double(maxValue), step: 1)
                .padding(.horizontal, 20)
            HStack {
                Spacer()
                Button(action: {
                    self.value = 0
                }) {
                    Text("Zero")
                }.foregroundColor(.blue)
                Spacer()
                Button(action: {
                    self.value = 100
                }) {
                    Text("Max")
                }.foregroundColor(.blue)
                Spacer()
            }
        }
    }
}
struct GuageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
