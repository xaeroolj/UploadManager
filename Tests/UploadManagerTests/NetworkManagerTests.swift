//
//  NetworkManagerTests.swift
//  
//
//  Created by Roman Trekhlebov on 23.05.2021.
//

import XCTest
import Foundation
import Alamofire

@testable import UploadManager

final class NetworkManagerTests: XCTestCase {
  let sut = NetworkManager()
  var testFilePath: String!
  var fileName: String?
  let resultExpectation = XCTestExpectation(description: "testCheckUploadProgress")



  override func setUpWithError() throws {
    testFilePath = Bundle.module.url(forResource: "TestData", withExtension: "txt")?.path
    fileName = "TestData.txt"

  }
  override func tearDownWithError() throws {
    testFilePath = nil
    fileName = nil
  }

  func testCheckUploadProgress() {


    let url = URL(string: "http://159.69.92.0:9813/mobile/api/v2/writeChunkToRecord")!
    let task = try! UploadTask(filePath: testFilePath)
    let param = InputParam(fileName: fileName!, chunkSize: 123, length: task.fileSize)

    let resource = Resource< OutputParam, InputParam >(url: url, httpMethod: .get , uploadTask: task, body: nil, parameters: param, headers: nil)
    sut.checkUploadProgress(resource: resource) { result in
      switch result {
      case .success(let resultObject):
        print(resultObject)
      case .failure(let error):
      print(error)
      }
      self.resultExpectation.fulfill()
    }
    wait(for: [resultExpectation], timeout: 10.0)
  }
}


