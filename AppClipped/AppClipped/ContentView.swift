//
//  ContentView.swift
//  AppClipped
//
//  Created by Matt Heaney on 01/03/2025.
//

import SwiftUI

enum SelectedMode: String {
    case camera = "cam"
    case nfc = "nfc"
}

enum LogoStyle: String {
    case includeAppClipLogo = "includeAppClipLogo"
    case doNotIncludeAppClipLogo = "doNotIncludeAppClipLogo"

    var showLogoParameter: String {
        switch self {
        case .includeAppClipLogo:
            return "badge"
        case .doNotIncludeAppClipLogo:
            return "none"
        }
    }
}

struct ContentView: View {
    let items = Array(0...17)
    @State private var selectedItem: Int = 0
    @State private var enteredURL: String = "https://example.com"

    @State var selectedMode: SelectedMode = .camera
    @State var logoStyle: LogoStyle = .includeAppClipLogo

    var body: some View {
        VStack {
            ScrollView {
                VStack {

                    Text("Create your app clip")
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
                        LabeledContent {
                            TextField("Enter URL", text: $enteredURL)
                        } label: {
                            Text("URL")
                        }

                        Picker("App Clip Type", selection: $selectedMode) {
                            Text("Camera").tag(SelectedMode.camera)
                            Text("NFC").tag(SelectedMode.nfc)
                        }

                        Picker("Logo Type", selection: $logoStyle) {
                            Text("Show App Clip Logo").tag(LogoStyle.includeAppClipLogo)
                            Text("Do Not Show App Clip Logo").tag(LogoStyle.doNotIncludeAppClipLogo)
                        }

                    }
                    .padding(.horizontal, 16)
                }
                .padding(.vertical, 16)
            }

            Spacer()

            Divider()

            Button {
                AppClipCodeGenerator().generateAppClipCode(url: enteredURL,
                                                           index: selectedItem,
                                                           selectedMode: selectedMode,
                                                           logoStyle: logoStyle) { result in
                    print("result: \(result)")
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
