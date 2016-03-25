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

@end

@implementation EJNewsViewModel

- (void)autoStart
{
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

- (void)reload
{
    [self.websiteArticleListAPIManager prepareRequestFirstPage];
    [self loadArticleList];
}

- (void)load
{
    [self.websiteArticleListAPIManager prepareRequestNextPage];
    [self loadArticleList];
}

- (void)loadArticleList
{
    if (self.isNetworkProceed == YES) {
        [self.websiteArticleListAPIManager cancel];
        self.networkHintText = @"取消";
        self.isNetworkProceed = NO;
    }
    self.isNetworkProceed = YES;
    self.networkHintText = @"正在读取";
    [self.websiteArticleListAPIManager setCategoryID:self.currentCategory];
    [self.loadArticleSignal subscribeError:^(NSError *error) {
        self.networkHintText = self.websiteArticleListAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        self.data = [self.websiteArticleListAPIManager.data objectForKey:@"articleList"];
        self.networkHintText = self.websiteArticleListAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    }];
}

- (void)loadNextTab
{
    self.currentTabIndex = [self nextTabIndex];
    [self loadArticleList];
}

- (void)loadPreviousTab
{
    self.currentTabIndex = [self previousTabIndex];
    [self loadArticleList];
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
            return EJWebsiteArtcleCategoryTPLB;
            break;
        case 1:
            return EJWebsiteArtcleCategoryTPXW;
            break;
        case 2:
            return EJWebsiteArtcleCategoryTZDT;
            break;
        case 3:
            return EJWebsiteArtcleCategoryTZGG;
            break;
        case 4:
            return EJWebsiteArtcleCategoryYWKB;
            break;
        case 5:
            return EJWebsiteArtcleCategoryZBTB;
            break;
        default:
            return EJWebsiteArtcleCategoryTPLB;
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

@end
