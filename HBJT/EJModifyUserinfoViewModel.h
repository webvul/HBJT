//
//  EJModifyUserinfoViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/4.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJFramework.h"

@interface EJModifyUserinfoViewModel : FTViewModel

@property (strong, nonatomic) NSString *nameText;
@property (strong, nonatomic) NSString *numberText;
@property (strong, nonatomic) NSString *phoneText;
@property (strong, nonatomic) NSString *addressText;

@property (strong, nonatomic) RACSignal *modifyUserinfoHintSignal;

@property (strong, nonatomic) RACSignal *usernamePlaceHolderSiganal;
@property (strong, nonatomic) RACSignal *namePlaceHolderSiganal;
@property (strong, nonatomic) RACSignal *numberPlaceHolderSiganal;
@property (strong, nonatomic) RACSignal *phonePlaceHolderSiganal;
@property (strong, nonatomic) RACSignal *addressPlaceHolderSiganal;

- (void)modifyUserinfo;

@end
