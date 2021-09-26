//
//  ContentView.swift
//  Shared
//
//  Created by Patrick Smith on 22/2/21.
//

import SwiftUI

let byteCountFormatter = ByteCountFormatter()

struct SearchView: View {
	@State var searchTerm = ""
	@StateObject var moduleSearcher = ModulerSearcher()
	
	@State var ownerName = ""
	@State var repoName = ""
	@StateObject var gitHubRepoReader = GitHubRepoReader()
	
	func loadRepo() {
		gitHubRepoReader.ownerName = ownerName
		gitHubRepoReader.repoName = repoName
		gitHubRepoReader.load()
	}
	
	var body: some View {
		VStack {
			Form {
				Section(header: Text("Fetch GitHub repo:")) {
					TextField("Owner", text: $ownerName)
					TextField("Repo", text: $repoName)
				}
				
				Section {
					Button("Search", action: loadRepo)
						.keyboardShortcut(.defaultAction)
				}.frame(alignment: .center).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
			}.padding().layoutPriority(1)
			
			GitHubRepoResultsView(ownerName: ownerName, repoName: repoName, refs: gitHubRepoReader.refs)
			
			Form {
				Section(header: Text("Search npm packages:")) {
					TextField("Name", text: $moduleSearcher.query)
				}
				
				Section {
					Button("Search", action: moduleSearcher.load)
						.keyboardShortcut(.defaultAction)
				}.frame(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/).border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
			}.padding().layoutPriority(1)
			
//			Spacer()
			
			NPMSearchResultsView(
				searchTerm: moduleSearcher.query,
				npmDownloadsResult: moduleSearcher.npmDownloadsResult,
				bundlephobiaResult: moduleSearcher.bundlephobiaResult
			)
		}
	}
}

struct NPMSearchResultsView: View {
	var searchTerm: String
	var npmDownloadsResult: ModulerSearcher.NPMDownloads?
	var bundlephobiaResult: ModulerSearcher.Bundlephobia?
	
	var body: some View {
		VStack {
			if let npmDownloadsResult = npmDownloadsResult {
				Section(header: Text("NPM")) {
					if let url = URL(string: "https://npmjs.com/package/\(npmDownloadsResult.package)") {
						Link("NPM Link", destination: url)
					}
					
					GroupBox(label: Label("Downloads", systemImage: "arrow.down.circle.fill")) {
						Text("\(npmDownloadsResult.downloads)")
					}
				}
			}
			
			if let bundlephobiaResult = bundlephobiaResult {
				Section(header: Text("Bundlephobia")) {
					if let url = URL(string: "https://bundlephobia.com/result?p=\(bundlephobiaResult.name)") {
						Link("Bundlephobia Link", destination: url)
					}
					
					GroupBox(label: Label("Minified Size", systemImage: "doc.text")) {
						Text("\(Measurement(value: Double(bundlephobiaResult.size), unit: UnitInformationStorage.bytes), formatter: byteCountFormatter)")
					}
					
					GroupBox(label: Label("Gzipped & Minified Size", systemImage: "doc.zipper")) {
						Text("\(Measurement(value: Double(bundlephobiaResult.gzip), unit: UnitInformationStorage.bytes), formatter: byteCountFormatter)")
					}
				}
			}
		}
	}
}

struct GitHubRepoResultsView: View {
	var ownerName: String
	var repoName: String
	var refs: GitHubRepoReader.Refs?
	
	var body: some View {
		VStack {
			if let refs = refs {
				Section(header: Text("Refs")) {
					ForEach(refs.refs, id: \.ref) { ref in
						Text("\(ref.ref)")
						Text("\(ref.oid)")
					}
				}
			}
		}
	}
}

struct ContentView: View {
	var body: some View {
		SearchView()
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		SearchView()
	}
}
