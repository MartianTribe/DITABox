//
//  ScriptManager.swift
//  DITABox
//
//  Created by Steven Suranie on 3/29/19.
//  Copyright © 2019 Steven Suranie. All rights reserved.
//

import Foundation
import Swift

struct scriptManager {
    
    typealias scriptClosure = (Bool, String, String) -> Void
    
    func convertMDToHTML(_ fileURL:URL, completion:scriptClosure) {
        
        //clear file from path
        let path = fileURL.deletingLastPathComponent().relativePath
        
        //set new filename
        let strNewFileName = fileURL.deletingPathExtension().lastPathComponent.appending(".html")
        
        //check if html folder exists
        var isDir: ObjCBool = ObjCBool(true)
        let bHasHTMLFolder:Bool = FileManager.default.fileExists(atPath: path, isDirectory: &isDir)
        
        if !bHasHTMLFolder {
            let htmlFileURL = fileURL.appendingPathComponent("html", isDirectory: true)
            let htmlPath = htmlFileURL.path
            do {
                try FileManager.default.createDirectory(atPath: htmlPath, withIntermediateDirectories: true, attributes: nil)
            } catch {
               print(error.localizedDescription)
            }
        }
        
        //set storage path
        let storagePath = path + "/html/" + strNewFileName
        
        //create script
        var strScript = "pandoc -s -o "
        strScript.append(storagePath)
        strScript.append(" ")
        strScript.append(fileURL.absoluteString)
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        var documentPath:URL = URL(fileURLWithPath: documentsPath)
        documentPath.appendPathComponent("pandoc.sh")
        
        do {
            
            let scriptArguments = ["/usr/local/bin/pandoc", "-s", "-o", storagePath, fileURL.path]
            
            let documentsURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let scriptURL = documentsURL.appendingPathComponent("pandoc.sh")
            
            try strScript.write(to: scriptURL, atomically: true, encoding: .utf8)
            
            let myTask = Process()
            
            myTask.launchPath = "/usr/bin/env"
            myTask.arguments = scriptArguments
            
            let myPipe = Pipe()
            myTask.standardOutput = myPipe
            
            myTask.launch()
            
            let data = myPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)
            
            completion(true, storagePath, output!)
            
        } catch {
            print(error.localizedDescription)
        }
        
        
        
        
    }
    
    
    
}
