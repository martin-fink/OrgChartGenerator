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
    @Binding var context: OrgChartRenderContext
    @State var managementWidth: CGFloat = .zero
    
    
    var body: some View {
        ZStack {
            TeamBackgroundView(teams: context.teams,
                               managementWidth: $managementWidth)
            VStack(alignment: .leading) {
                TeamHeaderView(teams: context.teams,
                               managementWidth: $managementWidth)
                ForEach(context.rows.indices) { rowIndex in
                    OrgChartRow(row: self.$context.rows[rowIndex])
                }
            }
                .onPreferenceChange(ManagementWidthPreferenceKey.self) { managementWidth in
                    self.managementWidth = managementWidth
                }
            TeamBorderView(teams: context.teams,
                           managementWidth: $managementWidth)
        }.fixedSize(horizontal: true, vertical: true)
    }
}


struct OrgChartBody_Previews: PreviewProvider {
    @State static var renderContext = OrgChartRenderContext.mock
    
    static var previews: some View {
        OrgChartBody(context: $renderContext)
            .background(Color.white)
    }
}
