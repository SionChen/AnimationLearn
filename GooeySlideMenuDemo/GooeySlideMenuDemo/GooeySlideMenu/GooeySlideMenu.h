//
//  GooeySlideMenu.h
//  GooeySlideMenuDemo
//
//  Created by 超级腕电商 on 2018/1/22.
//  Copyright © 2018年 超级腕电商. All rights reserved.
//

#import <UIKit/UIKit.h>
/*按钮点击回调block*/
typedef void(^MenuButtonClickedBlock)(NSInteger index,NSString *title,NSInteger titleCounts);

@interface GooeySlideMenu : UIView

/**
 初始化方法

 @param titles title
 @return instance
 */
-(id)initWithTitles:(NSArray *)titles;


/**
 初始化方法

 @param titles titles
 @param height 按钮高度
 @param menuColor 背景颜色
 @param style 毛玻璃效果风格
 @return instance
 */
-(id)initWithTitles:(NSArray *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style;


/**
 *  显示/消失 方法
 */
-(void)trigger;


/**
 *
 */
@property(nonatomic,copy)MenuButtonClickedBlock menuClickBlock;

@end
