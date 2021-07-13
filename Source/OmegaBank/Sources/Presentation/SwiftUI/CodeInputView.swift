//
//  CodeInputView.swift
//  OmegaBankSwiftUI
//
//  Created by Anna Kocheshkova on 13.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import SwiftUI
import UIKit

struct CodeInputView: View {
    @Binding var code: String
    
    var body: some View {
        VStack() {
            Text("Enter Code")
            HStack() {
                TextField("Code", text: $code)
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .padding(16)
            }
            .border(Color(.cellBorder))
            .frame(height: 50)
        }
    }
}

struct CodeInputView_Previews: PreviewProvider {
    static var previews: some View {
        CodeInputView(code: .constant("2222"))
    }
}
