//
//  ContentView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/19/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    @ObservedObject var generator = OrgChartGenerator()
    @State var renderAsPDF: Bool = false
    
    
    var unsafeRenderContextBinding: Binding<OrgChartRenderContext> {
        Binding(get: {
            self.generator.state.renderContext!
        }) { newRenderContext in
            self.generator.state = OrgChartGeneratorState.set(renderContext: newRenderContext,
                                                              on: self.generator.state)
        }
    }
    
    var body: some View {
        chooseMainView()
            .environmentObject(generator)
    }
    
    
    func chooseMainView() -> AnyView {
        if case .initialized = generator.state {
            return onlyControlView("Please provide a path to the OrgChart")
        }
        if case let .pathProvided(path, orgChart) = generator.state {
            return onlyControlView("Loading the OrgChart \"\(orgChart.title)\" found at \(path)")
        }
        if case .orgChartParsed = generator.state {
            return orgChartVisible(unsafeRenderContextBinding)
        }
        if case .imagesLoaded = generator.state {
            return orgChartVisible(unsafeRenderContextBinding)
        }
        if case .imagesCropped = generator.state {
            return orgChartVisible(unsafeRenderContextBinding)
        }
        if case .orgChartRendered = generator.state {
            return orgChartVisible(unsafeRenderContextBinding)
        }
        return AnyView(
            Text("Unknown State")
        )
    }
    
    func onlyControlView(_ message: String) -> AnyView {
        return AnyView(
            VStack {
                ControlView(renderPDF: $renderAsPDF)
                Text(message)
            }
        )
    }
    
    func orgChartVisible(_ renderContext: Binding<OrgChartRenderContext>) -> AnyView {
        AnyView(
            VStack {
                ControlView(renderPDF: $renderAsPDF)
                ScrollView([.horizontal, .vertical], showsIndicators: true) {
                    PDFExportView(view: OrgChartView(context: renderContext),
                                  renderAsPDF: $renderAsPDF) { pdf in
                        self.generator.rendered(pdf)
                    }
                }
            }
        )
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
