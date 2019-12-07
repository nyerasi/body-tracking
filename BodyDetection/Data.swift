//
//  Data.swift
//  BodyDetection
//
//  Created by Nikhil Yerasi on 12/6/19.
//  Copyright © 2019 Apple. All rights reserved.
//

import Foundation
import UIKit

struct Person {
    let name: String!
    let affiliation: String!
    let profileImage: UIImage!
}

class Data {
    // update var as needed!
    public var people = [
        Person(name: "Nikhil Yerasi", affiliation: "B.A. Data Science", profileImage: UIImage(named: "nik")),
        Person(name: "Caroline Liu", affiliation: "B.S. EECS", profileImage: UIImage(named: "caroline")),
        Person(name: "Mathias Vissers", affiliation: "Master's Translational Medicine", profileImage: UIImage(named: "mathias")),
        Person(name: "Wei-Kai Lin", affiliation: "Master's Translational Medicine", profileImage: UIImage(named: "wei-kai"))
    ]
}
