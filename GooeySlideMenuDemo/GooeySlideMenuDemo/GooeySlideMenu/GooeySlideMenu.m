//
//  GooeySlideMenu.m
//  GooeySlideMenuDemo
//
//  Created by 超级腕电商 on 2018/1/22.
//  Copyright © 2018年 超级腕电商. All rights reserved.
//

#import "GooeySlideMenu.h"
#import "SlideMenuButton.h"
#define buttonSpace 30
#define menuBlankWidth 50
@interface GooeySlideMenu ()
/*背景*/
@property (nonatomic,strong) CAShapeLayer *backShapeLayer;
/*Keywindow*/
@property (nonatomic,strong) UIWindow *keyWindow;
/*背景view  （毛玻璃）*/
@property (nonatomic,strong) UIVisualEffectView *blurView;
/*辅助视图 red*/
@property (nonatomic,strong) UIView *helperSideView;
/*辅助视图 yellow*/
@property (nonatomic,strong) UIView *helperCenterView;
/* */
@property (nonatomic,strong) CADisplayLink *displayLink;
@property  NSInteger animationCount; // 动画的数量
@end

@implementation GooeySlideMenu{
    //按钮高度
    CGFloat menuButtonHeight;
    //是否已展开
    BOOL triggered;
    //偏离中心的位置
    CGFloat offset;
}
#pragma mark ---初始化
-(id)initWithTitles:(NSArray *)titles{
    return [self initWithTitles:titles withButtonHeight:40.0f withMenuColor:[UIColor colorWithRed:0 green:0.722 blue:1 alpha:1] withBackBlurStyle:UIBlurEffectStyleDark];
}

-(id)initWithTitles:(NSArray *)titles withButtonHeight:(CGFloat)height withMenuColor:(UIColor *)menuColor withBackBlurStyle:(UIBlurEffectStyle)style{
    
    self = [super init];
    if (self) {
        self.backShapeLayer.fillColor = menuColor.CGColor;
        self.blurView.frame = self.keyWindow.frame;
        self.blurView.alpha = 0.0f;
        
        self.helperSideView.frame = CGRectMake(-40, 0, 40, 40);
        self.helperSideView.backgroundColor = [UIColor redColor];
        self.helperSideView.hidden = YES;
        [self.keyWindow addSubview:self.helperSideView];
        
        self.helperCenterView.frame = CGRectMake(-40, CGRectGetHeight(self.keyWindow.frame)/2 - 20, 40, 40);
        self.helperCenterView.backgroundColor = [UIColor yellowColor];
        self.helperCenterView.hidden = YES;
        [self.keyWindow addSubview:self.helperCenterView];
        
        self.frame = CGRectMake(- self.keyWindow.frame.size.width/2 - menuBlankWidth, 0, self.keyWindow.frame.size.width/2+menuBlankWidth, self.keyWindow.frame.size.height);
        self.backgroundColor = [UIColor clearColor];
        [self.keyWindow insertSubview:self belowSubview:self.helperSideView];
        
        [self.layer addSublayer:self.backShapeLayer];
        menuButtonHeight = height;
        [self addButtons:titles];
    }
    return self;
}

#pragma mark ---Actions
-(void)addButtons:(NSArray *)titles{
    if (titles.count % 2 == 0) {
        NSInteger index_down = titles.count/2;
        NSInteger index_up = -1;
        for (NSInteger i = 0; i < titles.count; i++) {
            NSString *title = titles[i];
            SlideMenuButton *home_button = [[SlideMenuButton alloc]initWithTitle:title];
            if (i >= titles.count / 2) {
                index_up ++;
                home_button.center = CGPointMake(self.keyWindow.frame.size.width/4, self.keyWindow.frame.size.height/2 + menuButtonHeight*index_up + buttonSpace*index_up + buttonSpace/2 + menuButtonHeight/2);
            }else{
                index_down --;
                home_button.center = CGPointMake(self.keyWindow.frame.size.width/4, self.keyWindow.frame.size.height/2 - menuButtonHeight*index_down - buttonSpace*index_down - buttonSpace/2 - menuButtonHeight/2);
            }
            
            home_button.bounds = CGRectMake(0, 0, self.keyWindow.frame.size.width/2 - 20*2, menuButtonHeight);
            home_button.buttonColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
            [self addSubview:home_button];
            
            __weak typeof(self) WeakSelf = self;
            home_button.buttonClickBlock = ^(){
                [WeakSelf tapToUntrigger];
                WeakSelf.menuClickBlock(i,title,titles.count);
            };
        }
        
    }else{
        NSInteger index = (titles.count - 1) /2 +1;
        for (NSInteger i = 0; i < titles.count; i++) {
            index --;
            NSString *title = titles[i];
            SlideMenuButton *home_button = [[SlideMenuButton alloc]initWithTitle:title];
            home_button.center = CGPointMake(self.keyWindow.frame.size.width/4, self.keyWindow.frame.size.height/2 - menuButtonHeight*index - 20*index);
            home_button.bounds = CGRectMake(0, 0, self.keyWindow.frame.size.width/2 - 20*2, menuButtonHeight);
            home_button.buttonColor = [UIColor colorWithRed:0 green:0.722 blue:1 alpha:1];
            [self addSubview:home_button];
            
            __weak typeof(self) WeakSelf = self;
            home_button.buttonClickBlock = ^(){
                [WeakSelf tapToUntrigger];
                WeakSelf.menuClickBlock(i,title,titles.count);
            };
        }
    }
    
}
-(void)trigger{
    if (!triggered) {//显示
        [self.keyWindow insertSubview:self.blurView belowSubview:self];
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = self.bounds;
        }];
        
        [self beforeAnimation];
        //usingSpringWithDamping的范围为0.0f到1.0f，数值越小「弹簧」的振动效果越明显
        //initialSpringVelocity则表示初始的速度，数值越大一开始移动越快
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.5f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.helperSideView.center = CGPointMake(self.keyWindow.center.x, self.helperSideView.frame.size.height/2);
        } completion:^(BOOL finished) {
            [self finishAnimation];
        }];
        
        [UIView animateWithDuration:0.3 animations:^{
            self.blurView.alpha = 1.0f;
        }];
        
        [self beforeAnimation];
        [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.8f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            self.helperCenterView.center = self.keyWindow.center;
        } completion:^(BOOL finished) {
            if (finished) {
                UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapToUntrigger)];
                [self.blurView addGestureRecognizer:tapGes];
                [self finishAnimation];
            }
        }];
        [self animateButtons];
        triggered = YES;
    }else{
        [self tapToUntrigger];
    }
}

