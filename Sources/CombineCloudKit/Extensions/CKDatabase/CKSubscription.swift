//
//  CKSubscription.swift
//  CombineCloudKit
//
//  Created by Chris Araman on 2/16/21.
//  Copyright © 2021 Chris Araman. All rights reserved.
//

import CloudKit
import Combine

extension CKDatabase {
  /// Saves a single subscription.
  ///
  /// - Parameters:
  ///   - subscription: The subscription to save.
  /// - Note: CombineCloudKit executes the save with a low priority. Use this method when you don’t require the save to
  /// happen immediately.
  /// - Returns: A `Publisher` that emits the saved `CKSubscription`, or an error if CombineCloudKit can't save it.
  /// - SeeAlso: [`save`](https://developer.apple.com/documentation/cloudkit/ckdatabase/1449102-save)
  public final func saveAtBackgroundPriority(
    subscription: CKSubscription
  ) -> AnyPublisher<CKSubscription, Error> {
    publisherFrom(save, with: subscription)
  }

  /// Saves a single subscription.
  ///
  /// - Parameters:
  ///   - subscription: The subscription to save.
  ///   - configuration: The configuration to use for the underlying operation. If you don't specify a configuration,
  ///     the operation will use a default configuration.
  /// - Returns: A `Publisher` that emits the saved `CKSubscription`, or an error if CombineCloudKit can't save it.
  /// - SeeAlso: [`CKModifySubscriptionsOperation`](https://developer.apple.com/documentation/cloudkit/ckmodifysubscriptionsoperation)
  public final func save(
    subscription: CKSubscription,
    withConfiguration configuration: CKOperation.Configuration? = nil
  ) -> AnyPublisher<CKSubscription, Error> {
    save(subscriptions: [subscription], withConfiguration: configuration)
  }

  /// Saves multiple subscriptions.
  ///
  /// - Parameters:
  ///   - subscriptions: The subscriptions to save.
  ///   - configuration: The configuration to use for the underlying operation. If you don't specify a configuration,
  ///     the operation will use a default configuration.
  /// - Returns: A `Publisher` that emits the saved `CKSubscription`s, or an error if CombineCloudKit can't save them.
  /// - SeeAlso: [`CKModifySubscriptionsOperation`](https://developer.apple.com/documentation/cloudkit/ckmodifysubscriptionsoperation)
  public final func save(
    subscriptions: [CKSubscription],
    withConfiguration configuration: CKOperation.Configuration? = nil
  ) -> AnyPublisher<CKSubscription, Error> {
    let operation = CKModifySubscriptionsOperation(
      subscriptionsToSave: subscriptions,
      subscriptionIDsToDelete: nil
    )
    return publisherFrom(operation, configuration) { completion in
      operation.modifySubscriptionsCompletionBlock = completion
    }
  }

  /// Deletes a single subscription.
  ///
  /// - Parameters:
  ///   - subscriptionID: The ID of the subscription to delete.
  /// - Note: CombineCloudKit executes the delete with a low priority. Use this method when you don’t require the delete
  /// to happen immediately.
  /// - Returns: A `Publisher` that emits the deleted `CKSubscriptionID`, or an error if CombineCloudKit can't delete it.
  /// - SeeAlso: [`delete`](https://developer.apple.com/documentation/cloudkit/ckdatabase/3003590-delete)
  public final func deleteAtBackgroundPriority(
    subscriptionID: CKSubscription.ID
  ) -> AnyPublisher<CKSubscription.ID, Error> {
    publisherFrom(delete, with: subscriptionID)
  }

  /// Deletes a single subscription.
  ///
  /// - Parameters:
  ///   - subscriptionID: The ID of the subscription to delete.
  ///   - configuration: The configuration to use for the underlying operation. If you don't specify a configuration,
  ///     the operation will use a default configuration.
  /// - Returns: A `Publisher` that emits the deleted `CKSubscriptionID`, or an error if CombineCloudKit can't delete
  /// it.
  /// - SeeAlso: [`CKModifySubscriptionsOperation`](https://developer.apple.com/documentation/cloudkit/ckmodifysubscriptionsoperation)
  public final func delete(
    subscriptionID: CKSubscription.ID,
    withConfiguration configuration: CKOperation.Configuration? = nil
  ) -> AnyPublisher<CKSubscription.ID, Error> {
    delete(subscriptionIDs: [subscriptionID], withConfiguration: configuration)
  }

  /// Deletes multiple subscriptions.
  ///
  /// - Parameters:
  ///   - subscriptionIDs: The IDs of the subscriptions to delete.
  ///   - configuration: The configuration to use for the underlying operation. If you don't specify a configuration,
  ///     the operation will use a default configuration.
  /// - Returns: A `Publisher` that emits the deleted `CKSubscriptionID`s, or an error if CombineCloudKit can't delete
  /// them.
  /// - SeeAlso: [`CKModifySubscriptionsOperation`](https://developer.apple.com/documentation/cloudkit/ckmodifysubscriptionsoperation)
  public final func delete(
    subscriptionIDs: [CKSubscription.ID],
    withConfiguration configuration: CKOperation.Configuration? = nil
  ) -> AnyPublisher<CKSubscription.ID, Error> {
    let operation = CKModifySubscriptionsOperation(
      subscriptionsToSave: nil,
      subscriptionIDsToDelete: subscriptionIDs
    )
    return publisherFrom(operation, configuration) { completion in
      operation.modifySubscriptionsCompletionBlock = completion
    }
  }

