//
//  ViewController.swift
//  DITABox
//
//  Created by Steven Suranie on 3/28/19.
//  Copyright © 2019 Steven Suranie. All rights reserved.
//

import Cocoa
import WebKit

class ViewController: NSViewController {
    @IBOutlet weak var btnLoadFile: NSButton!
    @IBOutlet weak var btnConvertFile: NSButton!
    @IBOutlet weak var tblFiles: NSTableView!
    @IBOutlet var txtFile: NSTextView!
    @IBOutlet weak var webkit: WKWebView!
    @IBOutlet weak var lblWebView: NSTextField!
    
    var arrFileList: [URL] = []
    var myModel = rootViewModel()
    var bIsSplit:Bool = false
    var fileBottom:CGFloat = 0
    
    var selectedFolder:URL? {
        
        didSet {
            if let selectedFolder = selectedFolder {
                arrFileList = myModel.contentsOf(folder: selectedFolder)
                
                self.tblFiles.reloadData()
                self.tblFiles.scrollRowToVisible(0)
                
            } else {
                print("The folder is empty")
            }
        }
    }
    
    var selectedItem: URL? {
        didSet {
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tblFiles.delegate = self
        tblFiles.dataSource = self
        //fileBottom = lcFileBottom.constant
    }
    
    //MARK - File Selection
    
    @IBAction func selectFiles(_ sender: Any) {
        
        //if we're not in the window, bail.
        guard let window = view.window else { return }
        
        //create NSOpenPanel instance and set properties
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        
        //
        panel.beginSheetModal(for: window) { (result) in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue {
                self.selectedFolder = panel.urls[0]
            }
        }
    }
    
    @IBAction func convertFiles(_ sender: Any) {
        
    }
    
    

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

//MARK: - TableView Extensions

extension ViewController: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return arrFileList.count
    }
    
}

extension ViewController: NSTableViewDelegate {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        let cell = tableView.makeView(withIdentifier: (tableColumn!.identifier), owner: self) as? NSTableCellView
        
        cell!.textField!.stringValue = arrFileList[row].lastPathComponent
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        myModel.getFileContents(arrFileList[tblFiles.selectedRow], completion: {bSuccess, dictFileData, strMsg in
            
            if (bSuccess) {
                if let strFile = dictFileData["text"] as? String {
                    txtFile.string = strFile
                    
                    //convert markdown to html and display preview
                    myModel.convertMDToHTML(arrFileList[tblFiles.selectedRow])
                }
                
            } else {
                print(strMsg)
            }
        })
    }
    
    
}


