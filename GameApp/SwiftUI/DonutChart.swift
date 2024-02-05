//
//  DonutChart.swift
//  GameApp
//
//  Created by Luka Podrug on 05.02.2024..
//

import Foundation
import SwiftUI
import Charts

struct DonutChart: View {
    let statistics: [GameRatingDonutChartModel]
    
    var body: some View {
        Chart(statistics) { statistic in
            SectorMark(
                angle: .value(
                    Text(verbatim: statistic.title),
                    statistic.value
                ),
                innerRadius: .ratio(0.7)
            )
            .foregroundStyle(statistic.color)
        }
    }
}
