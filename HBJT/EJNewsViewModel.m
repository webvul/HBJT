//
//  EJNewsViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJNewsViewModel.h"
#import "EJWebsiteArticleListAPIManager.h"
#import "EJWebsiteLaudNumberAPIManager.h"

@interface EJNewsViewModel()

@property (strong, nonatomic) EJWebsiteArticleListAPIManager *websiteArticleListAPIManager;
@property (strong, nonatomic) EJWebsiteLaudNumberAPIManager *websiteLaudNumberAPIManager;
@property (strong, nonatomic) RACSignal *loadArticleSignal;
@property (strong, nonatomic) RACSignal *loadLaudNumberSiganl;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *noMoreDataMark;

@end

@implementation EJNewsViewModel

- (void)autoStart
{
    self.dataArray = [NSMutableArray arrayWithCapacity:6];
    for (NSInteger i = 0; i < 6; i++) {
        [self.dataArray addObject:[NSArray array]];
    }
    self.noMoreDataMark = [@[@0, @0, @0, @0, @0, @0] mutableCopy];
    self.tabNumberSiganl = RACObserve(self, currentTabIndex);
    self.loadArticleSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.websiteArticleListAPIManager launchRequestWithSuccess:^(id responseObject) {
            if (![self.websiteArticleListAPIManager newStatus]) {
                [subscriber sendCompleted];
            }
            else
            {
                [subscriber sendError:nil];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (void)loadMore
{
    if (self.isNetworkProceed == YES) {
        [self.websiteArticleListAPIManager cancel];
        self.networkHintText = @"取消";
        self.isNetworkProceed = NO;
    }
    NSInteger index = self.currentTabIndex;
    self.noMoreData = [self.noMoreDataMark[index] boolValue];
    self.isNetworkProceed = YES;
    self.networkHintText = @"正在读取";
    if (self.noMoreData) {
        self.networkHintText = @"读取成功";
        self.isNetworkProceed = NO;
        return;
    }
    [self.websiteArticleListAPIManager prepareRequestNextPage];
    [self.websiteArticleListAPIManager setCategoryID:self.currentCategory];
    [self.loadArticleSignal subscribeError:^(NSError *error) {
        self.networkHintText = self.websiteArticleListAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        [self.data addObjectsFromArray:[self.websiteArticleListAPIManager.data objectForKey:@"articleList"]];
        self.noMoreDataMark[index] = @([[self.websiteArticleListAPIManager.data objectForKey:@"articleList"] count] < 15);
        self.noMoreData = [self.noMoreDataMark[index] boolValue];
        self.networkHintText = self.websiteArticleListAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    }];

}

- (void)reload
{
    NSInteger index = self.currentTabIndex;
    self.noMoreData = self.noMoreDataMark[index];
    [self.websiteArticleListAPIManager prepareRequestFirstPage];
    if (self.isNetworkProceed == YES) {
        [self.websiteArticleListAPIManager cancel];
        self.networkHintText = @"取消";
        self.isNetworkProceed = NO;
    }
    self.isNetworkProceed = YES;
    if ([self.dataArray[index] count]>1) {
        self.data = self.dataArray[index];
        self.networkHintText = @"读取成功";
        self.isNetworkProceed = NO;
        return;
    }
    self.networkHintText = @"正在读取";
    [self.websiteArticleListAPIManager setCategoryID:self.currentCategory];
    [self.loadArticleSignal subscribeError:^(NSError *error) {
        self.networkHintText = @"无可用网络连接";
        self.isNetworkProceed = NO;
    } completed:^{
        self.dataArray[index] = [self.websiteArticleListAPIManager.data objectForKey:@"articleList"];
        self.data = self.dataArray[index];
        self.noMoreDataMark[index] = @(self.data.count < 15);
        self.noMoreData = [self.noMoreDataMark[index] boolValue];
        self.networkHintText = self.websiteArticleListAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    }];
}

- (void)loadNextTab
{
    self.currentTabIndex = [self nextTabIndex];
    [self reload];
}

- (void)loadPreviousTab
{
    self.currentTabIndex = [self previousTabIndex];
    [self reload];
}


- (NSInteger)nextTabIndex
{
    if (self.currentTabIndex == 5) {
        return 0;
    }
    return self.currentTabIndex +1;
}

- (NSInteger)previousTabIndex
{
    if (self.currentTabIndex == 0) {
        return 5;
    }
    return self.currentTabIndex -1;
}

- (EJWebsiteArtcleCategory)currentCategory
{
    switch (self.currentTabIndex) {
        case 0:
            return EJWebsiteArtcleCategoryTZKX;
            break;
        case 1:
            return EJWebsiteArtcleCategoryTPXW;
            break;
        case 2:
            return EJWebsiteArtcleCategoryTZGG;
            break;
        case 3:
            return EJWebsiteArtcleCategoryTZDT;
            break;
        case 4:
            return EJWebsiteArtcleCategorySZSM;
            break;
        case 5:
            return EJWebsiteArtcleCategoryZBTB;
            break;
        default:
            return EJWebsiteArtcleCategoryTZKX;
            break;
    }
}

- (EJWebsiteArticleListAPIManager *)websiteArticleListAPIManager
{
    if (_websiteArticleListAPIManager == nil) {
        _websiteArticleListAPIManager = [[EJWebsiteArticleListAPIManager alloc] initWithCategoryID:[self currentCategory]];
    }
    return _websiteArticleListAPIManager;
}

- (NSMutableArray *)lastdata
{
    _lastdata = _dataArray[self.previousTabIndex];
    return _lastdata;
}

- (NSMutableArray *)nextdata
{
    _nextdata = _dataArray[self.nextTabIndex];
    return _nextdata;
}

@end
