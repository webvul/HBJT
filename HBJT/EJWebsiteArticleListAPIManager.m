//
//  EJWebsiteArticleListAPIManager.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJWebsiteArticleListAPIManager.h"

@interface EJWebsiteArticleListAPIManager ()
@property (assign, nonatomic) NSInteger pageNumber;

@end

@implementation EJWebsiteArticleListAPIManager

- (instancetype)initWithCategoryID:(NSInteger)categoryID
{
    self = [super initWith:kEJSNetworkAPINameWebsiteArticleList];
    if (self) {
        [self.params setObject:@(categoryID) forKey:@"cat_id"];
        [self.params setObject:@(15) forKey:@"pageSize"];
        [self.params setObject:@(1) forKey:@"pageNumber"];
        if (categoryID == EJWebsiteArtcleCategoryTPXW) {
            [self.params setObject:@(1) forKey:@"ispic"];
        } else
        {
            [self.params removeObjectForKey:@"ispic"];
        }
        self.pageNumber = 1;
    }
    return self;
}

- (void)prepareRequestNextPage
{
    self.pageNumber ++;
    [self.params setObject:@(self.pageNumber) forKey:@"pageNumber"];
}

- (void)prepareRequestFirstPage
{
    if (self.task.state == NSURLSessionTaskStateRunning) {
        [self.task cancel];
    }
    self.pageNumber = 1;
    [self.params setObject:@(1) forKey:@"pageNumber"];
}

- (void)setCategoryID:(NSInteger)categoryID
{
    [self.params setObject:@(categoryID) forKey:@"cat_id"];
    if (categoryID == EJWebsiteArtcleCategoryTPXW) {
        [self.params setObject:@(1) forKey:@"ispic"];
    } else
    {
        [self.params removeObjectForKey:@"ispic"];
    }
}

-(void)makeData
{
    self.data = nil;
    EJSResponseAnalyzer *analyzer = [EJSResponseAnalyzer analyzerWithData:self.rawData withAPIName:self.methodName];
    self.data = analyzer.data;
    self.status = (NSInteger)analyzer.status;
    self.statusDescription = analyzer.responseDescription;
    //NSLog(@"Data Made(%tu):%@ %@",self.status,self.statusDescription,self.data);
}

- (EJSAPIManagerStatus)newStatus
{
    [self makeData];
    return self.status;
}


@end
