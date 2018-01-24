//
//  CuteView.m
//  CuteViewDemo
//
//  Created by 超级腕电商 on 2018/1/23.
//  Copyright © 2018年 超级腕电商. All rights reserved.
//

#import "CuteView.h"
@interface CuteView ()
//父视图
@property (nonatomic,strong)UIView *containerView;


//气泡 拖拽
@property (nonatomic,strong)UIView *frontView;
//位置不变大小变化的点
@property (nonatomic,strong) UIView *backView;
/*cuteShapeLayer*/
@property (nonatomic,strong) CAShapeLayer *cuteShapeLayer;
@end
@implementation CuteView{
    //填充颜色
    UIColor *fillColorForCute;
    
    CGFloat r1;
    CGFloat r2;
    CGFloat x1;
    CGFloat y1;
    CGFloat x2;
    CGFloat y2;
    CGFloat centerDistance;//d点
    CGFloat cosDigree;//角度cos值
    CGFloat sinDigree;//角度sin值
    
    CGPoint pointA; //A
    CGPoint pointB; //B
    CGPoint pointD; //D
    CGPoint pointC; //C
    CGPoint pointO; //O
    CGPoint pointP; //P
    
    //最初气泡的位置
    CGRect oldBackViewFrame;
    //最初气泡位置
    CGPoint initialPoint;
    //最初气泡中心点
    CGPoint oldBackViewCenter;
    
}
-(id)initWithOrigin:(CGPoint)origin superView:(UIView *)view{
    self = [super initWithFrame:CGRectMake(origin.x, origin.y, self.bubbleWidth, self.bubbleWidth)];
    if(self){
        initialPoint = origin;
        self.containerView = view;
        [self.containerView addSubview:self];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}
-(void)setUp{
    self.backgroundColor = [UIColor clearColor];
    self.frontView.frame = CGRectMake(initialPoint.x,initialPoint.y, self.bubbleWidth, self.bubbleWidth);
    
    r2 = self.frontView.bounds.size.width / 2;
    self.frontView.layer.cornerRadius = r2;
    self.frontView.backgroundColor = self.bubbleColor;
    
    self.backView.frame = self.frontView.frame;
    r1 = self.backView.bounds.size.width / 2;
    self.backView.layer.cornerRadius = r1;
    self.backView.backgroundColor = self.bubbleColor;
    
    self.bubbleLabel.frame = CGRectMake(0, 0, self.frontView.bounds.size.width, self.frontView.bounds.size.height);
    [self.frontView insertSubview:self.bubbleLabel atIndex:0];
    
    [self.containerView addSubview:self.backView];
    [self.containerView addSubview:self.frontView];
    
    x1 = self.backView.center.x;
    y1 = self.backView.center.y;
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    
    pointA = CGPointMake(x1-r1,y1);   // A
    pointB = CGPointMake(x1+r1, y1);  // B
    pointD = CGPointMake(x2-r2, y2);  // D
    pointC = CGPointMake(x2+r2, y2);  // C
    pointO = CGPointMake(x1-r1,y1);   // O
    pointP = CGPointMake(x2+r2, y2);  // P
    
    oldBackViewFrame = self.backView.frame;
    oldBackViewCenter = self.backView.center;
    
    self.backView.hidden = YES;//为了看到 frontView 的气泡晃动效果，需要暂时隐藏 backView
    [self addAniamtionLikeGameCenterBubble];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleDragGesture:)];
    [self.frontView addGestureRecognizer:pan];
}
-(void)handleDragGesture:(UIPanGestureRecognizer *)ges{
    CGPoint dragPoint = [ges locationInView:self.containerView];//拖拽中心点
    if (ges.state == UIGestureRecognizerStateBegan) {//将要开始拖拽
        self.backView.hidden = NO;
        [self removeAniamtionLikeGameCenterBubble];//移除跳动效果

    }else if (ges.state == UIGestureRecognizerStateChanged){//正在拖动
        self.frontView.center = dragPoint;
        if (r1 <= 6) {//当backView缩小到一定大小时 结束粘性动画
            self.backView.hidden = YES;
            [self.cuteShapeLayer removeFromSuperlayer];
        }
        [self drawCute];//实时绘图
    }else if (ges.state == UIGestureRecognizerStateEnded || ges.state ==UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateFailed){
        
        self.backView.hidden = YES;
        [self.cuteShapeLayer removeFromSuperlayer];
        [UIView animateWithDuration:0.5 delay:0.0f usingSpringWithDamping:0.4f initialSpringVelocity:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.frontView.center = oldBackViewCenter;
        } completion:^(BOOL finished) {
            if (finished) {
                [self addAniamtionLikeGameCenterBubble];
                r1 = oldBackViewFrame.size.width/2;
            }
        }];
    }
    
}
//画图
-(void)drawCute{
    x2 = self.frontView.center.x;
    y2 = self.frontView.center.y;
    centerDistance = sqrtf((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1));
    if (centerDistance<=0) {
        sinDigree = 0;
        cosDigree = 1;
    }else{
        sinDigree = (x2-x1)/centerDistance;
        cosDigree = (y2-y1)/centerDistance;
    }
    r1 = oldBackViewFrame.size.width/2 - centerDistance/self.viscosity;
    
    pointA = CGPointMake(x1-r1*cosDigree, y1+r1*sinDigree);
    pointB = CGPointMake(x1+r1*cosDigree, y1-r1*sinDigree);
    pointC = CGPointMake(x2+r2*cosDigree, y2-r2*sinDigree);
    pointD = CGPointMake(x2-r2*cosDigree, y2+r2*sinDigree);
    pointO = CGPointMake(pointA.x+(centerDistance/2)*sinDigree, pointA.y+(centerDistance/2)*cosDigree);
    pointP = CGPointMake(pointB.x+(centerDistance/2)*sinDigree, pointB.y+(centerDistance/2)*cosDigree);
    
    self.backView.bounds = CGRectMake(0, 0, r1*2, r1*2);//原图中心点不变 大小变化
    self.backView.center = oldBackViewCenter;
    self.backView.layer.cornerRadius = r1;
    
    UIBezierPath * cutePath = [UIBezierPath bezierPath];
    [cutePath moveToPoint:pointA];
    [cutePath addQuadCurveToPoint:pointD controlPoint:pointO];
    [cutePath addLineToPoint:pointC];
    [cutePath addQuadCurveToPoint:pointB controlPoint:pointP];
    [cutePath moveToPoint:pointA];
    
    if (self.backView.hidden==NO) {
        self.cuteShapeLayer.fillColor = self.bubbleColor.CGColor;
        self.cuteShapeLayer.path = cutePath.CGPath;
        [self.containerView.layer insertSublayer:self.cuteShapeLayer below:self.frontView.layer];
    }
    
}
//---- 类似GameCenter的气泡晃动动画 ------

