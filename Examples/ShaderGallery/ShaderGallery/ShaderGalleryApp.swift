import SwiftUI

@main
struct ShaderGalleryApp: App {
    var body: some Scene {
        WindowGroup {
            GalleryView(initialPage: GalleryPage(launchArguments: ProcessInfo.processInfo.arguments))
                .tint(Color(red: 0, green: 0.443, blue: 0.89))  // #0071E3
        }
    }
}
