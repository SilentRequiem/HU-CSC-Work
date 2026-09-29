import SwiftUI


@main
struct MyApp: App {
    @State var appManager = AppManager()


    var body: some Scene {
        Window("ImageGenerator", id: "main") {
            ContentView()
                .environment(appManager)
        }
        .commands {
            CommandMenu("Actions") {
                ImageButtonsView(displayForMenu: true)
                    .environment(appManager)
            }
        }
    }
}
