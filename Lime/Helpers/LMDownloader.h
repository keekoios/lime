//
//  LMDownloader.h
//  Lime
//
//  Created by Even Flatabø on 27/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LimeHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMDownloader : NSObject <NSURLSessionDownloadDelegate, NSURLSessionDelegate, NSURLSessionTaskDelegate>

-(void)downloadFileWithURLString:(nonnull NSString *)url toFile:(nonnull NSString *)file completionHandler:(nullable void (^)(NSError * _Nullable))completion;

@property (nonatomic, strong, nonnull) NSString *filePath;

typedef void (^ PROGRESS_BLOCK)(long long int bytesWritten, long long int totalBytesWritten, long long int totalBytesExpectedToWrite);
@property (nonatomic, copy, readwrite, nullable) PROGRESS_BLOCK progressBlock;
typedef void (^ COMPLETION_BLOCK)(NSError * _Nullable error);
@property (nonatomic, copy, readwrite, nullable) COMPLETION_BLOCK completionBlock;

@end

NS_ASSUME_NONNULL_END
