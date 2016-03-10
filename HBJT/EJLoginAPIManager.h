//
//  EJLoginAPIManager.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJS/EJS.h"

@interface EJLoginAPIManager :EJSAPIManager

- (instancetype)initWithUsername:(NSString *)usernameText password:(NSString *)password;

@end
