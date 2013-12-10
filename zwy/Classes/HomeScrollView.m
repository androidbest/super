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
#import "BaseTabbar.h"
@interface HomeScrollView ()

@property(strong ,nonatomic)UIScrollView *scrollView;

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
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    _scrollView.delegate = self.controller;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _scrollView.autoresizesSubviews = YES;
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.canCancelContentTouches = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
    _scrollView.clipsToBounds = YES;
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces=NO;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize=CGSizeMake(ScreenWidth*2, 0);
    [_scrollView setContentOffset:CGPointMake(320, 0)];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    BaseTabbar *detaView = [storyboard instantiateViewControllerWithIdentifier:@"zwyhome"];
    detaView.TabbarScrollView=_scrollView;
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
    if (_scrollView)
        [self reloadPages];
}


- (void)reloadPages {
    
    for (UIView *view in _scrollView.subviews) {
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
        
		[_scrollView addSubview:view];
        
		cx += _scrollView.frame.size.width;
	}
	[_scrollView setContentSize:CGSizeMake(cx, [_scrollView bounds].size.height)];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
