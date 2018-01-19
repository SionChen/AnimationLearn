//
//  CircleLayer.m
//  AnimationCircleDemo
//
//  Created by 超级腕电商 on 2018/1/19.
//  Copyright © 2018年 超级腕电商. All rights reserved.
//

#import "CircleLayer.h"
#import <UIKit/UIKit.h>
typedef enum MovingPoint{
    POINT_D,
    POINT_B,
} MovingPoint;
/*外接正方形宽高*/
#define rectangleSize  90
@interface CircleLayer ()
/*外接矩形frame*/
@property (nonatomic,assign)CGRect  outsideRect;
/*形变点*/
@property (nonatomic,assign) MovingPoint movePoint;
/*圆形*/
@property (nonatomic,strong) CAShapeLayer *ovalLayer;
/*控制点+ABCD点*/
@property (nonatomic,strong) CAShapeLayer *pointLayer;
/*矩形*/
@property (nonatomic,strong) CAShapeLayer *rectangleLayer;
/*装着点的layer列表*/
@property (nonatomic,strong) NSMutableArray *pointArray;
@end

@implementation CircleLayer

-(id)init{
    self = [super init];
    if (self) {
        [self addSublayer:self.ovalLayer];
        [self addSublayer:self.pointLayer];
        [self addSublayer:self.rectangleLayer];
    }
    return self;
}

-(void)setProgress:(CGFloat)progress{
    _progress = progress;
    //只要外接矩形在左侧，则改变B点；在右边，改变D点
    if (progress <= 0.5) {
        self.movePoint = POINT_B;
        NSLog(@"B点动");
        
    }else{
        self.movePoint = POINT_D;
        NSLog(@"D点动");
    }
    // self.position.x  锚点相对于superlayer的位置 这里是中心点
    //矩形的x坐标
    CGFloat rectangle_x = self.position.x - rectangleSize/2 + (progress - 0.5)*(self.frame.size.width -rectangleSize );
    //矩形的y坐标
    CGFloat rectangle_y= self.position.y - rectangleSize/2;
    self.outsideRect = CGRectMake(rectangle_x, rectangle_y, rectangleSize, rectangleSize);
    
    //[self setNeedsDisplay];
    self.ovalLayer.frame = self.bounds;
    self.pointLayer.frame = self.bounds;
    self.rectangleLayer.frame = self.bounds;
    [self setPath];
}
#pragma mark ---Path
-(void)setPath{
/****************************************说明**************************************************/
    //从最上面中心的 顺时针顺序 分布点是 A c1 c2 B c3 c4 C c5 c6 D c7 c8
    
    
    //各控制点相对于 A B C D 四点的距离  设置为正方形边长的1/3.6倍时，画出来的圆弧完美贴合圆形
    CGFloat offset = self.outsideRect.size.width / 3.6;
    
    //圆形A C 点相对于矩形内的偏移距离   B  D的偏移距离为控制点偏移量的2倍 效果最好
    CGFloat moveDistance = (self.outsideRect.size.width*1 / 6) *fabs(self.progress - 0.5)*2;
    
    //矩形中心点 方便下面计算
    CGPoint rectangleCenter = CGPointMake(self.outsideRect.origin.x+rectangleSize/2, self.outsideRect.origin.y+rectangleSize/2);
    //四个点
    CGPoint pointA = CGPointMake(rectangleCenter.x, self.outsideRect.origin.y + moveDistance);
    CGPoint pointB = CGPointMake(self.movePoint == POINT_B?rectangleCenter.x+rectangleSize/2+moveDistance*2:rectangleCenter.x+rectangleSize/2,rectangleCenter.y);
    CGPoint pointC = CGPointMake(rectangleCenter.x, rectangleCenter.y+rectangleSize/2-moveDistance);
    CGPoint pointD = CGPointMake(self.movePoint == POINT_D?self.outsideRect.origin.x-moveDistance*2:self.outsideRect.origin.x, rectangleCenter.y);
    
    //八个控制点 每段曲线两个 共四段曲线
    CGPoint controlC1 = CGPointMake(pointA.x+offset, pointA.y);
    CGPoint controlC2 = CGPointMake(pointB.x, self.movePoint == POINT_B?pointB.y-offset+moveDistance:pointB.y-offset);
    CGPoint controlC3 = CGPointMake(pointB.x, self.movePoint == POINT_B?pointB.y+offset-moveDistance:pointB.y+offset);
    CGPoint controlC4 = CGPointMake(pointC.x+offset, pointC.y);
    CGPoint controlC5 = CGPointMake(pointC.x-offset, pointC.y);
    CGPoint controlC6 = CGPointMake(pointD.x, self.movePoint == POINT_D?pointD.y+offset-moveDistance:pointD.y+offset);
    CGPoint controlC7 = CGPointMake(pointD.x, self.movePoint == POINT_D?pointD.y-offset+moveDistance:pointD.y-offset);
    CGPoint controlC8 = CGPointMake(pointA.x-offset, pointA.y);
    
    
    //画圆
    UIBezierPath * ovalPath = [UIBezierPath bezierPath];
    [ovalPath moveToPoint:pointA];
    [ovalPath addCurveToPoint:pointB controlPoint1:controlC1 controlPoint2:controlC2];
    [ovalPath addCurveToPoint:pointC controlPoint1:controlC3 controlPoint2:controlC4];
    [ovalPath addCurveToPoint:pointD controlPoint1:controlC5 controlPoint2:controlC6];
    [ovalPath addCurveToPoint:pointA controlPoint1:controlC7 controlPoint2:controlC8];
    [ovalPath closePath];
    
    self.ovalLayer.path = ovalPath.CGPath;
    //绘制各点的连线
    UIBezierPath * pointPath = [UIBezierPath bezierPath];
    
    //[pointPath setLineDash:dash count:2 phase:0];
    [pointPath moveToPoint:pointA];
    [pointPath addLineToPoint:controlC1];
    [pointPath addLineToPoint:controlC2];
    [pointPath addLineToPoint:pointB];
    [pointPath addLineToPoint:controlC3];
    [pointPath addLineToPoint:controlC4];
    [pointPath addLineToPoint:pointC];
    [pointPath addLineToPoint:controlC5];
    [pointPath addLineToPoint:controlC6];
    [pointPath addLineToPoint:pointD];
    [pointPath addLineToPoint:controlC7];
    [pointPath addLineToPoint:controlC8];
    [pointPath addLineToPoint:pointA];
    [pointPath closePath];
    
    self.pointLayer.path = pointPath.CGPath;
    //绘制各点
    NSArray *points = @[[NSValue valueWithCGPoint:pointA],[NSValue valueWithCGPoint:pointB],[NSValue valueWithCGPoint:pointC],[NSValue valueWithCGPoint:pointD],[NSValue valueWithCGPoint:controlC1],[NSValue valueWithCGPoint:controlC2],[NSValue valueWithCGPoint:controlC3],[NSValue valueWithCGPoint:controlC4],[NSValue valueWithCGPoint:controlC5],[NSValue valueWithCGPoint:controlC6],[NSValue valueWithCGPoint:controlC7],[NSValue valueWithCGPoint:controlC8]];
    for (NSValue * pointValue in points) {
        CAShapeLayer * pointLayer = self.pointArray[[points indexOfObject:pointValue]];
        pointLayer.frame = self.bounds;
        CGPoint point = [pointValue CGPointValue];
        UIBezierPath * pointPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(point.x-2, point.y-2, 4, 4) cornerRadius:2];
        pointLayer.path = pointPath.CGPath;
    }
    
    //绘制矩形
    UIBezierPath * rectanglepath =[UIBezierPath bezierPathWithRect:self.outsideRect];
    self.rectangleLayer.path = rectanglepath.CGPath;
}


