//
//  ViewController.m
//  TestPageControl
//
//  Created by noah on 2017/03/14.
//  Copyright © 2017年 . All rights reserved.
//

#import "ViewController.h"
#import "RKSwipeBetweenViewControllers.h"
#import "HMSegmentedControl.h"
#import "XTSegmentControl.h"
#import "NSString+customString.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem* rightButton = self.navigationItem.rightBarButtonItem;
    [rightButton setImage:[[UIImage imageNamed:@"logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    self.navigationItem.leftBarButtonItem = rightButton;
    
    
    NSArray<UIImage *> *images = @[[UIImage imageNamed:@"btn_user_off"],
                                   [UIImage imageNamed:@"btn_init_off"],
                                   [UIImage imageNamed:@"btn_mobile_off"],
                                   [UIImage imageNamed:@"btn_device_off"]];
    

    
    
    NSMutableString *k = @"btn_mon_off";
//    NSString *replacedStr = [k stringByReplacingOccurrencesOfString:@"off" withString:@"on" options:NSBackwardsSearch range:NSMakeRange([k length]-4, 3) ];
//    NSLog(@"replacedString %@", replacedStr);
    
    NSString *next = [k replaceStr:@"on" withString:@"off"];
    
    NSString *third = [k replaceStr:@"off" withString:@"on"];
    
  
    
//    HMSegmentedControl *segmentedControl2 = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages];
//    segmentedControl2.frame = CGRectMake(0, 0, 375, 50);
//    segmentedControl2.selectionIndicatorHeight = 4.0f;
//    segmentedControl2.backgroundColor = [UIColor clearColor];
//    segmentedControl2.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
//    segmentedControl2.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
//    [segmentedControl2 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
//    [self.view addSubview:segmentedControl2];
    
//    XTSegmentControl *mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, 375, 50) Items:images withIcon:YES selectedBlock:^(NSInteger index) {
//        
//    }];
//    
//    [self.view addSubview:mySegmentControl];

    
}

- (IBAction)pushAction:(id)sender {
    
    
    
        
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
