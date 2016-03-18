//
//  EJMatterViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJMatterViewModel : FTViewModel

typedef NS_ENUM(NSUInteger, EJMatterViewModelSection) {
    EJMatterViewModelSectionCaogao = 0,
    EJMatterViewModelSectionDaishen = 1,
    EJMatterViewModelSectionTuihui = 2,
    EJMatterViewModelSectionShouli = 3,
    EJMatterViewModelSectionYiban = 4,
    EJMatterViewModelSectionPingyi = 5
};

@property (assign, nonatomic) EJMatterViewModelSection section;
@property (assign, nonatomic) NSNumber *tableViewContentOffset;

@property (strong, nonatomic) RACSignal *tableViewHeaderSignal;
@property (strong, nonatomic) RACSignal *tableViewFooterSignal;

- (void)queryFirst;
- (void)queryNext;


@end
