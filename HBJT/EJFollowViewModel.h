//
//  EJFollowViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/4/13.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJFollowViewModel : FTViewModel

@property (strong, nonatomic) NSArray *itemList;

- (void)fetchList;

@end
