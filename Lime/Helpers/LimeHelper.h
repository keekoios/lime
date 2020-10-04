//
//  LimeHelper.h
//  Lime
//
//  Created by Even Flatabø on 18/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LMDeviceInfo.h"
#import "../Parsers/LMPackageParser.h"
#import "../Parsers/LMRepoParser.h"
#import <bzlib.h>
#include <spawn.h>
#import "../Other/NSTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface LimeHelper : NSObject

+ (id)sharedInstance;

+ (NSString *)documentDirectory;
+ (NSString *)dpkgStatusLocation;
+ (NSString *)limePath;
+ (NSString *)sourcesPath;
+ (NSString *)listsPath;
+ (NSString *)iconsPath;
+ (NSString *)tmpPath;
+ (void)runLemonWithArguments:(NSArray *)args textView:(UITextView *)textView completionHandler:(nullable void(^)(NSTask *task))completionHandler;
+ (void)runDPKGWithArgs:(NSArray *)args textView:(UITextView *)textView completionHandler:(nullable void(^)(NSTask *task))completionHandler;
+(void)runAPTWithArguments:(NSArray *)args textView:(UITextView *)textView completionHandler:(nullable void(^)(NSTask *task))completionHandler;
- (void)refreshInstalledPackagesWithCompletionHandler:(nullable void(^)(void))completion;
+ (NSMutableURLRequest *)mutableURLRequestWithHeadersWithURLString:(NSString *)URLString;
+ (void)respringDevice;
+ (void)removeRepo:(LMRepo *)repo;
+ (LMRepo *)rawRepoWithDebLine:(NSString *)line;

@property (nonatomic, retain) NSMutableDictionary *packagesDict;
@property (nonatomic, retain) NSMutableArray *packagesArray;
@property (nonatomic, retain) NSMutableDictionary *installedPackagesDict;
@property (nonatomic, retain) NSMutableArray *installedPackagesArray;
@property (nonatomic, retain) UINavigationController *defaultNavigationController;
@property (nonatomic, retain) NSString *addRepoURL;

@end

NS_ASSUME_NONNULL_END
