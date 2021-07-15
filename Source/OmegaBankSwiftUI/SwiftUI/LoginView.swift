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
                    LoginBackground()
                        .frame(height: 220)
                    Spacer()
                }
                VStack {
                    HStack(alignment: .center) {
                        Text("Sign Up")
                            .font(Font(UIFont.header1))
                            .foregroundColor(Color(.textPrimary))
                    }
                    .padding(.top, 70)
                    
                    Spacer()
                }
                
                VStack(alignment: .center) {
                    switch model.stage {
                    case .phone:
                        PhoneInputView(phone: $model.thePhone)
                    case .sms(_):
                        CodeInputView(code: $model.code)
                    }
                }
                .alert(isPresented: $model.hasError) {
                    Alert(title: Text("Error"),
                          message: Text(model.error ?? ""),
                          dismissButton: .default(Text("OK")) {
                            model.hasError = false
                          })
                }
            }
            .ignoresSafeArea(edges: .top)
            
            // TODO Make a separate view and pass state via @Binding?
            .navigationBarItems(leading:
                                    model.stage == .phone ? nil :
                                    Button(action: {
                                        model.goBack()
                                    }) {
                                        Text("Back")
                                            .font(Font(UIFont.body1))
                                            .foregroundColor( Color(.textPrimary))
                                    }, trailing: Button(action: {
                                        model.goNextStage()
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