-(void)addAniamtionLikeGameCenterBubble {
    //位置变化
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 5.0;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    CGRect circleContainer = CGRectInset(self.frontView.frame, self.frontView.bounds.size.width / 2 - 3, self.frontView.bounds.size.width / 2 - 3);
    // CGPathAddEllipseInRect 画椭圆 在 circleContainer
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    [self.frontView.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
    CAKeyframeAnimation *scaleX = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.x"];
    scaleX.duration = 1;
    scaleX.values = @[@1.0, @1.1, @1.0];
    scaleX.keyTimes = @[@0.0, @0.5, @1.0];
    scaleX.repeatCount = INFINITY;
    scaleX.autoreverses = YES;
    
    scaleX.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontView.layer addAnimation:scaleX forKey:@"scaleXAnimation"];
    
    
    CAKeyframeAnimation *scaleY = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale.y"];
    scaleY.duration = 1.5;
    scaleY.values = @[@1.0, @1.1, @1.0];
    scaleY.keyTimes = @[@0.0, @0.5, @1.0];
    scaleY.repeatCount = INFINITY;
    scaleY.autoreverses = YES;
    scaleY.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.frontView.layer addAnimation:scaleY forKey:@"scaleYAnimation"];
}

-(void)removeAniamtionLikeGameCenterBubble {
    [self.frontView.layer removeAllAnimations];
}
#pragma mark ---G
-(UIView*)backView{
    if(!_backView){
        _backView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _backView;
}
-(UIView*)frontView{
    if(!_frontView){
        _frontView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _frontView;
}
-(CAShapeLayer*)cuteShapeLayer{
    if(!_cuteShapeLayer){
        _cuteShapeLayer = [CAShapeLayer layer];
    }
    return _cuteShapeLayer;
}
-(UILabel*)bubbleLabel{
    if(!_bubbleLabel){
        _bubbleLabel = [[UILabel alloc]init];
        _bubbleLabel.textColor = [UIColor whiteColor];
        _bubbleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _bubbleLabel;
}
@end
