//
//  ColorButton.swift
//  Amoo_LabelMaker
//
//  Created by Computer Science Swift on 10/21/26.
//


import SwiftUI


struct ColorButton: View {
    @State var color: Color
    var selectColor: (() -> Void)


    var body: some View {
        Button {
            selectColor()
        } label: {
            Circle()
                .foregroundStyle(color)
                .frame(height: 34)
        }
        .buttonBorderShape(.circle)
    }
}


#Preview {
    ColorButton(color: .cyan) {


    }
}
