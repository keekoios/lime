//
//  AppDelegate.m
//  Lime
//
//  Created by Even Flatabø on 16/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [LMSourceManager sharedInstance];
    NSLog(@"[Info] Lime did finish loading");
    setuid(0);
    setgid(0);
    return YES;
}

@end
