//
//  OrgChartGeneratorSettings.swift
//  OrgChart Generator
//
//  Created by Paul Schmiedmayer on 5/24/20.
//  Copyright © 2020 Paul Schmiedmayer. All rights reserved.
//

import Foundation
import ArgumentParser


class OrgChartGeneratorSettings: ObservableObject {
    private enum Defaults {
        static let orgChartName: String = "OrgChart"
        static let imageSize: Int = 250
        static let compressionRate: Double = 0.6
        static let cropFaces: Bool = true
        static let autogenerate: Bool = false
    }
    
    
    @Published var path: URL?
    @Published var orgChartName: String
    @Published var imageSize: Int
    @Published var compressionRate: Double
    @Published var cropFaces: Bool
    @Published var autogenerate: Bool
    
    
    init(path: URL?,
         orgChartName: String = Defaults.orgChartName,
         imageSize: Int = Defaults.imageSize,
         compressionRate: Double = Defaults.compressionRate,
         cropFaces: Bool = Defaults.cropFaces,
         autogenerate: Bool = Defaults.autogenerate) {
        self.path = path
        self.orgChartName = orgChartName
        self.imageSize = imageSize
        self.compressionRate = compressionRate
        self.cropFaces = cropFaces
        self.autogenerate = autogenerate
    }
    
    convenience init() {
        do {
            var arguments = CommandLine.arguments
            arguments.removeFirst()
            arguments.removeAll(where: { $0 == "-NSDocumentRevisionsDebugMode" }) // Default if running in XCode
            arguments.removeAll(where: { $0 == "YES" }) // Default if running in XCode
            
            let parsedArguments = try OrgChartArguments.parse(arguments)
            self.init(path: URL(fileURLWithPath: parsedArguments.path),
                      orgChartName: parsedArguments.orgChartName,
                      imageSize: parsedArguments.imageSize,
                      compressionRate: parsedArguments.compressionRate,
                      cropFaces: parsedArguments.cropFaces,
                      autogenerate: parsedArguments.autogenerate)
        } catch {
            print("Could not be loaded from the launch arguments \"\(error)\". Using the default values for launching the Org Chart Generator.")
            print(OrgChartArguments.helpMessage())
            self.init(path: nil)
        }
    }
}