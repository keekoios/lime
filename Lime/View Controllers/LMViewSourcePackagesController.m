//
//  LMViewSourcePackagesController.m
//  Lime
//
//  Created by Even Flatabø on 28/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMViewSourcePackagesController.h"

@interface LMViewSourcePackagesController ()

@end

@implementation LMViewSourcePackagesController

- (void) removeOldPackageVersion {
    [self.repo.packages enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(LMPackage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *sameBundle = [self.repo.packages valueForKey:obj.identifier];
        NSInteger *pkgVersion = [obj.version integerValue];
        [sameBundle enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull pkg, NSUInteger index, BOOL * _Nonnull stop) {
            
        }];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.repo.parsedRepo.label;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    self.topProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [navBar addSubview:self.topProgressView];
    self.topProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topProgressView.widthAnchor constraintEqualToAnchor:navBar.widthAnchor constant:0].active = YES;
    [self.topProgressView.topAnchor constraintEqualToAnchor:navBar.bottomAnchor constant:-2.5].active = YES;
    
    self.theRefreshControl = [UIRefreshControl.alloc init];
    [self.theRefreshControl addTarget:self action:@selector(refreshControlRefresh) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10.0, *)) self.tableView.refreshControl = self.theRefreshControl;
    else [self.tableView addSubview:self.theRefreshControl];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)refreshWithCompletionHandler:(nullable void(^)(void))completion {
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = NO;
    }];
    NSDate *started = [NSDate date];
    [LMSourceManager.sharedInstance refreshSource:self.repo progressView:self.topProgressView completionHandler:^{
        NSLog(@"[SourceManager] %@ refreshed in %f seconds", self.repo.parsedRepo.label, [[NSDate date] timeIntervalSinceDate:started]);
        [self.topProgressView setProgress:0];
        [self.tableView reloadData];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userInteractionEnabled = YES;
        }];
        self.title = self.repo.parsedRepo.label;
        if (completion) completion();
    }];
}

-(void)refreshControlRefresh {
    [self refreshWithCompletionHandler:^{
        [self.theRefreshControl endRefreshing];
    }];
}

- (IBAction)refreshSource:(id)sender {
    [self refreshWithCompletionHandler:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.repo.packages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMPackageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourcepkgcell" forIndexPath:indexPath];
    
    LMPackage *pkg = [self.repo.packages objectAtIndex:indexPath.row];
    cell.textLabel.text = pkg.name;
    cell.detailTextLabel.text = pkg.desc;
    if ([[LimeHelper.sharedInstance installedPackagesDict] objectForKey:pkg.identifier]) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    if (pkg.iconPath.length > 0
        && [[NSFileManager defaultManager] fileExistsAtPath:pkg.iconPath]) {
        cell.imageView.image = [UIImage imageWithContentsOfFile:pkg.iconPath];
    } else {
        if ([UIImage imageNamed:pkg.section]) cell.imageView.image = [UIImage imageNamed:pkg.section];
        else cell.imageView.image = [UIImage imageNamed:@"Unknown"];
    }
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewrepopkg"]) {
        LMPackage *pkg = [self.repo.packages objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        LMDepictionController *dest = segue.destinationViewController;
        dest.package = pkg;
    }
}


@end
