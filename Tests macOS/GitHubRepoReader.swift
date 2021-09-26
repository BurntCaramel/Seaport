//
//  GitHubRepoReader.swift
//  Tests macOS
//
//  Created by Patrick Smith on 26/9/21.
//

import XCTest
@testable import Seaport

class GitHubRepoReaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
		 let source = "001e# service=git-upload-pack\n000001562bceecedfd15efe026c22174d45fcdee66f515ec HEAD\0multi_ack thin-pack side-band side-band-64k ofs-delta shallow deepen-since deepen-not deepen-relative no-progress include-tag multi_ack_detailed allow-tip-sha1-in-want allow-reachable-sha1-in-want no-done symref=HEAD:refs/heads/master filter object-format=sha1 agent=git/github-ga0b4cbabf04d\n004d4c96374b652455db1eb71eb2a93908b7d24bd4dd refs/heads/BurntCaramel-patch-1\n003f2bceecedfd15efe026c22174d45fcdee66f515ec refs/heads/master\n004b50e6ac0442039778b3c251b9cdc2067dbbbc7e7f refs/heads/renovate/configure\n003f50e6ac0442039778b3c251b9cdc2067dbbbc7e7f refs/pull/12/head\n00408da0821cbf4fa032f8a17812ff89082d746e2c52 refs/pull/12/merge\n003e4c96374b652455db1eb71eb2a93908b7d24bd4dd refs/pull/6/head\n003ec442c4ad2f226d6eea3cf40b1e62031d346a304e refs/tags/v0.3.0\n003eb74067bd2badd70a62f6c1aa084352ff9968b5e3 refs/tags/v0.4.7\n0000"
		 let sourceData = source.data(using: .utf8)!
		 
		 let reader = Seaport.GitHubRepoReader.Refs(pktLine: sourceData)
		 XCTAssertNotNil(reader)
		 XCTAssertEqual(reader!.headRef, "2bceecedfd15efe026c22174d45fcdee66f515ec")
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
