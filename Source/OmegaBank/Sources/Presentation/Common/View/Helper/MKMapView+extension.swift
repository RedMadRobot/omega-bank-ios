//
//  MKMapView+extension.swift
//  OmegaBank
//
//  Created by Konsantin Makhov on 09.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import MapKit

extension MKMapView {

    func registerAnnotationView<T>(_ viewType: T.Type) where T: MKAnnotationView {
        register(viewType, forAnnotationViewWithReuseIdentifier: String(describing: viewType.self))
    }

    func dequeueReusableView<T>(_ viewType: T.Type, for annotation: MKAnnotation) -> T where T: MKAnnotationView {
        
        let anyView = dequeueReusableAnnotationView(
            withIdentifier: String(describing: viewType.self),
            for: annotation)

        guard let view = anyView as? T else {
            fatalError("Unexpected cell type \(anyView)")
        }

        return view
    }
}
