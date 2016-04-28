//
//  VerifyTool.h
//  EducationApp
//
//  Created by Agoni-pingly on 15/8/25.
//  Copyright (c) 2015年 Agoni-pingly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerifyTool : NSObject

//邮箱
+ (BOOL) validateEmail:(NSString *)email;
/** QQ */
+ (BOOL) isQQ:(NSString*)value ;
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;
//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;
//车型
+ (BOOL) validateCarType:(NSString *)CarType;
//用户名
+ (BOOL) validateUserName:(NSString *)name;
//密码
+ (BOOL) validatePassword:(NSString *)passWord;

//密码 字母 数字 下划线 6-18 位  客户要求：密码：6-18位，数字，字母，下划线，至少要数字，字母两种以上不同组合，不能含有空格
+ (BOOL) validatePasswordA:(NSString *)passWord;
//昵称
+ (BOOL) validateNickname:(NSString *)nickname;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

//判断必须是数字
+ (BOOL)validateNumber:(NSString*)number ;

/** 判断一定的长度之后，输入的必须是字母或是数字 */
+(BOOL)judgePassWordLegal:(NSString *)pass ;

@end
