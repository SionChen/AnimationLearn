//
//  CuteView.h
//  CuteViewDemo
//
//  Created by 超级腕电商 on 2018/1/23.
//  Copyright © 2018年 超级腕电商. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CuteView : UIView
//气泡的直径
@property (nonatomic,assign)CGFloat bubbleWidth;
//气泡粘性系数，越大可以拉得越长
@property (nonatomic,assign)CGFloat viscosity;

//气泡颜色
@property (nonatomic,strong)UIColor *bubbleColor;
//气泡上显示数字的label
@property (nonatomic,strong)UILabel *bubbleLabel;
/**
 初始化方法

 @param origin 位置
 @param view suoerview
 @return 实例
 */
-(id)initWithOrigin:(CGPoint)origin superView:(UIView *)view;
-(void)setUp;
@end
