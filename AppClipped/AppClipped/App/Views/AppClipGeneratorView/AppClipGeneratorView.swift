//
//  AppClipGeneratorView.swift
//  AppClipped
//
//  Created by Matt Heaney on 01/03/2025.
//

import SwiftUI

struct AppClipGeneratorView: View {

    //MARK: Dependancies

    @State var viewModel = AppClipGeneratorViewModel()

    //MARK: Body

    var body: some View {
        VStack(spacing: 16) {
            colourModeSelector()
            colourTabView()
            bottomSection()
            Spacer()
            buttonSection()
        }
    }

    //MARK: Views - Color Tab

    @ViewBuilder
    func colourModeSelector() -> some View {
        Picker("Colour Mode", selection: $viewModel.selectedColorModeTab) {
            Text("Select Style").tag(0)
            Text("Custom Style").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    @ViewBuilder
    func colourTabView() -> some View {
        if viewModel.selectedColorModeTab == 0 {
            setColourSelection()
        } else {
            customColourSelection()
        }
    }

    //MARK: Views - Color Tab Views

    @ViewBuilder
    func customColourSelection() -> some View {
        VStack(spacing: 12) {
            HStack {
                Text("Background Colour")
                    .frame(width: 200, alignment: .leading)
                    .bold()
                ColorPicker("", selection: $viewModel.customBackgroundColor, supportsOpacity: false)
                    .labelsHidden()
            }

            HStack {
                Text("Foreground Colour")
                    .frame(width: 200, alignment: .leading)
                    .bold()
                ColorPicker("", selection: $viewModel.customForegroundColor, supportsOpacity: false)
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
                                .stroke(viewModel.selectedColorIndexItem == i ? Color.blue : Color.clear, lineWidth: 4)
                        )
                        .onTapGesture {
                            viewModel.selectedColorIndexItem = i
                        }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 20)
    }

    //MARK: Views - Bottom Bar

    @ViewBuilder
    func bottomSection() -> some View {
        VStack {
            HStack {
                Text("URL")
                    .frame(width: 100, alignment: .leading)
                    .bold()
                TextField("Enter URL", text: $viewModel.enteredURL)
                    .textFieldStyle(.roundedBorder)
                    .padding(.leading, 8)
            }

            HStack {
                Text("App Clip Type")
                    .frame(width: 100, alignment: .leading)
                    .bold()
                Picker("", selection: $viewModel.selectedMode) {
                    Text("Camera").tag(ModeType.camera)
                    Text("NFC").tag(ModeType.nfc)
                }
                .pickerStyle(SegmentedPickerStyle())
            }

            HStack {
                Text("Logo Type")
                    .frame(width: 100, alignment: .leading)
                    .bold()
                Picker("", selection: $viewModel.logoStyle) {
                    Text("Show App Clip Logo").tag(LogoType.logoIncluded)
                    Text("Do Not Show App Clip Logo").tag(LogoType.logoNotIncluded)
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

            errorMessage()

            Button {
                Task {
                    await viewModel.generateAppClipCode()
                }
            } label: {
                Group {
                    switch viewModel.state {
                    case .ready, .error(_):
                        Text("Generate App Clip Code")
                    case .loading:
                        ProgressView()
                            .scaleEffect(0.5)
                    }
                }.frame(width: 200, height: 30)
            }
            .disabled(viewModel.state == .loading)

            if viewModel.shouldShowInstallationMessage {
                Text("AppClipCodeGenerator from Apple is required to use this tool. Please download it from https://developer.apple.com/download")
                    .font(.caption2)
            }
        }
        .padding(.vertical, 16)
    }

    @ViewBuilder
    func errorMessage() -> some View {
        switch viewModel.state {
        case .error(let error):
            Text("Something went wrong - \(error.localizedDescription)")
                .font(.caption2)
                .foregroundStyle(Color.red)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .fixedSize(horizontal: false, vertical: false)
        default: EmptyView()
        }
    }
}
