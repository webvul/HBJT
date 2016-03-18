//
//  EJChangePasswordAPIManager.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJS/EJS.h"

@interface EJChangePasswordAPIManager : EJSAPIManager

- (instancetype)initWithID:(NSString *)userIDString newPassword:(NSString *)newPasswordText;

@end
