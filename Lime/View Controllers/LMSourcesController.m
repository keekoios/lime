//
//  LMSourcesController.m
//  Lime
//
//  Created by Even Flatabø on 28/11/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMSourcesController.h"

@interface LMSourcesController ()

@end

@implementation LMSourcesController

@synthesize refreshControl;

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self parseRepoData];
    [LMSourceManager.sharedInstance setSourceController:self];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    self.topProgressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [navBar addSubview:self.topProgressView];
    self.topProgressView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.topProgressView.widthAnchor constraintEqualToAnchor:navBar.widthAnchor constant:0].active = YES;
    [self.topProgressView.topAnchor constraintEqualToAnchor:navBar.bottomAnchor constant:-2.5].active = YES;
    
    self.refreshControl = [UIRefreshControl.alloc init];
    [self.refreshControl addTarget:self action:@selector(pullDownToRefresh) forControlEvents:UIControlEventValueChanged];
    
    if (@available(iOS 10.0, *)) self.tableView.refreshControl = self.refreshControl;
    else [self.tableView addSubview:self.refreshControl];
}

-(void)refreshWithCompletionHandler:(nullable void(^)(void))completion {
    [NSFileManager.defaultManager removeItemAtPath:LimeHelper.listsPath error:nil];
    [NSFileManager.defaultManager createDirectoryAtPath:LimeHelper.listsPath withIntermediateDirectories:NO attributes:0 error:nil];
    //[NSFileManager.defaultManager removeItemAtPath:LimeHelper.iconsPath error:nil];
    //[NSFileManager.defaultManager createDirectoryAtPath:LimeHelper.iconsPath withIntermediateDirectories:NO attributes:0 error:nil];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.userInteractionEnabled = NO;
    }];
    NSDate *started = [NSDate date];
    [LMSourceManager.sharedInstance refreshSourcesCompletionHandler:^{
        NSLog(@"[SourceManager] %lu sources refreshed in %f seconds", (unsigned long)LMSourceManager.sharedInstance.sources.count, [[NSDate date] timeIntervalSinceDate:started]);
        [self.tableView reloadData];
        self.navigationController.navigationBar.userInteractionEnabled = YES;
        [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userInteractionEnabled = YES;
        }];
        if (completion) completion();
    }];
}

-(void)pullDownToRefresh {
    [self refreshWithCompletionHandler:^{
        [self.refreshControl endRefreshing];
    }];
}

-(IBAction)refreshButtonAction:(id)sender {
    [self refreshWithCompletionHandler:nil];
}

// UITableView stuff

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [LMSourceManager.sharedInstance sources].count;
}

-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *refreshBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Refresh" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        self.navigationController.navigationBar.userInteractionEnabled = NO;
        [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.userInteractionEnabled = NO;
        }];
        
        LMRepo *repo = [LMSourceManager.sharedInstance.sources objectAtIndex:indexPath.row];
        LMSourceCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSDate *started = [NSDate date];
        [LMSourceManager.sharedInstance refreshSource:repo progressView:cell.progressView completionHandler:^{
               NSLog(@"[SourceManager] %@ refreshed in %f seconds", repo.parsedRepo.label, [[NSDate date] timeIntervalSinceDate:started]);
            [cell.progressView setProgress:0];
            [self.tableView reloadData];
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            [self.tableView.visibleCells enumerateObjectsUsingBlock:^(__kindof UITableViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.userInteractionEnabled = YES;
            }];
            cell.textLabel.text = repo.parsedRepo.label;
        }];
    }];
    UITableViewRowAction *deleteBtn = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"Delete" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        LMRepo *repo = [LMSourceManager.sharedInstance.sources objectAtIndex:indexPath.row];
        // ---------------
        // ADD A CONFIRMATION ALERT OR SOMETHING? ITS UP TO YOU EVEN
        // ---------------
        [LimeHelper removeRepo:repo];
        [LMSourceManager.sharedInstance.sources removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];

    return @[deleteBtn, refreshBtn];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {}

- (LMSourceCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LMSourceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sourcecell" forIndexPath:indexPath];
    
    LMRepo *repo = [[LMSourceManager.sharedInstance sources] objectAtIndex:indexPath.row];
    cell.textLabel.text = repo.parsedRepo.label;
    cell.detailTextLabel.text = repo.rawRepo.repoURL;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.cornerRadius = 7.65;
    cell.imageView.image = repo.rawRepo.image;
    
    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"viewsource"]) {
        LMRepo *repo = [[LMSourceManager.sharedInstance sources] objectAtIndex:self.tableView.indexPathForSelectedRow.row];
        LMViewSourcePackagesController *dest = segue.destinationViewController;
        dest.repo = repo;
    } else if ([segue.identifier isEqualToString:@"addRepoSegue"]) {
        LMAddRepoController *dest = segue.destinationViewController;
        dest.sourcesController = self;
    }
}

@end
