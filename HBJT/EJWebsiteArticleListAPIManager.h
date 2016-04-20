//
//  EJWebsiteArticleListAPIManager.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJS/EJS.h"

typedef NS_ENUM(NSInteger, EJWebsiteArtcleCategory) {
    EJWebsiteArtcleCategoryTZKX = 11216,
    EJWebsiteArtcleCategoryTPXW = 11217,
    EJWebsiteArtcleCategoryTZGG = 11218,
    EJWebsiteArtcleCategoryTZDT = 11219,
    EJWebsiteArtcleCategorySZSM = 11221,
    EJWebsiteArtcleCategoryZBTB = 11220,
    EJWebsiteArtcleCategoryTPLB = 11270
};

@interface EJWebsiteArticleListAPIManager : EJSAPIManager

- (instancetype)initWithCategoryID:(NSInteger)categoryID;
- (void)setCategoryID:(NSInteger)categoryID;
- (void)prepareRequestFirstPage;
- (void)prepareRequestNextPage;

@end
