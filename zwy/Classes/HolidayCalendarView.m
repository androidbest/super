//
//  HolidayCalendarView.m
//  zwy
//
//  Created by cqsxit on 14-2-20.
//  Copyright (c) 2014年 sxit. All rights reserved.
//

#import "HolidayCalendarView.h"
#import "LineLayout.h"
#import "CalendarCell.h"
#import "ToolUtils.h"
#import "KxMenu.h"

#define Image_Calendar(path , number) [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.jpg",path,number]]
@interface HolidayCalendarView ()<KxMenuViewdelegate>
{
    NSString *strImagePath;
    NSDictionary * dicImage;
    NSArray *arrHolidayName;
    UIImageView * _imageView;
}
@end

@implementation HolidayCalendarView

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
        if (iPhone5)
            strImagePath=@"holiday_4_";
        else
            strImagePath =@"holiday_5_";
        
        dicImage = @{@"春节"  :Image_Calendar(strImagePath,  @"chunjie"),
                     @"端午节":Image_Calendar(strImagePath,   @"duanwu"),
                     @"中秋节":Image_Calendar(strImagePath, @"zhongqiu"),
                     @"国庆节":Image_Calendar(strImagePath,  @"guoqing"),
                     @"劳动节":Image_Calendar(strImagePath,  @"laodong"),
                     @"清明节":Image_Calendar(strImagePath, @"qingming")};
        
        arrHolidayName =@[@"春节",@"端午节",@"中秋节",@"国庆节",@"劳动节",@"清明节"];
        
        
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *labelBack =[[UILabel alloc] init];
    labelBack.frame=CGRectMake(0, 64, ScreenWidth, 72);
    labelBack.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    labelBack.layer.zPosition=-1;
    [self.view addSubview:labelBack];
    float rectGetHeight ;
    if (iPhone5) rectGetHeight=390;
    else rectGetHeight=340;
    _imageView =[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, rectGetHeight)];
    if (_holidayName)_imageView.image=dicImage[_holidayName];
    [_scroll addSubview:_imageView];
    
    [_btnCalendar addTarget:self action:@selector(btnCalendar:) forControlEvents:UIControlEventTouchUpInside];
    if (_holidayName) [self.btnCalendar setTitle:_holidayName forState:UIControlStateNormal];
    
    [_btnDown addTarget:self action:@selector(btnCalendar:) forControlEvents:UIControlEventTouchUpInside];
	// Do any additional setup after loading the view.
}

#pragma mark - 按钮触发的方法
//选取要查看的月数
- (void)btnCalendar:(id)sender{
    NSMutableArray * arr=[[NSMutableArray alloc] init];
    for (int i=0;i<arrHolidayName.count;i++) {
        [arr addObject:[KxMenuItem menuItem:arrHolidayName[i]
                                      image:nil
                                     target:nil
                                     action:NULL]];
    }
    [KxMenuView setContentViewWidth:100 withChangeablyHeight:true];
    
    [KxMenuView setbackGroupTopColour:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0]
               withBackGroupBtnColour:[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0]];
    
    [KxMenuView setTitleColour:[UIColor whiteColor]];
    
    [KxMenu showMenuInView:self.view
                  fromRect:self.btnCalendar.frame
                 menuItems:arr
          initWithdelegate:self
     ];
}

#pragma mark - KxMenuViewdelegate
//KxMenuView的回调函数
-(void)pathIndexpath:(NSInteger)index{
    [KxMenu dismissMenu];
    [self.btnCalendar setTitle:arrHolidayName[index] forState:UIControlStateNormal];
    _imageView.image =dicImage[arrHolidayName[index]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
