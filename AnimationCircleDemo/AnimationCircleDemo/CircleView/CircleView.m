//
//  CircleView.m
//  AnimationCircleDemo
//
//  Created by 超级腕电商 on 2018/1/19.
//  Copyright © 2018年 超级腕电商. All rights reserved.
//

#import "CircleView.h"
#import "CircleLayer.h"

@implementation CircleView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor grayColor];
        self.circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self.layer addSublayer:self.circleLayer];
    }
    
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.circleLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
}
#pragma mark ---G
-(CircleLayer*)circleLayer{
    if(!_circleLayer){
        _circleLayer = [CircleLayer layer];
        _circleLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _circleLayer;
}
@end