  /// Modifies one or more subscriptions.
  ///
  /// - Parameters:
  ///   - subscriptionsToSave: The subscriptions to save.
  ///   - subscriptionsToDelete: The IDs of the subscriptions to delete.
  ///   - configuration: The configuration to use for the underlying operation. If you don't specify a configuration,
  ///     the operation will use a default configuration.
  /// - Returns: A `Publisher` that emits the saved `CKSubscription`s and the deleted `CKRecordZone.ID`s, or an
  ///   error if CombineCloudKit can't modify them.
  /// - SeeAlso: [`CKModifySubscriptionsOperation`](https://developer.apple.com/documentation/cloudkit/ckmodifysubscriptionsoperation)
  public final func modify(
    subscriptionsToSave: [CKSubscription]? = nil,
    subscriptionIDsToDelete: [CKSubscription.ID]? = nil,
    withConfiguration configuration: CKOperation.Configuration? = nil
  ) -> AnyPublisher<(CKSubscription?, CKSubscription.ID?), Error> {
    let operation = CKModifySubscriptionsOperation(
      subscriptionsToSave: subscriptionsToSave,
      subscriptionIDsToDelete: subscriptionIDsToDelete
    )
    return publisherFrom(
      operation,
      configuration,
      setCompletion: { completion in operation.modifySubscriptionsCompletionBlock = completion }
    )
  }

  /// Fetches the subscription with the specified ID.
  ///
  /// - Parameters:
  ///   - subscriptionID: The ID of the subscription to fetch.
  /// - Note: CombineCloudKit executes the fetch with a low priority. Use this method when you don’t require the
  /// subscription immediately.
  /// - Returns: A `Publisher` that emits the `CKSubscription`, or an error if CombineCloudKit can't fetch it.
  /// - SeeAlso: [fetch](https://developer.apple.com/documentation/cloudkit/ckdatabase/3003591-fetch)
  public final func fetchAtBackgroundPriority(
    withSubscriptionID subscriptionID: CKSubscription.ID
  ) -> AnyPublisher<CKSubscription, Error> {
    publisherFrom(fetch, with: subscriptionID)
  }

  /// Fetches the subscription with the specified ID.
  ///
  /// - Parameters:
  ///   - subscriptionID: The ID of the subscription to fetch.
  ///   - configuration: The configuration to use for the underlying operation. If you don't specify a configuration,
  ///     the operation will use a default configuration.
  /// - Returns: A `Publisher` that emits the `CKSubscription`, or an error if CombineCloudKit can't fetch it.
  /// - SeeAlso: [CKFetchSubscriptionsOperation](https://developer.apple.com/documentation/cloudkit/ckfetchsubscriptionsoperation)
  public final func fetch(
    subscriptionID: CKSubscription.ID,
    withConfiguration configuration: CKOperation.Configuration? = nil
  ) -> AnyPublisher<CKSubscription, Error> {
    fetch(subscriptionIDs: [subscriptionID], withConfiguration: configuration)
  }

  /// Fetches multiple subscriptions.
  ///
  /// - Parameters:
  ///   - subscriptionIDs: The IDs of the subscriptions to fetch.
  ///   - configuration: The configuration to use for the underlying operation. If you don't specify a configuration,
  ///     the operation will use a default configuration.
  /// - Returns: A `Publisher` that emits the `CKSubscription`s, or an error if CombineCloudKit can't fetch them.
  /// - SeeAlso: [CKFetchSubscriptionsOperation](https://developer.apple.com/documentation/cloudkit/ckfetchsubscriptionsoperation)
  public final func fetch(
    subscriptionIDs: [CKSubscription.ID],
    withConfiguration configuration: CKOperation.Configuration? = nil
  ) -> AnyPublisher<CKSubscription, Error> {
    let operation = CKFetchSubscriptionsOperation(subscriptionIDs: subscriptionIDs)
    return publisherFrom(operation, configuration) { completion in
      operation.fetchSubscriptionCompletionBlock = completion
    }
  }

  /// Fetches the database's subscriptions.
  ///
  /// - Note: CombineCloudKit executes the fetch with a low priority. Use this method when you don’t require the
  /// subscriptions immediately.
  /// - Returns: A `Publisher` that emits the `CKSubscription`s, or an error if CombineCloudKit can't fetch them.
  /// - SeeAlso: [fetchAllSubscriptions](https://developer.apple.com/documentation/cloudkit/ckdatabase/1449110-fetchallsubscriptions)
  public final func fetchAllSubscriptionsAtBackgroundPriority()
    -> AnyPublisher<CKSubscription, Error>
  {
    publisherFrom(fetchAllSubscriptions)
  }

  /// Fetches the database's subscriptions.
  ///
  /// - Parameters:
  ///   - configuration: The configuration to use for the underlying operation. If you don't specify a configuration,
  ///     the operation will use a default configuration.
  /// - Returns: A `Publisher` that emits the `CKSubscription`s, or an error if CombineCloudKit can't fetch them.
  /// - SeeAlso: [fetchAllSubscriptionsOperation](https://developer.apple.com/documentation/cloudkit/ckfetchsubscriptionsoperation/1515282-fetchallsubscriptionsoperation)
  public final func fetchAllSubscriptions(
    withConfiguration configuration: CKOperation.Configuration? = nil
  ) -> AnyPublisher<CKSubscription, Error> {
    let operation = CKFetchSubscriptionsOperation.fetchAllSubscriptionsOperation()
    return publisherFrom(operation, configuration) { completion in
      operation.fetchSubscriptionCompletionBlock = completion
    }
  }
}