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
    
    @StateObject var model = LoginViewModel()
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
                    switch model.stage {
                    case .phone:
                        PhoneInputView(phone: $model.phone)
                    case .sms(_):
                        CodeInputView(code: $model.code)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            
//            duration: Constants.transitionTime,
//            options: [.showHideTransitionViews]
        
            // TODO Make a separate view and pass state via @Binding?
            .navigationBarItems(leading:
                                    model.stage == .phone ? nil :
                                    Button(action: {
                                        model.stage = .phone
                                    }) {
                                        Text("Back")
                                            .font(Font(UIFont.body1))
                                            .foregroundColor( Color(.textPrimary))
                                    }, trailing: Button(action: {
                                        if model.stage == .phone {
                                            model.stage = .sms(phone: model.phone)
                                        } else {
                                            // TODO
                                        }
                                    }) {
                                        Text(model.trailingButtonTitle)
                                            .font(Font(UIFont.body1))
                                            .foregroundColor(model.isEnabled ? Color(.textPrimary) : nil)
                                            .colorScheme(.light)
                                            .disabled(!model.isEnabled)
                                    })
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

