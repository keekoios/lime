//
//  LMSourceDownloader.m
//  Lime
//
//  Created by Even Flatabø on 17/12/2019.
//  Copyright © 2019 EvenDev. All rights reserved.
//

#import "LMSourceDownloader.h"

@implementation LMSourceDownloader

- (id)initWithRepo:(LMRepo *)repo {
    self = [LMSourceDownloader new];
    if (self) {
        self.repo = repo;
    }
    return self;
}

-(void)downloadRepoAndIcon:(BOOL)icon completionHandler:(void (^)(void))completion {
    __block int tasks = icon ? 3 : 2;
    __block int completedTasks = 0;
    __block float progress = 0.0;
    
    __block BOOL releaseAdded = false;
    __block BOOL packagesAdded = false;
    __block BOOL iconAdded = false;
    __block long long int allBytesWritten = 0;
    __block long long int allExpectedLength = 0;
    
    if (self.sourceController) {
        NSUInteger repoIndex = [[LMSourceManager.sharedInstance sources] indexOfObject:self.repo];
        self.cell = [self.sourceController.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:repoIndex inSection:0]];
    }
    
    LMDownloader *releaseTask = LMDownloader.new;
    [releaseTask downloadFileWithURLString:self.repo.rawRepo.releaseURL toFile:self.repo.rawRepo.releasePath completionHandler:^(NSError * _Nullable error) {
        NSLog(@"[SourceManager] Downloaded %@ to %@", self.repo.rawRepo.releaseURL, self.repo.rawRepo.releasePath);
        completedTasks++;
        if (completedTasks == tasks) completion();
    }];
    [releaseTask setProgressBlock:^(long long bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        allBytesWritten += bytesWritten;
        if (!releaseAdded) allExpectedLength += totalBytesExpectedToWrite;
        releaseAdded = YES;
        if (self.sourceController) {
            progress = (float)allBytesWritten / allExpectedLength;
            //NSLog(@"[Progress] %lld / %lld", allBytesWritten, allExpectedLength);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cell.progressView setProgress:progress animated:YES];
            });
        }
        if (self.progressView) {
            progress = (float)allBytesWritten / allExpectedLength;
            //NSLog(@"[Progress] %lld / %lld", allBytesWritten, allExpectedLength);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView setProgress:progress animated:YES];
            });
        }
    }];
    
    LMDownloader *packagesTask = LMDownloader.new;
    [packagesTask downloadFileWithURLString:[self.repo.rawRepo.packagesURL stringByAppendingFormat:@".bz2"] toFile:self.repo.rawRepo.packagesPath completionHandler:^(NSError * _Nullable error) {
        int bunzip_one = [self bunzip_one:self.repo.rawRepo.packagesPath];
        bunzip_one = bunzip_one;
        NSLog(@"[SourceManager] Downloaded %@ to %@", self.repo.rawRepo.packagesURL, self.repo.rawRepo.packagesPath);
        completedTasks++;
        if (completedTasks == tasks) completion();
    }];
    [packagesTask setProgressBlock:^(long long bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        allBytesWritten += bytesWritten;
        if (!packagesAdded) allExpectedLength += totalBytesExpectedToWrite;
        packagesAdded = YES;
        if (self.sourceController) {
            progress = (float)allBytesWritten / allExpectedLength;
            //NSLog(@"[Progress] %lld / %lld", allBytesWritten, allExpectedLength);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.cell.progressView setProgress:progress animated:YES];
            });
        }
        if (self.progressView) {
            progress = (float)allBytesWritten / allExpectedLength;
            //NSLog(@"[Progress] %lld / %lld", allBytesWritten, allExpectedLength);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.progressView setProgress:progress animated:YES];
            });
        }
    }];
    
    if (icon) {
        LMDownloader *iconTask = LMDownloader.new;
        [iconTask downloadFileWithURLString:self.repo.rawRepo.imageURL toFile:self.repo.rawRepo.imagePath completionHandler:^(NSError * _Nullable error) {
            NSLog(@"[SourceManager] Downloaded %@ to %@", self.repo.rawRepo.imageURL, self.repo.rawRepo.imagePath);
            completedTasks++;
            if (completedTasks == tasks) completion();
        }];
        [iconTask setProgressBlock:^(long long bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            allBytesWritten += bytesWritten;
            if (!iconAdded) allExpectedLength += totalBytesExpectedToWrite;
            iconAdded = YES;
            if (self.sourceController) {
                progress = (float)allBytesWritten / allExpectedLength;
                //NSLog(@"[Progress] %lld / %lld", allBytesWritten, allExpectedLength);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.cell.progressView setProgress:progress animated:YES];
                });
            }
            if (self.progressView) {
                progress = (float)allBytesWritten / allExpectedLength;
                //NSLog(@"[Progress] %lld / %lld", allBytesWritten, allExpectedLength);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.progressView setProgress:progress animated:YES];
                });
            }
        }];
    }
}

// code reuse is amazing and this piece of stackoverflow "why does it work" magic actually works and i even have a clue how
// originally from my broken icy btw
- (int)bunzip_one:(NSString *)filepathString {
    const char *file = [filepathString UTF8String];
    const char *output = [[filepathString substringToIndex:filepathString.length - 4] UTF8String];
    FILE *f = fopen(file, "r+b");
    FILE *outfile = fopen(output, "w");
    fprintf(outfile, "");
    outfile = fopen(output, "a");
    int bzError;
    BZFILE *bzf;
    // it used to be char buf[4096] but @CodeLabyrinth aka a guy quite experienced with C told me this would be better for memory
    unsigned short buf[4096];
    bzf = BZ2_bzReadOpen(&bzError, f, 0, 0, NULL, 0);
    if (bzError != BZ_OK) {
        printf("E: BZ2_bzReadOpen: %d\n", bzError);
        [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
        return -1;
    }
    while (bzError == BZ_OK) {
        int nread = BZ2_bzRead(&bzError, bzf, buf, sizeof buf);
        if (bzError == BZ_OK || bzError == BZ_STREAM_END) {
            size_t nwritten = fwrite(buf, 1, nread, outfile);
            if (nwritten != (size_t) nread) {
                printf("E: short write\n");
                [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
                return -1;
            }
        }
    }
    if (bzError != BZ_STREAM_END) {
        printf("E: bzip error after read: %d\n", bzError);
        [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
        return -1;
    }
    BZ2_bzReadClose(&bzError, bzf);
    fclose(outfile);
    fclose(f);
    [[NSFileManager defaultManager] removeItemAtPath:filepathString error:nil];
    [NSFileManager.defaultManager moveItemAtPath:[filepathString substringToIndex:filepathString.length - 4] toPath:filepathString error:nil];
    return 0;
}

@end
