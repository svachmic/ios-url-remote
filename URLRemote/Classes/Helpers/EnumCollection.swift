//
//  EnumCollection.swift
//  URLRemote
//
//  Created by Michal Švácha on 16/01/17.
//  Copyright © 2017 Svacha, Michal. All rights reserved.
//

import Foundation

/// Protocol enabling listing all enum values in an array.
///
/// Inspired by article by @tiborbodecs available at:
/// https://theswiftdev.com/2017/01/05/18-swift-gist-generic-allvalues-for-enums/
protocol EnumCollection: Hashable {
    static var allValues: [Self] { get }
}

/// Extension implementing the allValues method.
extension EnumCollection {
    
    /// Helper function listing all cases in a sequence.
    ///
    /// - Returns: Sequence of all the cases as an object of the enum.
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(to: &raw) { $0.withMemoryRebound(to: S.self, capacity: 1) { $0.pointee } }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
    
    /// Computed variable with all cases in an array.
    static var allValues: [Self] {
        return Array(self.cases())
    }
}
