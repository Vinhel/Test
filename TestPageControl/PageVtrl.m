//
//  PageVtrl.m
//  TestPageControl
//
//  Created by noah on 2017/03/15.
//  Copyright © 2017年 noah. All rights reserved.
//

#import "PageVtrl.h"
#import "RKSwipeBetweenViewControllers.h"
#import "XTSegmentControl.h"

@interface PageVtrl ()
@property (weak, nonatomic) IBOutlet UIView *containnerView;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic)  RKSwipeBetweenViewControllers *navigationController;
@end

@implementation PageVtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    _pageViewController = self.childViewControllers.firstObject;
//    _pageViewController.dataSource = self;
    
        UIPageViewController *pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    
    UIViewController *demo1 = [[UIViewController alloc]init];
    UIViewController *demo2 = [[UIViewController alloc]init];
    UIViewController *demo3 = [[UIViewController alloc]init];
    UIViewController *demo4 = [[UIViewController alloc]init];
    demo1.view.backgroundColor = [UIColor redColor];
    demo2.view.backgroundColor = [UIColor orangeColor];
    demo3.view.backgroundColor = [UIColor yellowColor];
    demo4.view.backgroundColor = [UIColor blueColor];
    
    _navigationController = [[RKSwipeBetweenViewControllers alloc]initWithRootViewController:pageController];
    [_navigationController.viewControllerArray addObjectsFromArray:@[demo1,demo2,demo3,demo4]];
    _navigationController.buttonText = @[@"btn_user_on", @"btn_user_on", @"btn_user_on"];
    _navigationController.navigationBarHidden = YES;
  
    [self addChildViewController:_navigationController];
    _navigationController.view.frame = self.containnerView.frame;
    [self.containnerView addSubview:_navigationController.view];
    
//    [self.containnerView addSubview:nav_tweet.view];
  
    
    NSArray<UIImage *> *images = @[[UIImage imageNamed:@"btn_user_off"],
                                   [UIImage imageNamed:@"btn_init_off"],
                                   [UIImage imageNamed:@"btn_mobile_off"],
                                   [UIImage imageNamed:@"btn_device_off"]];
    
    NSArray<UIImage *> *selectedImages = @[[UIImage imageNamed:@"btn_user_on"],
                                           [UIImage imageNamed:@"btn_init_on"],
                                           [UIImage imageNamed:@"btn_mobile_on"],
                                           [UIImage imageNamed:@"btn_device_on"]];
    
    NSArray *imgArr = @[@"btn_user_off", @"btn_init_off", @"btn_mobile_off",@"btn_device_off"];
    
    //    HMSegmentedControl *segmentedControl2 = [[HMSegmentedControl alloc] initWithSectionImages:images sectionSelectedImages:selectedImages];
    //    segmentedControl2.frame = CGRectMake(0, 0, 375, 50);
    //    segmentedControl2.selectionIndicatorHeight = 4.0f;
    //    segmentedControl2.backgroundColor = [UIColor clearColor];
    //    segmentedControl2.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //    segmentedControl2.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //    [segmentedControl2 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    //    [self.view addSubview:segmentedControl2];
    
    __weak typeof(self) weakSelf = self;

    
    XTSegmentControl *mySegmentControl = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 64, 375, 50) Items:imgArr withIcon:YES selectedBlock:^(NSInteger index) {
        
        NSLog(@"index %d", index);
        
      
                
        weakSelf.navigationController.selectedIndex = index;
        
    }];
    [mySegmentControl selectIndex:3];
    
    [self.view addSubview:mySegmentControl];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
