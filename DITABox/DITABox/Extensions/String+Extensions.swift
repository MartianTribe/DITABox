//
//  String+Extensions.swift
//  DITABox
//
//  Created by Steven Suranie on 3/29/19.
//  Copyright © 2019 Steven Suranie. All rights reserved.
//

import Foundation

extension String {
    var lines: [String] {
        var result: [String] = []
        enumerateLines { line, _ in result.append(line) }
        return result
    }
}
