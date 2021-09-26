//
//  SeaportApp.swift
//  Shared
//
//  Created by Patrick Smith on 22/2/21.
//

import SwiftUI

@main
struct SeaportApp: App {
	var body: some Scene {
		WindowGroup {
			ContentView()
			#if os(macOS)
				.frame(minWidth: 400, idealWidth: 600, minHeight: 450, idealHeight: 800)
			#endif
		}
	}
}
