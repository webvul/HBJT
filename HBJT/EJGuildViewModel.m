//
//  EJGuildViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildViewModel.h"
#import "EJAreaListAPIManager.h"
#import "EJSectionListAPIManager.h"
#import "EJResultsListAPIManager.h"
#import "EJProgressListAPIManger.h"

#import "EJS.h"


@interface EJGuildViewModel ()

@property (strong, nonatomic) EJAreaListAPIManager *areaListAPIManager;
@property (strong, nonatomic) EJSectionListAPIManager *sectionListAPIManager;
@property (strong, nonatomic) EJResultsListAPIManager *resultsListAPIManager;
@property (strong, nonatomic) EJProgressListAPIManger *progressListAPIManager;


@property (nonatomic, strong) RACSignal *areaListSignal;
@property (nonatomic, strong) NSArray *areaArray;
@property (nonatomic, strong) RACSignal *sectionListSignal;
@property (nonatomic, strong) RACSignal *resultsListSiganl;
@property (nonatomic, strong) RACSignal *progressListSignal;



@end

@implementation EJGuildViewModel


- (void)autoStart
{
    self.resultArray = [NSArray array];
    self.areaListAPIManager = [[EJAreaListAPIManager alloc]init];
    self.areaListSignal = [self createSignalForAPIManager:self.areaListAPIManager];
    self.sectionListSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.sectionListAPIManager launchRequestWithSuccess:^(id responseObject) {
            if (![self.sectionListAPIManager newStatus]) {
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
    self.progressListSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.progressListAPIManager launchRequestWithSuccess:^(id responseObject) {
            if (![self.progressListAPIManager newStatus]) {
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
    self.resultsListSiganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self.resultsListAPIManager launchRequestWithSuccess:^(id responseObject) {
            if (![self.resultsListAPIManager newStatus]) {
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
    @weakify(self);
    [RACObserve(self, currentDistrictIndex) subscribeNext:^(id x) {
        @strongify(self);
        [self loadSectionList];
    }];
    [RACObserve( self, currentCityIndex) subscribeNext:^(id x) {
        @strongify(self);
        [self loadSuperSectionList];
    }];
}

- (void)loadAreaList
{
        self.isNetworkProceed = YES;
        self.networkHintText = @"正在获取区域信息";
        [self.areaListSignal subscribeError:^(NSError *error) {
            self.networkHintText = self.areaListAPIManager.statusDescription;
            self.isNetworkProceed = NO;
        } completed:^{
            self.areaArray = [self.areaListAPIManager.data objectForKey:@"areaArray"];
            self.networkHintText = self.areaListAPIManager.statusDescription;
            self.isNetworkProceed = NO;
            [self loadSuperSectionList];
        }];
}

- (void)loadSuperSectionList
{
    if (self.areaArray) {
        self.sectionListAPIManager = [[EJSectionListAPIManager alloc] initWithAreaCode:[self.cityArray [self.currentCityIndex] objectForKey:@"areaCode"]];
        self.isNetworkProceed = YES;
        self.networkHintText = @"正在获取区域信息";
        [self.sectionListSignal subscribeError:^(NSError *error) {
            self.networkHintText = self.sectionListAPIManager.statusDescription;
            self.isNetworkProceed = NO;
        } completed:^{
            self.sectionArray = [self.sectionListAPIManager.data objectForKey:@"sectionArray"];
            self.networkHintText = self.sectionListAPIManager.statusDescription;
            self.isNetworkProceed = NO;
        }];
    }
}

- (void)loadNew
{
    self.resultArray = nil;
    (self.currentTab?[self loadNewResultsList]:[self loadNewProgressList]);

}

- (void)loadMore
{
    (self.currentTab?[self loadMoreResultsList]:[self loadMoreProgressList]);
}

- (void)loadNewResultsList
{
    self.pageNumber = 1;
    [self loadResultsList];
}

- (void)loadMoreResultsList
{
    self.pageNumber ++;
    [self loadResultsList];
}

- (void)loadResultsList
{
    self.resultsListAPIManager = [[EJResultsListAPIManager alloc] initWithPageNumber:self.pageNumber];
    self.isNetworkProceed = YES;
    [self.resultsListSiganl subscribeError:^(NSError *error) {
        self.networkHintText = self.resultsListAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        if (self.resultArray == nil) {
            self.resultArray = [[NSArray alloc] init];
        }
        self.resultArray = [self.resultArray arrayByAddingObjectsFromArray:[self.resultsListAPIManager.data objectForKey:@"itemArray"]];
        self.networkHintText = self.resultsListAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    }];
}

- (void)loadNewProgressList
{
    self.pageNumber = 1;
    [self loadProgressList];
}

- (void)loadMoreProgressList
{
    self.pageNumber ++;
    [self loadProgressList];
}

- (void)loadProgressList
{
    self.progressListAPIManager = [[EJProgressListAPIManger alloc] initWithPageNumber:self.pageNumber];
    self.isNetworkProceed = YES;
    [self.progressListSignal subscribeError:^(NSError *error) {
        self.networkHintText = self.progressListAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        if (self.resultArray == nil) {
            self.resultArray = [[NSArray alloc] init];
        }
        self.resultArray = [self.resultArray arrayByAddingObjectsFromArray:[self.progressListAPIManager.data objectForKey:@"itemArray"]];
        self.networkHintText = self.progressListAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    }];
}

- (void)loadSectionList
{
    if (self.areaArray) {
        self.sectionListAPIManager = [[EJSectionListAPIManager alloc] initWithAreaCode:[self.districtArray[self.currentDistrictIndex] objectForKey:@"areaCode"]];
        self.isNetworkProceed = YES;
        self.networkHintText = @"正在获取区域信息";
        [self.sectionListSignal subscribeError:^(NSError *error) {
            self.networkHintText = self.sectionListAPIManager.statusDescription;
            self.isNetworkProceed = NO;
        } completed:^{
            self.sectionArray = [self.sectionListAPIManager.data objectForKey:@"sectionArray"];
            self.networkHintText = self.sectionListAPIManager.statusDescription;
            self.isNetworkProceed = NO;
        }];
    }
}

- (NSArray *)cityArray
{
    if (_areaArray != nil) {
        NSMutableArray *cityList = [[NSMutableArray alloc]init];
        for (NSDictionary *areaInfo in _areaArray) {
            if ([[areaInfo objectForKey:@"areaLevel"] integerValue] == 2 ) {
                [cityList addObject:areaInfo];
            }
        }
        _cityArray = [cityList copy];
    }
    return _cityArray;
}

- (NSArray *)districtArray
{
    if (_cityArray != nil) {
        NSMutableArray *districtList = [[NSMutableArray alloc]init];
        for (NSDictionary *areaInfo in _areaArray) {
            if ([areaInfo objectForKey:@"parentCode"] == [_cityArray[_currentCityIndex] objectForKey:@"areaCode"] /*&& [[areaInfo objectForKey:@"areaLevel"] integerValue] == 3*/) {
                [districtList addObject:areaInfo];
            }
        }
        _districtArray = [districtList copy];
    }
    return _districtArray;
}



@end


