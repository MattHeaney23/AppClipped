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
    @State private var selectedTab: Int = 0

    let labelWidth: CGFloat = 100 // Adjust this to fit the longest label

    @State private var backgroundColor: Color = .blue
    @State private var foregroundColor: Color = .white
    @State private var backgroundColourHex: String = ""
    @State private var foregroundColourHex: String = ""

    var body: some View {
        VStack(spacing: 16) {
            // Segmented Control for Tab Selection
            Picker("Colour Mode", selection: $selectedTab) {
                Text("Select Style").tag(0)
                Text("Custom Style").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 16)
            .padding(.top, 16)

            // Tab Views
            if selectedTab == 0 {
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
                .padding(.vertical, 20)
            } else {
                VStack(spacing: 12) {
                    HStack {
                        Text("Background Colour")
                            .frame(width: 200, alignment: .leading)
                            .bold()
                        ColorPicker("", selection: $backgroundColor, supportsOpacity: false)
                            .labelsHidden()
                            .onChange(of: backgroundColor) { _ in
                                backgroundColourHex = backgroundColor.toHex() ?? ""
                            }
                    }

                    HStack {
                        Text("Foreground Colour")
                            .frame(width: 200, alignment: .leading)
                            .bold()
                        ColorPicker("", selection: $foregroundColor, supportsOpacity: false)
                            .labelsHidden()
                            .onChange(of: foregroundColor) { _ in
                                foregroundColourHex = foregroundColor.toHex() ?? ""
                            }
                    }
                }
                .frame(height: 120)
                .padding(.vertical, 20)
            }

            VStack {
                HStack {
                    Text("URL")
                        .frame(width: labelWidth, alignment: .leading)
                        .bold()
                    TextField("Enter URL", text: $enteredURL)
                        .textFieldStyle(.roundedBorder)
                        .padding(.leading, 8)
                }

                HStack {
                    Text("App Clip Type")
                        .frame(width: labelWidth, alignment: .leading)
                        .bold()
                    Picker("", selection: $selectedMode) {
                        Text("Camera").tag(SelectedMode.camera)
                        Text("NFC").tag(SelectedMode.nfc)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                HStack {
                    Text("Logo Type")
                        .frame(width: labelWidth, alignment: .leading)
                        .bold()
                    Picker("", selection: $logoStyle) {
                        Text("Show App Clip Logo").tag(LogoStyle.includeAppClipLogo)
                        Text("Do Not Show App Clip Logo").tag(LogoStyle.doNotIncludeAppClipLogo)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding(.horizontal, 16)

            Spacer()

            Divider()

            Button {

                print("\(backgroundColourHex), \(foregroundColourHex)")

                if selectedTab == 0 {
                    AppClipCodeGenerator().generateAppClipCode(
                        url: enteredURL,
                        index: selectedItem,
                        backgroundColour: nil,
                        foregroundColour: nil,
                        selectedMode: selectedMode,
                        logoStyle: logoStyle
                    ) { result in
                        print("result: \(result)")
                    }
                } else {
                    AppClipCodeGenerator().generateAppClipCode(
                        url: enteredURL,
                        index: nil,
                        backgroundColour: backgroundColor.toHex() ?? "",
                        foregroundColour: foregroundColor.toHex() ?? "",
                        selectedMode: selectedMode,
                        logoStyle: logoStyle
                    ) { result in
                        print("result: \(result)")
                    }
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


extension Color {
    func toHex() -> String? {
        guard let nsColor = NSColor(self).usingColorSpace(.sRGB) else { return nil }
        let r = Int(nsColor.redComponent * 255)
        let g = Int(nsColor.greenComponent * 255)
        let b = Int(nsColor.blueComponent * 255)
        return String(format: "%02X%02X%02X", r, g, b) // Returns hex without #
    }
}
