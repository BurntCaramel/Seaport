//
//  GitHubReader.swift
//  Seaport
//
//  Created by Patrick Smith on 22/9/21.
//

import Foundation
import Combine

class GitHubRepoReader: ObservableObject {
	var ownerName = ""
	var repoName = ""
	
	@Published var refs: Refs?
	
//	init(ownerName: String, repoName: String) {
//		self.ownerName = ownerName
//		self.repoName = repoName
//	}
	
	struct Input {
		var ownerName = ""
		var repoName = ""
	}
	
	struct Refs {
//		var ownerName: String
//		var repoName: String
		var headRef: String?
		var refs: Array<(ref: String, oid: String)>
		
		init?(pktLine: Data) {
			headRef = nil
			refs = []
//			let first = pktLine[0..<4]
//			guard let lengthHex = String(data: pktLine.prefix(4), encoding: .utf8) else { return nil }
//			let scanner = Scanner(string: lengthHex)
//			var length: UInt32 = 0
//			guard scanner.scanHexInt32(&length) else { return nil }
//			guard let length = scanner.scanInt32(representation: .hexadecimal) else { return nil }
			
			guard let string = String(data: pktLine, encoding: .utf8) else { return nil }
//			let substring = string[string.startIndex..<string.endIndex]
			let scanner = Scanner(string: string)
			while true {
				guard let length = scanner.scanInt32(representation: .hexadecimal) else { return nil }
	//			scanner.currentIndex
				let lineEndIndex = string.index(scanner.currentIndex, offsetBy: String.IndexDistance(length))
				let line = string[scanner.currentIndex..<lineEndIndex]
				scanner.currentIndex = lineEndIndex
				let parts = line.split(separator: " ")
				let oid = parts[0]
				let rawRef = parts[1]
				
				refs.append((ref: String(rawRef), oid: String(oid)))
			}
			
		}
		
		static func url(ownerName: String, repoName: String) -> URL? {
			let ownerName = ownerName.trimmingCharacters(in: .whitespacesAndNewlines)
			let repoName = repoName.trimmingCharacters(in: .whitespacesAndNewlines)
			guard ownerName.count > 0 && repoName.count > 0 else { return nil }
			return URL(string: "https://github.com/\(ownerName)/\(repoName).git/info/refs?service=git-upload-pack")
		}
		
		static func fetch(ownerName: String, repoName: String) -> AnyPublisher<Self?, Never> {
			guard let url = url(ownerName: ownerName, repoName: repoName) else { return Just(nil).eraseToAnyPublisher() }

			return URLSession.shared.dataTaskPublisher(for: url)
				.map { $0.data }
				.map { Refs(pktLine: $0) }
				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)
				.eraseToAnyPublisher()
		}
	}
	
	public func load() {
		Refs.fetch(ownerName: ownerName, repoName: repoName).assign(to: &$refs)
	}
}
