//
//  MockFetchRecordsOperation.swift
//  CombineCloudKit
//
//  Created by Chris Araman on 6/6/21.
//  Copyright © 2021 Chris Araman. All rights reserved.
//

import CloudKit
import XCTest

@testable import CombineCloudKit

public class MockFetchRecordsOperation: MockFetchOperation<CKRecord, CKRecord.ID>,
  CCKFetchRecordsOperation
{
  init(_ database: MockDatabase, _ recordIDs: [CKRecord.ID]) {
    super.init(
      database,
      { database, operation in operation(&database.records) },
      recordIDs
    )
    super.perItemProgressBlock = { itemID, progress in
      if let update = self.perRecordProgressBlock {
        update(itemID, progress)
      }
    }
    super.perItemCompletionBlock = { item, itemID, error in
      if let completion = self.perRecordCompletionBlock {
        completion(item, itemID, error)
      }
    }
    super.fetchItemsCompletionBlock = { items, error in
      let completion = try! XCTUnwrap(self.fetchRecordsCompletionBlock)
      completion(items, error)
    }
  }

  // TODO: Return only desired keys.
  public var desiredKeys: [CKRecord.FieldKey]?

  public var perRecordProgressBlock: ((CKRecord.ID, Double) -> Void)?

  public var perRecordCompletionBlock: ((CKRecord?, CKRecord.ID?, Error?) -> Void)?

  public var fetchRecordsCompletionBlock: (([CKRecord.ID: CKRecord]?, Error?) -> Void)?
}