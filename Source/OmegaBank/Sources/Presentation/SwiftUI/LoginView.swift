//
//  LoginView.swift
//  OmegaBankSwiftUI
//
//  Created by Anna Kocheshkova on 12.07.2021.
//  Copyright © 2021 RedMadRobot. All rights reserved.
//

import SwiftUI
import UIKit

struct LoginView: View {
    
    var isEnabled: Bool {
        switch stage {
        case .phone:
            return phone.count > 6
        case .sms(_):
            return code.count > 3
        }
    }
    @State var stage: LoginState = .phone
    @State var phone: String = ""
    @State var code: String = ""
    
    var trailingButtonTitle: String {
        switch stage {
        case .phone:
            return "Next"
        case .sms(_):
            return "Login"
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    LoginBackground().frame(height: 220)
                    Spacer()
                }
                VStack {
                    HStack(alignment: .center) {
                        Text("Sign Up")
                            .font(Font(UIFont.header1))
                            .foregroundColor(Color(.textPrimary))
                    }.padding(.top, 70)
                    
                    Spacer()
                }
                VStack(alignment: .center) {
                    switch stage {
                    case .phone:
                        PhoneInputView(phone: $phone)
                    case .sms(_):
                        CodeInputView(code: $code)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
        
            // TODO Make a separate view and pass state via @Binding?
            .navigationBarItems(leading:
                                    stage == .phone ? nil :
                                    Button(action: {
                                        stage = .phone
                                    }) {
                                        Text("Back")
                                            .font(Font(UIFont.body1))
                                            .foregroundColor( Color(.textPrimary))
                                    }, trailing: Button(action: {
                                        if stage == .phone {
                                            stage = .sms(phone: phone)
                                        } else {
                                            // TODO
                                        }
                                    }) {
                                        Text(trailingButtonTitle)
                                            .font(Font(UIFont.body1))
                                            .foregroundColor(isEnabled ? Color(.textPrimary) : nil)
                                            .colorScheme(.light)
                                            .disabled(!isEnabled)
                                    })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

