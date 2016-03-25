//
//  EJGuildPrimaryItemViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJGuildPrimaryItemViewModel : FTViewModel

@property (nonatomic, strong) NSString *sectionID;
@property (nonatomic, strong) NSArray *itemList;


- (void)loadItemList;

@end
