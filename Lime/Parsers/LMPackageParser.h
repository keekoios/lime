//
//  LMPackageParser.h
//  Lime
//
//  Created by ArtikusHG on 7/25/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "../Objects/LMPackage.h"
#import "../Objects/LMRepo.h"
#import "LimeHelper.h"

NS_ASSUME_NONNULL_BEGIN

@interface LMPackageParser : NSObject

- (instancetype)initWithFilePath:(NSString *)filePath repository:(nullable LMRepo *)repo;
@property (nonatomic,strong) NSMutableArray *packages;

@end

NS_ASSUME_NONNULL_END
