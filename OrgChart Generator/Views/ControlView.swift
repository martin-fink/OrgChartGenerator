//
//  ControlView.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/20/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import SwiftUI
import Combine
import OrgChart


struct GeneratorError: Error {
    let localizedDescription: String
    
    init(_ orgChartError: OrgChartError) {
        self.localizedDescription = orgChartError.localizedDescription
    }
}


struct ControlView: View {
    @EnvironmentObject var generator: OrgChartGenerator
    @State var cropFaces: Bool = true
    @Binding var renderPDF: Bool
    @State var cancellable: AnyCancellable?
    
    
    var disableExportButton: Bool {
        if case .initialized = generator.state {
            return true
        }
        return false
    }
    
    var body: some View {
        HStack {
            Button(action: selectDirectory) {
                Text("Select the OrgChart Path")
            }
            Toggle(isOn: $cropFaces) {
                Text("Crop Faces")
            }
            Spacer()
            Button(action: {
                self.renderPDF = true
            }) {
                Text("Export OrgChart as PDF")
            }.disabled(disableExportButton)
        }
    }
    
    
    func selectDirectory() {
        DispatchQueue.main.async {
            let panel = NSOpenPanel()
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
        
            let result = panel.runModal()
            if result == .OK {
                guard let path = panel.url, path.isFileURL, path.hasDirectoryPath else {
                    return
                }
                
                DispatchQueue.main.async {
                    self.generator.readOrgChart(from: path)
                    self.generateAction()
                }
            }
        }
    }
    
    func generateAction() {
        cancellable = generator
            .parseOrgChart()
            .flatMap {
                self.generator.loadImages()
            }
            .flatMap {
                self.generator.cropImages()
            }
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished: break
                    case let .failure(error): print(error)
                    }
                }, receiveValue: { })
    }
}

struct ControlView_Previews: PreviewProvider {
    @State static var renderPDF: Bool = false
    
    static var previews: some View {
        ControlView(renderPDF: $renderPDF)
    }
}
