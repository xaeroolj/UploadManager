//
//  UploadManager.swift
//
//
//  Created by Roman Trekhlebov on 23.05.2021.
//

import Foundation



protocol UploadManagerProtocol {
  var networkManager: NetworkManagerProtocol! {get set}
  func addFileToQue(filePath: String) throws

  init (networkManager: NetworkManagerProtocol)
}

public class UploadManager : UploadManagerProtocol {

  required init(networkManager: NetworkManagerProtocol) {
    self.networkManager = networkManager
  }


  // MARK: - Public Properties
  public static let shared = UploadManager(networkManager: NetworkManager())
  public var chunkSize = 10 * 1024 * 1024
  // MARK: - Private Properties
  var uploadTasks = [String : UploadTask]()
  var networkManager: NetworkManagerProtocol!
  // MARK: - Initializers
  // MARK: - Lifecycle
  // MARK: - Private Methods

  // MARK: - Public Methods
  public func addFileToQue(filePath: String) throws {
    let uploadTask = try UploadTask(filePath: filePath)
    uploadTasks[filePath] = uploadTask
  }
}

struct UploadTask {
  let status: UploadStatus
  let fileSize: UInt64
  let uploaded: UInt64
  let filePath: String

  public init(filePath: String) throws {
    let fileManager = FileManager.default
    guard fileManager.fileExists(atPath: filePath),
          let fileSize = URL(string: filePath)?.fileSize else { throw UploadManagerErrors.fileNotExist }
    self.filePath = filePath
    self.uploaded = 0
    self.status = .inactive
    self.fileSize = fileSize
  }
}

enum UploadStatus {
  case inactive
  case started
  case paused
  case finished
  case failure
}

enum UploadManagerErrors: Error {
  case fileNotExist
  case networkError
}
