//
//  EJGuildItemViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/25.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJGuildItemViewModel : FTViewModel

@property (nonatomic, strong) NSString *primaryItemIDString;
@property (nonatomic, strong) NSArray *itemList;


- (void)loadItemList;

@end
