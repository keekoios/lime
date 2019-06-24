//
//  InstalledViewController.m
//  Lime
//
//  Created by ArtikusHG on 4/30/19.
//  Copyright © 2019 Daniel. All rights reserved.
//

#import "InstalledViewController.h"
#import "DepictionViewController.h"
#import "UIColor/UIImageAverageColorAddition.h"
#import "LimeHelper.h"

@interface InstalledViewController ()

@end

@implementation InstalledViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.parser = [[LMDPKGParser alloc] init];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        self.tableView.backgroundColor = [UIColor blackColor];
        self.tableView.separatorColor = [UIColor colorWithRed:0.239 green:0.239 blue:0.239 alpha:1];
        self.navigationController.navigationBar.barStyle = 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.parser.installedPackages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMPackage *package = (LMPackage*)[self.parser.installedPackages objectAtIndex:indexPath.row];
    
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:15];
    cell.textLabel.text = package.name;
    cell.detailTextLabel.text = package.desc;
    cell.detailTextLabel.alpha = 0.5;
    UIImage *icon = [LimeHelper iconFromPackage:package];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(40,40), NO, [UIScreen mainScreen].scale);
    [icon drawInRect:CGRectMake(0,0,40,40)];
    icon = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 10;
    cell.imageView.image = icon;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1.0];
        [cell setSelectedBackgroundView:bgColorView];
    }
    
    /*
    UIButton *getButton = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 90, 20, 74, 30)];
    getButton.backgroundColor = [UIColor colorWithRed:0.95 green:0.94 blue:0.96 alpha:1.0];
    getButton.layer.cornerRadius = 15;
    [getButton setTitle:@"GET" forState:UIControlStateNormal];
    [getButton setTitleColor:[[[UIApplication sharedApplication] delegate] window].tintColor forState:UIControlStateNormal];
    [getButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [cell addSubview:getButton];
     */
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"darkMode"]) {
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"delete" message:@"should delete" delegate:self cancelButtonTitle:@"Kk" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"packageInfo" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DepictionViewController *depictionViewController = segue.destinationViewController;
    NSInteger index = [(UITableView *)self.view indexPathForSelectedRow].row;
    
    depictionViewController.package = (LMPackage*)[self.parser.installedPackages objectAtIndex:index];
}

@end
