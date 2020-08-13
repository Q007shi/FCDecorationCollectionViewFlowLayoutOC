//
//  FCCollectionReusableView2.m
//  FCDecorationCollectionViewFlowLayoutOC_Example
//
//  Created by 石富才 on 2020/8/13.
//  Copyright © 2020 2585299617@qq.com. All rights reserved.
//

#import "FCCollectionReusableView2.h"

@implementation FCCollectionReusableView2

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.redColor;
        self.layer.cornerRadius = 20;
        self.layer.masksToBounds = YES;
    }
    return self;
}

@end
