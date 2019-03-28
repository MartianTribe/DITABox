//
//  rootViewModel.swift
//  DITABox
//
//  Created by Steven Suranie on 3/27/19.
//  Copyright © 2019 Steven Suranie. All rights reserved.
//

import Foundation

typealias fileContentClosure = (Bool, Dictionary<String,Any>, String) -> Void

struct rootViewModel {
    
    let fileManager = FileManager.default
    
    func getFileContents(_ fileURL:URL, completion:fileContentClosure) {
        
        var dictFileData:Dictionary<String, Any> = [:]
        dictFileData["fileName"] = fileURL.lastPathComponent
        
        if fileManager.fileExists(atPath: fileURL.path) {
            
            //read file
            do {
                let dictFileInfo = try fileManager.attributesOfItem(atPath: fileURL.path)
                
                for(key, value) in dictFileInfo {
                    if (key.rawValue == "NSFileCreationDate" || key.rawValue == "NSFileModificationDate") {
                        dictFileData[key.rawValue] = value
                    }
                }
                
                dictFileData["text"] = try String(contentsOf: fileURL, encoding: .utf8)
                
                completion(true, dictFileData, "")
            } catch {
                completion(false, [:], "No data for file!")
            }
            
        } else {
            completion(false, [:], "Show file does not exists alert")
        }
    }
    
    func contentsOf(folder: URL) -> [URL] {
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: folder.path)
            
            let urls = contents.map { return folder.appendingPathComponent($0) }
            return urls
            
        } catch {
            return []
        }
    }
}
