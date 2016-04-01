//
//  EJNewsViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTViewModel.h"



@interface EJNewsViewModel : FTViewModel

@property (assign, nonatomic) NSInteger currentTabIndex;
@property (assign, nonatomic) NSNumber *mainScrollViewOffset;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) RACSignal *tabNumberSiganl;

- (void)loadPreviousTab;
- (void)loadNextTab;
- (void)reload;
- (void)load;
- (void)loadMore;

@end
