//
//  StartView.swift
//  Amoo_imageGenApp
//
//  Created by Computer Science Swift on 9/28/26.
//


import SwiftUI
import ImagePlayground


struct StartView: View {
    @Environment(AppManager.self) private var appManager


    var body: some View {
        @Bindable var imageGenerator = appManager.imageGenerator


        VStack(alignment: .leading, spacing: 16) {
            Text("Create a Unique Dish")
                .font(.largeTitle.weight(.semibold))
                .frame(maxWidth: .infinity, alignment: .center)


            Label("Choose a dish", systemImage: "fork.knife")
                .padding(.top, 8)
            Picker("Recipes", selection: $imageGenerator.recipe) {
                ForEach(ImageGenerator.recipes, id: \.self) { recipe in
                    Text(recipe)
                        .tag(recipe)
                }
            }


            Label("Choose an image style", systemImage: "paintpalette.fill")
                .padding(.top, 8)
            Picker("Styles", selection: $imageGenerator.style) {
                ForEach(ImageGenerator.styles) { style in
                    Text(style.id.capitalized)
                        // The selection is ImagePlaygroundStyle?, so the tag
                        // must be optional too or the binding never matches.
                        .tag(style as ImagePlaygroundStyle?)
                }
            }


            Spacer()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Generate Image") {
                    appManager.generateImage()
                }
                .buttonStyle(.glassProminent)
                .disabled(appManager.imageGenerator.style == nil)
            }
        }
        .pickerStyle(.segmented)
        .labelsHidden()
        .frame(width: ImageGenerator.imageSize)
        .padding()
    }
}


#Preview {
    StartView()
        .previewEnvironment()
}
