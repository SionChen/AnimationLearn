//
//  ViewController.m
//  GooeySlideMenuDemo
//
//  Created by 超级腕电商 on 2018/1/22.
//  Copyright © 2018年 超级腕电商. All rights reserved.
//

#import "ViewController.h"
#import "GooeySlideMenu.h"

@interface ViewController ()
@property (nonatomic,strong) GooeySlideMenu *menu;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"首页";
}

- (IBAction)triggerActions:(id)sender {
    [self.menu trigger];
}

-(GooeySlideMenu*)menu{
    if(!_menu){
        _menu = [[GooeySlideMenu alloc]initWithTitles:@[@"首页",@"消息",@"发布",@"发现",@"个人",@"设置"]];
        _menu.menuClickBlock = ^(NSInteger index,NSString *title,NSInteger titleCounts){
            NSLog(@"index:%ld title:%@ titleCounts:%ld",index,title,titleCounts);
        };
    }
    return _menu;
}


@end
