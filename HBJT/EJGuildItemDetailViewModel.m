//
//  EJGuildItemDetailViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/28.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJGuildItemDetailViewModel.h"
#import "EJItemInfoAPIManager.h"

@interface EJGuildItemDetailViewModel()

@property (strong, nonatomic) EJItemInfoAPIManager *itemInfoAPIManager;
@property (strong, nonatomic) RACSignal *itemInfoSignal;

@end

@implementation EJGuildItemDetailViewModel

- (void)autoStart
{
    @weakify(self);
    self.itemInfoSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.itemInfoAPIManager launchRequestWithSuccess:^(id responseObject) {
            @strongify(self);
            if ([self.itemInfoAPIManager newStatus])
            {
                [subscriber sendError:nil];
            }
            else
            {
                [subscriber sendCompleted];
            }
        } failure:^(NSError *error) {
            [subscriber sendError:error];
        }];
        return nil;
    }];
}

- (void)loadItemInfo
{
    self.itemInfoAPIManager = [[EJItemInfoAPIManager alloc]initWIthItemID:self.itemID];
    self.isNetworkProceed = YES;
    self.networkHintText = @"正在读取";
    [self.itemInfoSignal subscribeError:^(NSError *error) {
        self.networkHintText = self.itemInfoAPIManager.statusDescription;
        self.isNetworkProceed = NO;
    } completed:^{
        self.itemName = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemName"]];
        self.itemSetupOffice = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemSetupOffice"]];
        self.itemImplementOffice = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemImplementOffice"]];
        self.itemUndertakeOffice = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemUndertakeOffice"]];
        self.itemParticipateOffice = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemParticipateOffice"]];
        self.itemLegal = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemLegal"]];
        self.itemTerm = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemTerm"]];
        self.itemDocument = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemDocument"]];
        self.itemLocation = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemLocation"]];
        self.itemConsultation = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemConsultation"]];
        self.itemComplaint = [self zeroToNull: [self.itemInfoAPIManager.data objectForKey:@"itemComplaint"]];
        self.networkHintText = self.itemInfoAPIManager.statusDescription;
        NSLog(@"%@",self.itemName);
        self.isNetworkProceed = NO;
    }];
}

- (NSString *)zeroToNull:(NSString *)zero
{
    if ([zero isEqualToString:@"0"]) {
        return @"";
    }
    return zero;
}

@end
