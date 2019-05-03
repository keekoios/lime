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

@interface DepictionViewController : UIViewController <UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet WKWebView *depictionView;
@property (strong, nonatomic) IBOutlet UIButton *getButton;
@property (strong, nonatomic) IBOutlet UIButton *moreButton;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UIImageView *iconView;
@property (strong, nonatomic) IBOutlet UIImageView *bannerView;

@property (strong, nonatomic) UIImage *icon;
@property (strong, nonatomic) UIImage *banner;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *package;
@property (strong, nonatomic) NSString *depictionURL;

@end

NS_ASSUME_NONNULL_END