/**
 按钮动画
 */
-(void)animateButtons{
    for (NSInteger i = 0; i < self.subviews.count; i++) {
        
        UIView *menuButton = self.subviews[i];
        //平移
        menuButton.transform = CGAffineTransformMakeTranslation(-90, 0);
        [UIView animateWithDuration:0.7 delay:i*(0.3/self.subviews.count) usingSpringWithDamping:0.6f initialSpringVelocity:0.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
            //恢复原状
            menuButton.transform =  CGAffineTransformIdentity;
        } completion:NULL];
    }
    
}
/**
 消失动画
 */
-(void)tapToUntrigger{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(-self.keyWindow.frame.size.width/2-menuBlankWidth, 0, self.keyWindow.frame.size.width/2+menuBlankWidth, self.keyWindow.frame.size.height);
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.6f initialSpringVelocity:0.9f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.helperSideView.center = CGPointMake(-self.helperSideView.frame.size.height/2, self.helperSideView.frame.size.height/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.blurView.alpha = 0.0f;
    }];
    
    [self beforeAnimation];
    [UIView animateWithDuration:0.7 delay:0.0f usingSpringWithDamping:0.7f initialSpringVelocity:2.0f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        self.helperCenterView.center = CGPointMake(-self.helperSideView.frame.size.height/2, CGRectGetHeight(self.keyWindow.frame)/2);
    } completion:^(BOOL finished) {
        [self finishAnimation];
    }];
    
    triggered = NO;
    
}

//动画之前调用
-(void)beforeAnimation{
    if (self.displayLink == nil) {
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkAction:)];
        [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    }
    self.animationCount ++;
}

//动画完成之后调用
-(void)finishAnimation{
    self.animationCount --;
    if (self.animationCount == 0) {
        [self.displayLink invalidate];
        self.displayLink = nil;
    }
}

-(void)displayLinkAction:(CADisplayLink *)dis{
    //通过这种方法或者 两个view 在动画中的坐标变换 frame 拿不到
    CALayer *sideHelperPresentationLayer   =  (CALayer *)[self.helperSideView.layer presentationLayer];
    CALayer *centerHelperPresentationLayer =  (CALayer *)[self.helperCenterView.layer presentationLayer];
    
    CGRect centerRect = [[centerHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    CGRect sideRect = [[sideHelperPresentationLayer valueForKeyPath:@"frame"]CGRectValue];
    
    
    offset = sideRect.origin.x - centerRect.origin.x;
    
    [self updateShapeLayer];
    
}
-(void)updateShapeLayer{
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(self.frame.size.width-menuBlankWidth, 0)];
    [path addQuadCurveToPoint:CGPointMake(self.frame.size.width-menuBlankWidth, self.frame.size.height) controlPoint:CGPointMake(self.keyWindow.frame.size.width/2+offset, self.keyWindow.frame.size.height/2)];
    [path addLineToPoint:CGPointMake(0, self.frame.size.height)];
    [path closePath];
    self.backShapeLayer.path = path.CGPath;
}
#pragma mark ---G
-(CAShapeLayer*)backShapeLayer{
    if(!_backShapeLayer){
        _backShapeLayer = [CAShapeLayer layer];
        _backShapeLayer.strokeColor = [UIColor clearColor].CGColor;
    }
    return _backShapeLayer;
}
-(UIWindow*)keyWindow{
    if(!_keyWindow){
        _keyWindow = [[UIApplication sharedApplication]keyWindow];
    }
    return _keyWindow;
}
-(UIVisualEffectView*)blurView{
    if(!_blurView){
        _blurView = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    }
    return _blurView;
}
-(UIView*)helperSideView{
    if(!_helperSideView){
        _helperSideView = [[UIView alloc]initWithFrame:CGRectZero];
        _helperSideView.backgroundColor = [UIColor redColor];
    }
    return _helperSideView;
}
-(UIView*)helperCenterView{
    if(!_helperCenterView){
        _helperCenterView = [[UIView alloc]initWithFrame:CGRectZero];
        _helperCenterView.backgroundColor = [UIColor yellowColor];
    }
    return _helperCenterView;
}
@end
