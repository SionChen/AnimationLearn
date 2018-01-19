//
//  ViewController.m
//  AnimationCircleDemo
//
//  Created by 超级腕电商 on 2018/1/19.
//  Copyright © 2018年 超级腕电商. All rights reserved.
//

#import "ViewController.h"
#import "CircleView.h"
#import "CircleLayer.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UISlider *sliderView;
@property (weak, nonatomic) IBOutlet UILabel *currentValueLabel;
@property (nonatomic,strong) CircleView *circleView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.sliderView addTarget:self action:@selector(valuechanged:) forControlEvents:UIControlEventValueChanged];

    [self.view addSubview:self.circleView];
    //首次进入
    self.circleView.circleLayer.progress = self.sliderView.value;
}

-(void)valuechanged:(UISlider *)sender{
    self.currentValueLabel.text = [NSString stringWithFormat:@"Current: %f",sender.value];
    self.circleView.circleLayer.progress = sender.value;
}

#pragma mark ---G
-(CircleView*)circleView{
    if(!_circleView){
        _circleView = [[CircleView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 320/2, self.view.frame.size.height/2 - 320/2, 320, 320)];
    }
    return _circleView;
}

@end
