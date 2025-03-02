//
//  ContentView.swift
//  AppClipped
//
//  Created by Matt Heaney on 01/03/2025.
//

import SwiftUI


struct ContentView: View {
    let items = Array(0...17)
    @State private var selectedItem: Int = 0
    @State private var enteredURL: String = "https://example.com"

    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    Text("Select Style")
                        .font(.largeTitle)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(items, id: \.self) { i in
                                Image("AppClipStyle\(i)")
                                    .resizable()
                                    .frame(width: 120, height: 120)
                                    .background(Color.blue.opacity(0.7))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(selectedItem == i ? Color.blue : Color.clear, lineWidth: 4)
                                    )
                                    .onTapGesture {
                                        selectedItem = i
                                    }
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    Divider()

                    VStack {
                        Text("Enter Url")
                            .font(.largeTitle)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 16)

                        TextField("", text: $enteredURL)
                            .padding(.horizontal, 16)
                    }
                }
                .padding(.vertical, 16)
            }

            Spacer()

            Divider()

            Button {
                AppClipCodeGenerator().generateAppClipCode(url: enteredURL, index: selectedItem) { _ in
                    
                }
            } label: {
                Text("Generate App Clip Code")
            }
            .padding(.vertical, 16)
        }
    }
}

#Preview {
    ContentView()
}
