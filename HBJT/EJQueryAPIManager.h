//
//  EJQueryAPIManager.h
//  HBJT
//
//  Created by Davina on 16/3/13.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJS/EJS.h"

typedef NS_ENUM(NSUInteger, EJQueryAPIManagerSection) {
    EJQueryAPIManagerSectionCaogao = 0,
    EJQueryAPIManagerSectionDaishen = 1,
    EJQueryAPIManagerSectionTuihui = 2,
    EJQueryAPIManagerSectionShouli = 3,
    EJQueryAPIManagerSectionYiban = 4,
    EJQueryAPIManagerSectionPingyi = 5
};

@interface EJQueryAPIManager : EJSAPIManager

- (instancetype)initWithQuerySection:(EJQueryAPIManagerSection)section ID:(NSString *)userIDString;
- (void)setPageNumber:(NSString *)pageNumber;

@end
