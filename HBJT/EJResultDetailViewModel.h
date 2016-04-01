//
//  ResultDetailViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/4/1.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJResultDetailViewModel : FTViewModel

@property (assign, nonatomic) NSInteger resultType;
@property (strong, nonatomic) NSString *resultID;
@property (strong, nonatomic) NSDictionary *data;

- (void)load;
@end
