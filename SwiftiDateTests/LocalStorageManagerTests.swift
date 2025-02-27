//
//  LocalStorageManagerTests.swift
//  SwiftiDateTests
//
//  Created by 游哲維 on 2025/2/27.
//

import XCTest
@testable import SwiftiDate  // ★ 新增這行

final class LocalStorageManagerTests: XCTestCase {

    var localStorage: LocalStorageManager!

    override func setUpWithError() throws {
        localStorage = LocalStorageManager.shared
        localStorage.clearAll() // 清空
    }

    override func tearDownWithError() throws {
        localStorage.clearAll() // 再清空
    }

    func testSaveAndLoadUserSettings() {
        // 省略，流程同前
    }
}
