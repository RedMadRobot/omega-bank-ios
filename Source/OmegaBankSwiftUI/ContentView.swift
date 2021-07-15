//
//  ContentView.swift
//  OmegaBankSwiftUI
//
//  Created by Anna Kocheshkova on 12.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var model = LoginViewModel()
    
    var body: some View {
        if model.isAuthenticated {
            CreatePincodeView()
        } else {
            LoginView(model: model)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
