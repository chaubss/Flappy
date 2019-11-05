//
//  PhysicsCategory.swift
//  Flappy
//
//  Created by Arvind Chaubal on 1/22/16.
//  Copyright © 2016 Aryan Chaubal. All rights reserved.
//

struct PhysicsCategory {
    static let bird: UInt32 = 0x1 << 1
    static let ground: UInt32 = 0x1 << 2
    static let topPipe: UInt32 = 0x1 << 3
    static let btmPipe: UInt32 = 0x1 << 4
    static let scoreNode: UInt32 = 0x1 << 5

}
