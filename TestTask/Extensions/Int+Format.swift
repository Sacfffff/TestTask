//
//  Int+Format.swift
//  TestTask
//
//  Created by Aleks Kravtsova on 3.09.22.
//

import Foundation

extension Int {
    
    func milisecondsToString() -> String {
       let seconds = self % 60
       let minutes = (self / 60) % 60
        return "\(minutes.correctFormatStrings()):\(seconds.correctFormatStrings())"
    }
    
    func correctFormatStrings() -> String {
        return self >= 10 ? "\(self)" : "0\(self)"
    }
}
