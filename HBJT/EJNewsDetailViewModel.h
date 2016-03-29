//
//  EJNewsDetailViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTViewModel.h"

@interface EJNewsDetailViewModel : FTViewModel

@property (nonatomic, strong) NSString *articleID;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleDate;
@property (nonatomic, strong) NSString *articleRead;
@property (nonatomic, strong) NSString *articleLaud;

@property (nonatomic, strong) NSString *htmlString;


- (void)loadArticleDetail;

@end
