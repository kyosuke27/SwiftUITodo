//
//  TestView.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/06.
//

import SwiftUI

struct TestView: View {
    @State private var text = ""
    @State private var showDialog = false
    @State private var showImage = false
    @State private var opacity :Double = 0.0
    var body: some View {
        ZStack{
            Color("TodoListBackgroundColor")
                .edgesIgnoringSafeArea(.all)
        VStack{
            Text("Hello, World!")
        }    
        }
    }
}

#Preview {
    TestView()
}
