import SwiftUI
import UIKit

struct ContentView: View {
    @State private var blackScreenActive = true
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()

            if blackScreenActive {
                Color.black
                    .ignoresSafeArea()
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        exitBlackScreen()
                    }
            } else {
                Button {
                    activateBlackScreen()
                } label: {
                    Text("Activate Black Screen")
                        .foregroundColor(.white)
                }
            }
        }
        .preferredColorScheme(.dark)
        .onAppear {
            updateIdleTimer()
        }
        .onChange(of: blackScreenActive) { _ in
            updateIdleTimer()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase != .active {
                exitBlackScreen()
            }
        }
    }

    private func activateBlackScreen() {
        blackScreenActive = true
    }

    private func exitBlackScreen() {
        blackScreenActive = false
    }

    private func updateIdleTimer() {
        UIApplication.shared.isIdleTimerDisabled = blackScreenActive
    }
}
