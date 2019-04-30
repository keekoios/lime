//
//  ChangesViewController.h
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DepictionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet WKWebView *depictionView;

@end

NS_ASSUME_NONNULL_END
