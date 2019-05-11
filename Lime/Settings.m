//
//  ChangesViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "Settings.h"
#import <sys/utsname.h>
#import "MobileGestalt.h"

@interface Settings ()

@end

@implementation Settings

NSString* deviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    
    _nameLabel.text = [[UIDevice currentDevice] name];
    _iOSLabel.text = [NSString stringWithFormat:@"iOS %@", [[UIDevice currentDevice] systemVersion]];
    [_iPhoneView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png", deviceName()]]];
    
    _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, _creditsTable.frame.origin.y + _creditsTable.frame.size.height);
}

@end

@implementation darkTable

-(void)viewDidLoad {
    [super viewDidLoad];
    [_darkToggle setSelected:[[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]];
}

-(void)setDefaultUserPreferences {
    bool darkMode = _darkToggle.isSelected;
    [[NSUserDefaults standardUserDefaults] setBool:darkMode forKey:@"darkMode"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)darkModeChanged:(id)sender {
    [self setDefaultUserPreferences];
}

@end

@implementation creditsTable

@end

@implementation InfoTable

NSString* getDeviceName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];
}

NSString *getECID() {
    NSString *ECID = nil;
    CFStringRef value = MGCopyAnswer(kMGUniqueChipID);
    if (value != nil) {
        ECID = [NSString stringWithFormat:@"%@", value];
        CFRelease(value);
    }
    return ECID;
}

NSString *getUDID() {
    NSString *UDID = nil;
    CFStringRef value = MGCopyAnswer(kMGUniqueDeviceID);
    if (value != nil) {
        UDID = [NSString stringWithFormat:@"%@", value];
        CFRelease(value);
    }
    return UDID;
}

-(void)viewDidLoad {
    _modelCell.detailTextLabel.text = getDeviceName();
    _ecidCell.detailTextLabel.text = getECID();
    _udidCell.detailTextLabel.text = getUDID();
}

@end
