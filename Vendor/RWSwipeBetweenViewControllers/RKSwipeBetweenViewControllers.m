//
//  RKSwipeBetweenViewControllers.m
//  RKSwipeBetweenViewControllers
//
//  Created by Richard Kim on 7/24/14.
//  Copyright (c) 2014 Richard Kim. All rights reserved.
//
//  @cwRichardKim for regular updates


#import "RKSwipeBetweenViewControllers.h"
#import "EasePageViewController.h"
#import "AppInfoManager.h"

//%%% customizeable button attributes
CGFloat X_BUFFER = 0.0;//52.0; //%%% the number of pixels on either side of the segment
CGFloat HEIGHT = 35.0; //%%% height of the segment
#define BUTTON_WIDTH  ([UIScreen mainScreen].bounds.size.width/4)

//%%% customizeable selector bar attributes (the black bar under the buttons)
CGFloat BOUNCE_BUFFER = 0.0; //%%% adds bounce to the selection bar when you scroll
CGFloat ANIMATION_SPEED = 0.2; //%%% the number of seconds it takes to complete the animation
CGFloat SELECTOR_Y_BUFFER = 26+30.0; //%%% the y-value of the bar that shows what page you are on (0 is the top)
CGFloat SELECTOR_HEIGHT = 5.0; //%%% thickness of the selector bar

CGFloat X_OFFSET = 8.0; //%%% for some reason there's a little bit of a glitchy offset.  I'm going to look for a better workaround in the future

@interface RKSwipeBetweenViewControllers ()

@property (nonatomic) UIScrollView *pageScrollView;
@property (nonatomic) NSInteger currentPageIndex;
@property (nonatomic) BOOL isPageScrollingFlag; //%%% prevents scrolling / segment tap crash


@property (strong, nonatomic) UIViewController *p_displayingViewController;
@end

@implementation RKSwipeBetweenViewControllers
@synthesize viewControllerArray;
@synthesize pageController;
@synthesize navigationView;

@synthesize selectionBar;

