//
//  EJGuildViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/22.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJGuildViewModel : FTViewModel

@property (nonatomic, assign) NSInteger currentCityIndex;
@property (nonatomic, assign) NSInteger currentDistrictIndex;
@property (nonatomic, strong) NSArray *cityArray;
@property (nonatomic, strong) NSArray *districtArray;
@property (nonatomic, strong) NSArray *sectionArray;
@property (nonatomic, strong) NSArray *resultArray;
@property (nonatomic, strong) NSArray *progressArray;
@property (nonatomic, assign) NSInteger pageNumber;
@property (nonatomic, assign) NSInteger currentTab;


- (void)loadAreaList;
- (void)loadNew;
- (void)loadMore;

@end
