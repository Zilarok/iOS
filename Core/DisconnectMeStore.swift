//
//  DisconnectMeStore.swift
//  DuckDuckGo
//
//  Copyright © 2017 DuckDuckGo. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation

public class DisconnectMeStore {

    public static let shared = DisconnectMeStore()

    var hasData: Bool {
        return !allTrackers.isEmpty
    }

    public private(set) var allTrackers = [String: String]()
    public private(set) var bannedTrackersJson = "{}"
    public private(set) var allowedTrackersJson = "{}"

    private init() {
        try? load(data: Data(contentsOf: persistenceLocation()))
    }
    
    func persist(data: Data) throws  {
        try load(data: data)

        let location = persistenceLocation()
        Logger.log(items: "DisconnectMeStore", location)
        try data.write(to: persistenceLocation(), options: .atomic)
    }

    private func load(data: Data) throws {
        let parser = DisconnectMeTrackersParser()
        allTrackers = try parser.convert(fromJsonData: data, categoryFilter: nil)
        
        bannedTrackersJson = (try? convertToInjectableJson(data, using: parser, filteringBy: DisconnectMeTrackersParser.bannedCategoryFilter)) ?? "{}"
        allowedTrackersJson = (try? convertToInjectableJson(data, using: parser, filteringBy: DisconnectMeTrackersParser.allowedCategoryFilter)) ?? "{}"
    }

    private func convertToInjectableJson(_ data: Data, using parser: DisconnectMeTrackersParser, filteringBy filter: [DisconnectMeTrackersParser.Category]) throws -> String {
        let trackers = try parser.convert(fromJsonData: data, categoryFilter: filter)
        let json = try JSONSerialization.data(withJSONObject: trackers, options: .prettyPrinted)
        if let jsonString = String(data: json, encoding: .utf8) {
            return jsonString
        }
        return ""
    }

    private func persistenceLocation() -> URL {
        let path = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: ContentBlockerStoreConstants.groupName)
        return path!.appendingPathComponent("disconnectme.json")
    }
}