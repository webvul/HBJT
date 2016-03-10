//
//  EJModifyUserinfoAPIManager.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/10.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJS/EJS.h"

@interface EJModifyUserinfoAPIManager : EJSAPIManager

- (instancetype)initWithID:(NSString *)userIDString name:(NSString *)nameText number:(NSString *)numberText phone:(NSString *)phoneText address:(NSString *)addressText;

@end
