//
//  HomeScrollView.m
//  zwy
//
//  Created by cqsxit on 13-12-10.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "HomeScrollView.h"
#import "HomeScrollerController.h"
#import "HomeInformationView.h"

@interface HomeScrollView ()
{
    UIScrollView *scrollView;
}
@end

@implementation HomeScrollView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self =[super initWithCoder:aDecoder];
    if (self) {
        HomeScrollerController *HomeScroContro=[HomeScrollerController new];
        HomeScroContro.HomeScroView=self;
        self.controller=HomeScroContro;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.delegate = self.controller;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    scrollView.autoresizesSubviews = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.canCancelContentTouches = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    scrollView.clipsToBounds = YES;
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.bounces=NO;
    [self.view addSubview:scrollView];
    scrollView.contentSize=CGSizeMake(ScreenWidth*2, 0);
    [scrollView setContentOffset:CGPointMake(320, 0)];
	
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    UITabBarController *detaView = [storyboard instantiateViewControllerWithIdentifier:@"zwyhome"];
    HomeInformationView *homeInfomaView =[storyboard instantiateViewControllerWithIdentifier:@"HomeInformationView"];
    [self setViewControllers:@[homeInfomaView,detaView] animated:YES];
}

#pragma mark Add and remove
- (void)setViewControllers:(NSArray *)viewControllers animated:(BOOL)animated {
    if (self.childViewControllers.count > 0) {
        for (UIViewController *vC in self.childViewControllers) {
            [vC willMoveToParentViewController:nil];
            [vC removeFromParentViewController];
        }
    }
    
    for (UIViewController *vC in viewControllers)
    {
        [self addChildViewController:vC];
        [vC didMoveToParentViewController:self];
    }
    if (scrollView)
        [self reloadPages];
}


- (void)reloadPages {
    
    for (UIView *view in scrollView.subviews) {
        [view removeFromSuperview];
    }
    
	CGFloat cx = 0;
    NSUInteger count = self.childViewControllers.count;
	for (NSUInteger i = 0; i < count; i++) {
        UIView *view = [[self.childViewControllers objectAtIndex:i] view];
		CGRect rect = view.frame;
        //更改view的大小位置
		rect.origin.x = cx;
        rect.origin.y = 0;
        rect.size.height = view.frame.size.height;
		view.frame = rect;
        
		[scrollView addSubview:view];
        
		cx += scrollView.frame.size.width;
	}
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