#pragma mark ---G
-(CAShapeLayer*)ovalLayer{
    if(!_ovalLayer){
        _ovalLayer = [CAShapeLayer layer];
        _ovalLayer.strokeColor = [UIColor blackColor].CGColor;
        _ovalLayer.fillColor = [UIColor redColor].CGColor;
    }
    return _ovalLayer;
}
-(CAShapeLayer*)pointLayer{
    if(!_pointLayer){
        _pointLayer = [CAShapeLayer layer];
        _pointLayer.strokeColor = [UIColor blackColor].CGColor;
        _pointLayer.fillColor = [UIColor clearColor].CGColor;
        [_pointLayer setLineDashPattern:@[@2.0,@2.0]];
        [_pointLayer setLineDashPhase:0.0];
    }
    return _pointLayer;
}
-(NSMutableArray*)pointArray{
    if(!_pointArray){
        _pointArray = [[NSMutableArray alloc] initWithCapacity:12];
        for (int i = 0; i<12; i++) {
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.strokeColor = [UIColor clearColor].CGColor;
            layer.fillColor = [UIColor yellowColor].CGColor;
            [_pointArray addObject:layer];
            [self addSublayer:layer];
        }
    }
    return _pointArray;
}
-(CAShapeLayer*)rectangleLayer{
    if(!_rectangleLayer){
        _rectangleLayer = [CAShapeLayer layer];
        _rectangleLayer.strokeColor = [UIColor blackColor].CGColor;
        _rectangleLayer.fillColor = [UIColor clearColor].CGColor;
        [_rectangleLayer setLineDashPattern:@[@4.0,@4.0]];
        [_rectangleLayer setLineDashPhase:0.0];
    }
    return _rectangleLayer;
}
@end
