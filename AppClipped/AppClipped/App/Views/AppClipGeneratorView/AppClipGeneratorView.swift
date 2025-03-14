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
            Text("Logo Based").tag(2)
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 16)
        .padding(.top, 16)
    }

    @ViewBuilder
    func colourTabView() -> some View {
        if viewModel.selectedColorModeTab == 0 {
            SetColourSelection(selectedColorIndexItem: $viewModel.selectedColorModeTab)
        } else if viewModel.selectedColorModeTab == 1 {
            CustomColourSelection(customForegroundColor: $viewModel.customForegroundColor,
                                  customBackgroundColor: $viewModel.customBackgroundColor)
        } else {
            LogoBasedColorSelection(customForegroundColor: $viewModel.customForegroundColor,
                                    customBackgroundColor: $viewModel.customBackgroundColor)
        }
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