+ (instancetype)newSwipeBetweenViewControllers{
    EasePageViewController *pageController = [[EasePageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    return [[RKSwipeBetweenViewControllers alloc] initWithRootViewController:pageController];
}

- (UIViewController *)curViewController{
    if (self.viewControllerArray.count > self.currentPageIndex) {
        return [self.viewControllerArray objectAtIndex:self.currentPageIndex];
    }else{
        return nil;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationBar.translucent = NO;
    viewControllerArray = [[NSMutableArray alloc]init];
    self.currentPageIndex = 0;
    self.isPageScrollingFlag = NO;
  
  }

#pragma mark Customizables

//%%% color of the status bar
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
    //    return UIStatusBarStyleDefault;
}

//%%% sets up the tabs using a loop.  You can take apart the loop to customize individual buttons, but remember to tag the buttons.  (button.tag=0 and the second button.tag=1, etc)

 - (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupSelector {
    selectionBar = [[UIView alloc]initWithFrame:CGRectMake(X_BUFFER-X_OFFSET, SELECTOR_Y_BUFFER,(self.view.frame.size.width-2*X_BUFFER)/[viewControllerArray count], SELECTOR_HEIGHT)];
    selectionBar.backgroundColor = [UIColor greenColor]; //%%% sbcolor
    selectionBar.alpha = 0.8; //%%% sbalpha
    [navigationView addSubview:selectionBar];
}


//generally, this shouldn't be changed unless you know what you're changing
#pragma mark Setup

-(void)viewWillAppear:(BOOL)animated {
    if (!pageController) {
        [self setupPageViewController];
        [self showControllerOfIndex:_selectedIndex];
        
    }
    
        for (UIView *view in self.pageController.view.subviews) {
            if ([view isKindOfClass:UIScrollView.class]) {
                UIScrollView *scrollView = (UIScrollView *)view;
                [scrollView setScrollEnabled:NO];
            }
        }
  
}

- (void)checkUserId:(PageControlType)pageType
{
    NSMutableArray *disabledIndex = @[].mutableCopy;
    AppInfoManager *appInfoManager = [AppInfoManager sharedManager];
    switch (pageType) {
        case PAGECONTROLFOUR:{
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] &&
                ![[NSUserDefaults standardUserDefaults] objectForKey:@"accessKey"] ) {
                [disabledIndex addObject:@"1"];
                
            }
            if ((![[NSUserDefaults standardUserDefaults] objectForKey:@"ProtocolInfo"] || [appInfoManager checkFWVersion] == NSOrderedAscending)) {
                [disabledIndex addObject:@"2"];
            }
            if((![appInfoManager getIsSettingMacAdressFinished] || [appInfoManager checkFWVersion] != NSOrderedSame)
               ){
                [disabledIndex addObject:@"3"];
            }
            break;}
            
        case PAGECONTROLFIVE:{
            if ((![appInfoManager getIsSettingVeicleFinished] || [appInfoManager checkFWVersion] != NSOrderedSame) ) {
                [disabledIndex addObject:@"0"];
            }
            if ((![appInfoManager getIsSettingMacAdressFinished] || [appInfoManager checkFWVersion] == NSOrderedAscending)){
                [disabledIndex addObject:@"1"];
                [disabledIndex addObject:@"2"];
            }
            if (((![[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] &&
                  ![[NSUserDefaults standardUserDefaults] objectForKey:@"accessKey"]) || [appInfoManager checkFWVersion] == NSOrderedAscending) ) {
                [disabledIndex addObject:@"4"];
                
            }
            break;}
    }
  
}


- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    _selectedIndex = selectedIndex;
    [self showControllerOfIndex:_selectedIndex];
}

//%%% generic setup stuff for a pageview controller.  Sets up the scrolling style and delegate for the controller
-(void)setupPageViewController {
    if ([self.topViewController isKindOfClass:[UIPageViewController class]]) {
        pageController = (UIPageViewController*)self.topViewController;
        pageController.delegate = self;
        pageController.dataSource = self;
        [pageController setViewControllers:@[[viewControllerArray objectAtIndex:0]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
        [self syncScrollView];
    }
}

//%%% this allows us to get information back from the scrollview, namely the coordinate information that we can link to the selection bar.
-(void)syncScrollView {
    for (UIView* view in pageController.view.subviews){
        if([view isKindOfClass:[UIScrollView class]]) {
            self.pageScrollView = (UIScrollView *)view;
            self.pageScrollView.delegate = self;
            self.pageScrollView.scrollsToTop = NO;
        }
    }
}

//%%% methods called when you tap a button or scroll through the pages
// generally shouldn't touch this unless you know what you're doing or
// have a particular performance thing in mind

#pragma mark Movement

//%%% when you tap one of the buttons, it shows that page,
//but it also has to animate the other pages to make it feel like you're crossing a 2d expansion,
//so there's a loop that shows every view controller in the array up to the one you selected
//eg: if you're on page 1 and you click tab 3, then it shows you page 2 and then page 3



-(void)tapSegmentButtonAction:(UIButton *)button {
    
    if (!self.isPageScrollingFlag) {
        
        NSInteger tempIndex = self.currentPageIndex;
        
        __weak typeof(self) weakSelf = self;
        
        //%%% check to see if you're going left -> right or right -> left
        if (button.tag > tempIndex) {
            
            //%%% scroll through all the objects between the two points
            for (int i = (int)tempIndex+1; i<=button.tag; i++) {
                [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
                    
                    //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
                    //then it updates the page that it's currently on
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
        
        //%%% this is the same thing but for going right -> left
        else if (button.tag < tempIndex) {
            for (int i = (int)tempIndex-1; i >= button.tag; i--) {
                [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
                    if (complete) {
                        [weakSelf updateCurrentPageIndex:i];
                    }
                }];
            }
        }
    }
}

//%%% makes sure the nav bar is always aware of what page you're on
//in reference to the array of view controllers you gave
-(void)updateCurrentPageIndex:(int)newIndex {
    self.currentPageIndex = newIndex;
}

- (void)setCurrentPageIndex:(NSInteger)currentPageIndex{
    _currentPageIndex = currentPageIndex;
    [self.viewControllerArray enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        for (UIView *aView in [obj.view subviews]) {
            if ([aView isKindOfClass:[UIScrollView class]]) {
                [(UIScrollView *)aView setScrollsToTop:idx == currentPageIndex];
            }
        }
    }];
}

//%%% method is called when any of the pages moves.
//It extracts the xcoordinate from the center point and instructs the selection bar to move accordingly
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat percentX = scrollView.contentOffset.x / CGRectGetWidth(scrollView.frame);
    
    NSInteger currentPageIndex = self.currentPageIndex;
    if (_p_displayingViewController) {
        currentPageIndex = [self indexOfController:_p_displayingViewController];
    }
    percentX += currentPageIndex -1;
    
    //HMSegment
//    [self updateNavigationViewWithPercentX:percentX];
    
    //buttons
    [self updateButtonsSelection:scrollView];
}

- (void)updateNavigationViewWithPercentX:(CGFloat)percentX{
    NSInteger nearestPage = floorf(percentX + 0.5);
//    _pageControl.currentPage = nearestPage;
    
    
    //ButtonText
    
    
//    NSArray *buttons = [_buttonContainer subviews];
//    if (buttons.count > 0) {
//        [buttons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *stop) {
//            CGFloat distanceTp_percentX = percentX - idx;
//            [button setCenter:CGPointMake(_buttonContainer.center.x - distanceTp_percentX *BUTTON_WIDTH, button.center.y)];
//            button.alpha = MAX(0, 1.0 - ABS(distanceTp_percentX));
//        }];
//    }
}

- (void)updateButtonsSelection:(UIScrollView *)scrollView;
{
    CGFloat xFromCenter = self.view.frame.size.width-scrollView.contentOffset.x; //%%% positive for right swipe, negative for left
    
    //%%% checks to see what page you are on and adjusts the xCoor accordingly.
    //i.e. if you're on the second page, it makes sure that the bar starts from the frame.origin.x of the
    //second tab instead of the beginning
    NSInteger xCoor = X_BUFFER+selectionBar.frame.size.width*self.currentPageIndex-X_OFFSET;
    
    selectionBar.frame = CGRectMake(xCoor-xFromCenter/[viewControllerArray count], selectionBar.frame.origin.y, selectionBar.frame.size.width, selectionBar.frame.size.height);
}


//%%% the delegate functions for UIPageViewController.
//Pretty standard, but generally, don't touch this.
#pragma mark UIPageViewController Delegate Functions

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    _p_displayingViewController = viewController;
    NSInteger index = [self indexOfController:viewController];
    
    if ((index == NSNotFound) || (index == 0)) {
        return nil;
    }
    
    index--;
    return [viewControllerArray objectAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    _p_displayingViewController = viewController;
    NSInteger index = [self indexOfController:viewController];
    
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    
    if (index == [viewControllerArray count]) {
        return nil;
    }
    return [viewControllerArray objectAtIndex:index];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    _p_displayingViewController = nil;
    if (completed) {
        self.currentPageIndex = [self indexOfController:[pageViewController.viewControllers lastObject]];
    }
}


//%%% checks to see which item we are currently looking at from the array of view controllers.
// not really a delegate method, but is used in all the delegate methods, so might as well include it here
-(NSInteger)indexOfController:(UIViewController *)viewController {
    for (int i = 0; i<[viewControllerArray count]; i++) {
        if (viewController == [viewControllerArray objectAtIndex:i])
        {
            return i;
        }
    }
    return NSNotFound;
}

- (void)showControllerOfIndex:(NSInteger)index {
    //    segmentedControl.selectedSegmentIndex = index;
    //    [self segmentedControlChangedValue:segmentedControl];
    
    __weak typeof(self) weakSelf = self;
    if (_selectedIndex> _currentPageIndex) {
        
        //%%% scroll through all the objects between the two points
        for (int i = (int)_currentPageIndex+1; i<=_selectedIndex; i++) {
            [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL complete){
                
                //%%% if the action finishes scrolling (i.e. the user doesn't stop it in the middle),
                //then it updates the page that it's currently on
                if (complete) {
                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }
    
    //%%% this is the same thing but for going right -> left
    else if (_selectedIndex < _currentPageIndex) {
        for (int i = (int)_currentPageIndex-1; i >= _selectedIndex; i--) {
            [pageController setViewControllers:@[[viewControllerArray objectAtIndex:i]] direction:UIPageViewControllerNavigationDirectionReverse animated:YES completion:^(BOOL complete){
                if (complete) {
                    [weakSelf updateCurrentPageIndex:i];
                }
            }];
        }
    }
    
}




#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = YES;
    [self checkUserId:PAGECONTROLFOUR];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.isPageScrollingFlag = NO;
    [self checkUserId:PAGECONTROLFOUR];
}

@end
