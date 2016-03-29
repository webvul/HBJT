//
//  EJGuildItemDetailViewModel.h
//  HBJT
//
//  Created by 方秋鸣 on 16/3/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "FTViewModel.h"

@interface EJGuildItemDetailViewModel : FTViewModel


@property (strong, nonatomic) NSString *itemID;

@property (strong, nonatomic)  NSString *itemName;
@property (strong, nonatomic)  NSString *itemSetupOffice;
@property (strong, nonatomic)  NSString *itemImplementOffice;
@property (strong, nonatomic)  NSString *itemUndertakeOffice;
@property (strong, nonatomic)  NSString *itemParticipateOffice;
@property (strong, nonatomic)  NSString *itemLegal;
@property (strong, nonatomic)  NSString *itemTerm;
@property (strong, nonatomic)  NSString *itemDocument;
@property (strong, nonatomic)  NSString *itemLocation;
@property (strong, nonatomic)  NSString *itemConsultation;
@property (strong, nonatomic)  NSString *itemComplaint;

- (void)loadItemInfo;

@end
