//
//  EJIndexViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/2.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJIndexViewModel.h"
#import "EJWebsiteArticleListAPIManager.h"

@interface EJIndexViewModel ()

@property (strong, nonatomic) EJWebsiteArticleListAPIManager *indexPicturesAPIManager;
@property (strong, nonatomic) RACSignal *indexPicturesURLSignal;

@end

@implementation EJIndexViewModel


- (void)autoStart
{
    @weakify(self);
    self.scrollViewRotateSignal = [[[RACObserve(self, scrollViewOffset) map:^id(id value) {
        @strongify(self);
        return ([value floatValue] > self.numberOfSrollViewPage-1.01)?@(1):([value floatValue]<0.01?@(self.numberOfSrollViewPage-2):nil);
    }] filter:^BOOL(id value) {
        return (value != nil);
    }] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
    self.pageIndicatorTintSignal = [[RACObserve(self, scrollViewOffset) map:^id(id value) {
        @strongify(self);
        NSInteger i = floor([value floatValue]+0.5);
        return @(i==0?self.numberOfSrollViewPage-3:(i==self.numberOfSrollViewPage-1?0:i-1));
    }] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
    self.indexPicturesURLSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [subscriber sendNext:nil];
        [self.indexPicturesAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            ([self.indexPicturesAPIManager newStatus] == 0? [subscriber sendCompleted]: [subscriber sendError:nil]);
        } failure:^(NSError *error) {
            [subscriber sendError:nil];
        }];
        return nil;
    }];

}

- (void)loadPictures
{
    self.isNetworkProceed = YES;
    [self.indexPicturesURLSignal subscribeError:^(NSError *error) {
        self.networkHintText = self.indexPicturesAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        NSMutableArray *urlList = [[NSMutableArray alloc] init];
        NSMutableArray *capitonList = [[NSMutableArray alloc] init];
        NSInteger i = 0;
        for (NSDictionary *articleInfo in [self.indexPicturesAPIManager.data objectForKey:@"articleList"]) {
            if (i == 4) {
                break;
            }
            [urlList addObject:[articleInfo objectForKey:@"articleThumbnailURL"]];
            [capitonList addObject:[articleInfo objectForKey:@"articleTitle"]];
            i ++;
        }
        self.picturesURLList = [urlList copy];
        self.picturesCaptionList = [capitonList copy];
        self.networkHintText = self.indexPicturesAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    }];
}

- (EJWebsiteArticleListAPIManager *)indexPicturesAPIManager
{
    if (_indexPicturesAPIManager == nil) {
        _indexPicturesAPIManager = [[EJWebsiteArticleListAPIManager alloc] initWithCategoryID:11270];;
    }
    return _indexPicturesAPIManager;
}

@end
