//
//  ContentView.swift
//  AppClipped
//
//  Created by Matt Heaney on 01/03/2025.
//

import SwiftUI

struct ContentView: View {

    @State private var enteredURL: String = ""

    @State private var selectedColorModeTab: Int = 0
    @State private var selectedColorIndexItem: Int = 0
    @State private var customBackgroundColor: Color = .blue
    @State private var customForegroundColor: Color = .white

    @State var selectedMode: SelectedMode = .camera
    @State var logoStyle: LogoStyle = .includeAppClipLogo

    let labelWidth: CGFloat = 100

    let appClipCodeManager = AppClipCodeManager()

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
        Picker("Colour Mode", selection: $selectedColorModeTab) {
            Text("Select Style").tag(0)
            Text("Custom Style").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    @ViewBuilder
    func colourTabView() -> some View {
        if selectedColorModeTab == 0 {
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
                ColorPicker("", selection: $customBackgroundColor, supportsOpacity: false)
                    .labelsHidden()
            }

            HStack {
                Text("Foreground Colour")
                    .frame(width: 200, alignment: .leading)
                    .bold()
                ColorPicker("", selection: $customForegroundColor, supportsOpacity: false)
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
                                .stroke(selectedColorIndexItem == i ? Color.blue : Color.clear, lineWidth: 4)
                        )
                        .onTapGesture {
                            selectedColorIndexItem = i
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
                Task {
                    var selectedColorMode: SelectedColorMode {
                        if selectedColorModeTab == 0 {
                            return .index(indexID: selectedColorIndexItem)
                        } else {
                            return .custom(foregroundColour: customBackgroundColor,
                                           backgroundColor: customForegroundColor)
                        }
                    }

                    try await appClipCodeManager.generateAppClipCode(
                        url: enteredURL,
                        selectedColorMode: selectedColorMode,
                        selectedMode: selectedMode,
                        logoStyle: logoStyle
                    )
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
