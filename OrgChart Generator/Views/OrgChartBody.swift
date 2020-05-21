//
//  TeamView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import OrgChart


struct ManagementWidthPreferenceKey: WidthPreferenceKey {}


struct OrgChartBody: View {
    var context: OrgChartRenderContext
    @State var managementWidth: CGFloat = .zero
    
    
    var body: some View {
        ZStack {
            TeamBackgroundView(teamStyles: context.teamStyles,
                               managementWidth: $managementWidth)
            VStack(alignment: .leading) {
                ForEach(context.rows, id: \.hashValue) { row in
                    OrgChartRow(row: row)
                }
            }
                .onPreferenceChange(ManagementWidthPreferenceKey.self) { managementWidth in
                    self.managementWidth = managementWidth
                }
            TeamBorderView(teamStyles: context.teamStyles,
                           managementWidth: $managementWidth)
        }.fixedSize(horizontal: true, vertical: true)
    }
}


struct OrgChartBody_Previews: PreviewProvider {
    static var previews: some View {
        OrgChartBody(context: OrgChart.mock.renderContext)
            .background(Color(.white))
    }
}
