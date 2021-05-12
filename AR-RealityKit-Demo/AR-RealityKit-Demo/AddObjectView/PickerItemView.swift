//
//  PickerObjectView.swift
//  AR-RealityKit-Demo
//
//  Created by Tri Dang on 11/05/2021.
//

import SwiftUI

struct PickerItemView: View {
    @Binding var modelSelected: String?
    @Binding var isChangeWall: Bool?
    @Binding var isChangeObject: Bool?
    var models: [String]
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false, content: {
            HStack(spacing: 30) {
                ForEach(0 ..< models.count, id: \.self) { i in
                    Button(action: {
                        if models[i] == "wall" || models[i] == "background" {
                            isChangeWall = true
                        } else {
                            isChangeObject = true
                        }
                        self.modelSelected = models[i]
                    }, label: {
                        Image(models[i])
                            .resizable()
                            .frame(height: 50)
                            .aspectRatio(1, contentMode: .fit)
                    })
                }
            }
        })
            .padding(20)
            .background(Color(.black).opacity(0.5))
    }
}

//struct PickerObjectView_Previews: PreviewProvider {
//    static var previews: some View {
//        PickerObjectView()
//    }
//}
