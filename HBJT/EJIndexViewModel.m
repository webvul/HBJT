//
//  EJIndexViewModel.m
//  HBJT
//
//  Created by 方秋鸣 on 16/3/2.
//  Copyright © 2016年 fangqiuming. All rights reserved.
//

#import "EJIndexViewModel.h"

@implementation EJIndexViewModel


- (void)autoStart
{
    @weakify(self);
    self.scrollViewRotateSignal = [[[RACObserve(self, scrollViewOffset) map:^id(id value) {
        @strongify(self);
        return ([value floatValue] > self.numberOfSrollViewPage-1.01)?@(1):([value floatValue]<0.01?@(self.numberOfSrollViewPage-2):nil);
    }] filter:^BOOL(id value) {
        return (value != nil);
    }] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
    self.pageIndicatorTintSignal = [[RACObserve(self, scrollViewOffset) map:^id(id value) {
        @strongify(self);
        NSInteger i = floor([value floatValue]+0.5);
        return @(i==0?self.numberOfSrollViewPage-1:(i==self.numberOfSrollViewPage-1?0:i-1));
    }] filter:^BOOL(id value) {
        @strongify(self);
        return self.isConnected;
    }];
}


@end
