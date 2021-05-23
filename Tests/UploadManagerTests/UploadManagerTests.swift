//
//  NetworkManagerTests.swift
//
//
//  Created by Roman Trekhlebov on 23.05.2021.
//

import XCTest
import Foundation

@testable import UploadManager

final class UploadManagerTests: XCTestCase {
  let sut = UploadManager(networkManager: NetworkManager())
  var fileName: String!
  var testFilePath: String!
  
  override func setUpWithError() throws {
    fileName = "TestData.txt"
    testFilePath = Bundle.module.url(forResource: "TestData", withExtension: "txt")?.path
    
  }
  override func tearDownWithError() throws {
    fileName = nil
    testFilePath = nil
  }
  
  func testFileExist() {
    do {
      try sut.addFileToQue(filePath: testFilePath)
    } catch {
      print(error)
    }
    
    XCTAssertNoThrow(try sut.addFileToQue(filePath: testFilePath))
    XCTAssertEqual(sut.uploadTasks.count, 1)
    XCTAssertNotNil(sut.uploadTasks.first)
    let firstTask = sut.uploadTasks[testFilePath]!
    XCTAssertNotEqual(firstTask.fileSize, 0)
    XCTAssertEqual(firstTask.status, .inactive)
  }
}
