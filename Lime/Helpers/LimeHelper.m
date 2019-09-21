//
//  LimeHelper.m
//  Lime
//
//  Created by EvenDev on 24/06/2019.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "LimeHelper.h"

@implementation LimeHelper

+(UIImage*)iconFromPackage:(LMPackage *)package {
    UIImage *icon = [UIImage imageWithContentsOfFile:package.iconPath];
    return icon;
}

+(UIImage*)imageWithName:(NSString*)name {
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"/Applications/Lime.app/%@.png", name]];
    return image;
}

+(BOOL)darkMode {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"];
}

+(void)setDarkMode:(BOOL)state {
    [[NSUserDefaults standardUserDefaults] setBool:state forKey:@"darkMode"];
}

+(NSString *)dpkgStatusLocation {
#if !(TARGET_IPHONE_SIMULATOR)
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/bin/bash"]) {
        return @"/var/lib/dpkg/status";
    } else {
        return [[NSBundle mainBundle] pathForResource:@"status" ofType:@""];
    }
#endif
    return [[NSBundle mainBundle] pathForResource:@"status" ofType:@""];
}

@end
