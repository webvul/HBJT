//
//  EJPasswordRetrieveAPIManager.h
//  HBJT
//
//  Created by 方秋鸣 on 16/4/1.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJS.h"

@interface EJPasswordRetrieveAPIManager : EJSAPIManager
- (instancetype)initWithUsername:(NSString *)usernameText newPassword:(NSString *)password phoneNumber:(NSString *)phoneNumber;

@end
