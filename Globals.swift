//
//  File.swift
//  DrehscheibenRegelung
//
//  Created by Niklas Mischke on 28.04.22.
//

import Foundation
import SwiftUI

let bounds = UIScreen.main.bounds
let defaults = UserDefaults.standard

let defaultsKey = "Tracks"

let heightOffset = 170
//let angleOffset: Angle = Angle.degrees(90)

let width = bounds.width
let height = bounds.height - CGFloat(heightOffset)

let widthCenter = width / 2
let heightCenter = height / 2
