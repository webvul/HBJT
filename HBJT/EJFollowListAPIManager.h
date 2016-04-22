//
//  EJFollowListAPIManager.h
//  HBJT
//
//  Created by 方秋鸣 on 16/4/13.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJS.h"

@interface EJFollowListAPIManager : EJSAPIManager

- (instancetype)initWithUserID:(NSString *)userID pageNumber:(NSNumber *)pageNumber;

@end
