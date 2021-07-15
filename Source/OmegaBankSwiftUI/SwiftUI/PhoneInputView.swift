//
//  InputView.swift
//  OmegaBankSwiftUI
//
//  Created by Anna Kocheshkova on 13.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import SwiftUI
import UIKit

struct PhoneInputView: View {
    @Binding var phone: String
    
    var body: some View {
        VStack {
            Text("Your Phone")
            
            HStack {
                Text("+7")
                    .padding(.leading, 48)
                Divider()
                TextField("Phone", text: $phone)
                    .keyboardType(.phonePad)
            }
            .border(Color(.cellBorder))
            .frame(height: 50)
        }
    }
}

struct PhoneInputView_Previews: PreviewProvider {
    static var previews: some View {
        PhoneInputView(phone: .constant("9999999"))
    }
}
