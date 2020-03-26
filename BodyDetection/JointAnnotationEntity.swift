//
//  JointAnnotationEntity.swift
//  BodyDetection
//
//  Created by Nikhil Yerasi on 3/25/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import RealityKit
import UIKit

// following Apple's documentation at https://developer.apple.com/documentation/arkit/creating_screen_annotations_for_objects_in_an_ar_experience

/*
protocol HasScreenSpaceView: Entity {
    var screenSpaceComponent: ScreenSpaceComponent { get set }
}

struct ScreenSpaceComponent: Component {
    var view: JointView?
    //...
}

class JointView: UIView {
    var textView: UITextView!
    //...
}


class JointAnnotationEntity: Entity, HasAnchoring, HasScreenSpaceView {
    var screenSpaceComponent: ScreenSpaceComponent
    
    init(frame: CGRect, worldTransform: simd_float4x4) {
        super.init()
        self.transform.matrix = worldTransform
        // ...
    }
    
    // required by Entity subclasses
    required init() {
        fatalError("init() has not been implemented")
    }
    
}
 */
