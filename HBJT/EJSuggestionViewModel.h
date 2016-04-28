//
//  EJSuggestionViewModel.h
//  HBJT
//
//  Created by Davina on 16/3/14.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJS/EJS.h"

@interface EJSuggestionViewModel : FTViewModel

@property (strong, nonatomic) NSString *suggestionText;
@property (strong, nonatomic) NSString *nameText;
@property (strong, nonatomic) NSString *emailText;
@property (strong, nonatomic) NSString *phoneText;
@property (strong, nonatomic) NSString *qqText ;

- (void)suggest;

@end
