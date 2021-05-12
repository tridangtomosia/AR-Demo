//
//  PickerColorView.swift
//  AR-RealityKit-Demo
//
//  Created by Tri Dang on 11/05/2021.
//

import SwiftUI

struct PickerColorForWallView: View {
    @Binding var isChanged: Bool?
    @Binding var color: UIColor?
    @Binding var isSelectedWall: Bool?
    var body: some View {
        VStack {
            HStack(spacing: 20) {
                Button(action: {
                    isChanged = true
                    isSelectedWall = false
                }, label: {
                    Text("Save")
                })
                Button(action: {
                    isChanged = false
                    isSelectedWall = false
                }, label: {
                    Text("Cancle")
                })
            }

            Spacer().frame(width: 1, height: 20)

            HStack(spacing: 20) {
                let colors: [UIColor] = [.white, .blue, .gray, .yellow]
                ForEach(0 ..< colors.count, id: \.self) { element in
                    Button(action: {
                        color = colors[element]
                    }, label: {
                        Text("color: \(element)")
                    })
                }
            }
        }
    }
}
