//
//  ModuleSearcher.swift
//  Seaport
//
//  Created by Patrick Smith on 23/2/21.
//

import Foundation
import Combine

class ModulerSearcher: ObservableObject {
	var query = ""
	
	@Published var npmDownloadsResult: NPMDownloads?
	@Published var bundlephobiaResult: Bundlephobia?
	
	struct NPMDownloads: Decodable {
		let downloads: Int
		let start: String
		let end: String
		let package: String
		
		static func url(query: String) -> URL? {
			guard query.count > 0 else { return nil }
			
			return URL(string: "https://api.npmjs.org/downloads/point/last-month/\(query)")
		}
		
		static func fetch(query: String) -> AnyPublisher<Self?, Never> {
			guard let url = url(query: query) else { return Just(nil).eraseToAnyPublisher() }
			
			return URLSession.shared.dataTaskPublisher(for: url)
				.map { $0.data }
				.decode(type: Self.self, decoder: JSONDecoder())
				.map { Optional.some($0) }
				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)
				.eraseToAnyPublisher()
		}
	}
	
	struct Bundlephobia: Decodable {
		let name: String
		let description: String
		let version: String
		let repository: URL
		let size: Int
		let gzip: Int
		let hasJSModule: Bool
		let hasJSNext: Bool
		let hasSideEffects: Bool
		let dependencyCount: Int
		
		static func url(query: String) -> URL? {
			guard query.count > 0 else { return nil }
			
			return URL(string: "https://bundlephobia.com/api/size?package=\(query)")
		}
		
		static func fetch(query: String) -> AnyPublisher<Self?, Never> {
			guard let url = url(query: query) else { return Just(nil).eraseToAnyPublisher() }
			
			return URLSession.shared.dataTaskPublisher(for: url)
				.map { $0.data }
				.decode(type: Self.self, decoder: JSONDecoder())
				.map { Optional.some($0) }
				.replaceError(with: nil)
				.receive(on: DispatchQueue.main)
				.eraseToAnyPublisher()
		}
	}
	
	public func load() {
		conformQuery()
		
		NPMDownloads.fetch(query: query).assign(to: &$npmDownloadsResult)
		Bundlephobia.fetch(query: query).assign(to: &$bundlephobiaResult)
	}
	
	private func conformQuery() {
		query = query.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
	}
}
