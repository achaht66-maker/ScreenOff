
import SwiftUI
import UIKit
import AVFoundation

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
                    .highPriorityGesture(
                        TapGesture(count: 2)
                            .onEnded {
                                exitBlackScreen()
                            }
                    )
            } else {
                Button(action: activateBlackScreen) {
                    Text("Activate Black Screen")
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                }
            }
        }
        .background(Color.black)
        .preferredColorScheme(.dark)
        .statusBarHidden(blackScreenActive)
        .onAppear {
            configureAudioMixing()
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

    private func configureAudioMixing() {
        do {
            try AVAudioSession.sharedInstance().setCategory(
                .ambient,
                mode: .default,
                options: [.mixWithOthers]
            )
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio configuration failed: \(error)")
        }
    }
}
