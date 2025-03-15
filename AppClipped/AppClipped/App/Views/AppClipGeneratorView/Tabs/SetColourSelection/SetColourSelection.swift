//
//  SetColourSelection.swift
//  AppClipped
//
//  Created by Matt Heaney on 14/03/2025.
//

import SwiftUI

struct SetColourSelection: View {

    //MARK: Dependancies
    @State var viewModel: SetColourSelectionViewModel

    //MARK: Body
    var body: some View {

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

}
