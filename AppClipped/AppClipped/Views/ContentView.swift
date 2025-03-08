//
//  ContentView.swift
//  AppClipped
//
//  Created by Matt Heaney on 01/03/2025.
//

import SwiftUI

struct ContentView: View {

    @State private var selectedItem: Int = 0
    @State private var enteredURL: String = ""

    @State var selectedMode: SelectedMode = .camera
    @State var logoStyle: LogoStyle = .includeAppClipLogo
    @State private var selectedTab: Int = 0

    let labelWidth: CGFloat = 100

    @State private var backgroundColor: Color = .blue
    @State private var foregroundColor: Color = .white
    @State private var backgroundColourHex: String = ""
    @State private var foregroundColourHex: String = ""

    var body: some View {
        VStack(spacing: 16) {
            colourModeSelector()
            colourTabView()
            bottomSection()
            Spacer()
            buttonSection()
        }
    }

    //MARK: Views

    @ViewBuilder
    func colourModeSelector() -> some View {
        Picker("Colour Mode", selection: $selectedTab) {
            Text("Select Style").tag(0)
            Text("Custom Style").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    @ViewBuilder
    func colourTabView() -> some View {
        if selectedTab == 0 {
            setColourSelection()
        } else {
            customColourSelection()
        }
    }

    @ViewBuilder
    func customColourSelection() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Background Colour")
                    .frame(width: 200, alignment: .leading)
                    .bold()
                ColorPicker("", selection: $backgroundColor, supportsOpacity: false)
                    .labelsHidden()
            }

            HStack {
                Text("Foreground Colour")
                    .frame(width: 200, alignment: .leading)
                    .bold()
                ColorPicker("", selection: $foregroundColor, supportsOpacity: false)
                    .labelsHidden()
            }
        }
        .frame(height: 120)
        .padding(.vertical, 20)
    }

    @ViewBuilder
    func setColourSelection() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(0...17, id: \.self) { i in
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
    }

    @ViewBuilder
    func bottomSection() -> some View {
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
    }

    @ViewBuilder
    func buttonSection() -> some View {
        VStack(spacing: 16) {
            Divider()

            Button {
                print("\(backgroundColourHex), \(foregroundColourHex)")
                Task {

                    if selectedTab == 0 {
                        try await AppClipCodeGenerator().generateAppClipCode(
                            url: enteredURL,
                            index: selectedItem,
                            backgroundColour: nil,
                            foregroundColour: nil,
                            selectedMode: selectedMode,
                            logoStyle: logoStyle
                        )
                    } else {
                        try await AppClipCodeGenerator().generateAppClipCode(
                            url: enteredURL,
                            index: nil,
                            backgroundColour: backgroundColor.toHex() ?? "",
                            foregroundColour: foregroundColor.toHex() ?? "",
                            selectedMode: selectedMode,
                            logoStyle: logoStyle
                        )
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
