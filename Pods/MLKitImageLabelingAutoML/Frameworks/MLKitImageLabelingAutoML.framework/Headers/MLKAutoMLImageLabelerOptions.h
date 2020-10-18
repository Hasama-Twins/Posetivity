
#import <MLKitImageLabelingCommon/MLKitImageLabelingCommon.h>


@class MLKAutoMLImageLabelerLocalModel;
@class MLKAutoMLImageLabelerRemoteModel;

NS_ASSUME_NONNULL_BEGIN

/** Options for an image labeler using models generated by AutoML. */
NS_SWIFT_NAME(AutoMLImageLabelerOptions)
@interface MLKAutoMLImageLabelerOptions : MLKCommonImageLabelerOptions

/**
 * Creates a new instance of `AutoMLImageLabelerOptions` with the given `localModel` with the
 * `confidenceThreshold` property set to `nil`. If it remains unset, a default confidence threshold
 * value of `0.5` will be used.
 *
 * @param localModel The AutoML Vision Edge model stored locally on the device. If `nil` is passed,
 *     raises `MLKInvalidAutoMLLocalModel`.
 * @return `AutoMLImageLabelerOptions` instance with the given `localModel`.
 */
- (instancetype)initWithLocalModel:(MLKAutoMLImageLabelerLocalModel *)localModel;

/**
 * Creates a new instance of `AutoMLImageLabelerOptions` with the given `remoteModel` with the
 * `confidenceThreshold` property set to `nil`. If it remains unset, a default confidence threshold
 * value of `0.5` will be used.
 *
 * @discussion It is recommended that the `AutoMLRemoteModel` be downloaded before creating a new
 *     instance of `AutoMLImageLabeler`. To download the remote model, invoke the
 *     `ModelManager`'s `download(_:conditions:)` method and monitor the returned `Progress` and/or
 *     listen for the download notifications defined in `MLKModelDownloadNotifications.h`.
 *
 * @param remoteModel The AutoML Vision Edge model hosted on the server. If `nil` is passed, raises
 *     `MLKInvalidAutoMLRemoteModel`.
 * @return `AutoMLImageLabelerOptions` instance with the given `remoteModel`.
 */
- (instancetype)initWithRemoteModel:(MLKAutoMLImageLabelerRemoteModel *)remoteModel;

/** Unavailable. */
- (instancetype)init NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END