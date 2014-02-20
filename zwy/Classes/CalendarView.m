//
//  CalendarView.m
//  zwy
//
//  Created by cqsxit on 14-2-13.
//  Copyright (c) 2014年 sxit. All rights reserved.
//

#import "CalendarView.h"
#import "LineLayout.h"
#import "CalendarCell.h"
#import "ToolUtils.h"


@interface CalendarView (){
    NSString *strImagePath;
    int rows;
}

@end

@implementation CalendarView

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
            strImagePath=@"image_calendar_5_";
        else
            strImagePath =@"image_calendar_4_";
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UILabel *labelBack =[[UILabel alloc] init];
    labelBack.frame=CGRectMake(0, 64, ScreenWidth, 74);
    labelBack.backgroundColor=[UIColor colorWithRed:0.0f/255.0f green:122.0f/255.0f blue:255.0f/255.0f alpha:1.0];
    labelBack.layer.zPosition=-1;
    [self.view addSubview:labelBack];
    
    LineLayout *layout =[[LineLayout alloc] init];
    CGRect rect =self.view.frame;
    rect.origin.y=64+labelBack.frame.size.height;
    rect.size.height=ITEM_SIZE_HEIGHT;
    _collView =[[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    _collView.backgroundColor=[UIColor whiteColor];
    _collView.delegate=self;
    _collView.dataSource=self;
    _collView.pagingEnabled=YES;
    _collView.showsHorizontalScrollIndicator=NO;
    [self.view addSubview:_collView];
    [_collView registerClass:[CalendarCell class] forCellWithReuseIdentifier:@"Cell"];
    
    [_btnCalendar addTarget:self action:@selector(btnCalendar:) forControlEvents:UIControlEventTouchUpInside];
    [_btnLeft addTarget:self action:@selector(btnLeft:) forControlEvents:UIControlEventTouchUpInside];
    [_btnRight addTarget:self action:@selector(btnRight:) forControlEvents:UIControlEventTouchUpInside];
    [_btnShowDown addTarget:self action:@selector(btnCalendar:) forControlEvents:UIControlEventTouchUpInside];
	
    //初始化展示当前时间的月数信息
    NSInteger month =[self getCalendarMonth:[NSDate date]];
    [_btnCalendar setTitle:[NSString stringWithFormat:@"2014年%02d月",month] forState:UIControlStateNormal];
    _collView.contentOffset=CGPointMake((month-1)*ITEM_SIZE_WIDTH, _collView.contentOffset.y);
    rows=month-1;
}

- (void)viewDidAppear:(BOOL)animated{
   
}

#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 12;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.imageMonth.image =[UIImage imageNamed:[NSString stringWithFormat:@"%@%d.jpg",strImagePath,indexPath.row+1]];
    CGRect rect =[self arrFormCellIndex:indexPath];
    if (rect.origin.x>=0) {
        cell.labelToday.hidden=NO;
        cell.labelToday.frame=rect;
        cell.labelToday.layer.masksToBounds=YES;
        cell.labelToday.layer.cornerRadius=rect.size.width/2;
    }else{
        cell.labelToday.hidden=YES;
    }
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
     rows =scrollView.contentOffset.x/ITEM_SIZE_WIDTH;
     [_btnCalendar setTitle:[NSString stringWithFormat:@"2014年%02d月",rows+1] forState:UIControlStateNormal];
}

#pragma mark - 按钮触发的方法
//选取要查看的月数
- (void)btnCalendar:(id)sender{
    NSMutableArray * arr=[[NSMutableArray alloc] init];
    for (int i=1;i<13;i++) {
        NSString * str =[NSString stringWithFormat:@"    %02d月",i];
        [arr addObject:[KxMenuItem menuItem:str
                                      image:nil
                                     target:nil
                                     action:NULL]];
    }
    [KxMenuView setContentViewWidth:100 withChangeablyHeight:true];
    [KxMenu showMenuInView:self.view
                  fromRect:self.btnCalendar.frame
                 menuItems:arr
          initWithdelegate:self
     ];
}

//查看上一个月的日历
- (void)btnLeft:(id)sender{
    if (rows<=0)return;
    rows--;
    [_collView selectItemAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionRight];
    [_btnCalendar setTitle:[NSString stringWithFormat:@"2014年%02d月",rows+1] forState:UIControlStateNormal];
}

//查看下一个月的日历
- (void)btnRight:(id)sender{
    if (rows>=11)return;
    rows++;
    [_collView selectItemAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionLeft];
    [_btnCalendar setTitle:[NSString stringWithFormat:@"2014年%02d月",rows+1] forState:UIControlStateNormal];
}


#pragma mark - KxMenuViewdelegate
//KxMenuView的回调函数
-(void)pathIndexpath:(NSInteger)index{
    rows=index;
    [KxMenu dismissMenu];
    self.collView.contentOffset=CGPointMake(ITEM_SIZE_WIDTH*index, self.collView.contentOffset.y);
    [_btnCalendar setTitle:[NSString stringWithFormat:@"2014年%02d月",index+1] forState:UIControlStateNormal];
}


//返回当前日期的坐标点
- (CGRect)arrFormCellIndex:(NSIndexPath *)index{
    float SizeHeigit =ITEM_SIZE_HEIGHT/6;//定义每一格的高度
    float SizeWidth  =310/7;//定义每一个的宽度
    float offSetSize;//坐标偏差值
    if (iPhone5)offSetSize=13;
    else offSetSize=8;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    //计算出当月排在第一个格子的时间是哪一天（毫秒数）
    NSString * FristTime =[NSString stringWithFormat:@"2014-%02d-01",index.row+1];
    NSTimeInterval timeInteval =[ToolUtils TimeStingWithInterVal:FristTime];
    NSDate *date =[NSDate dateWithTimeIntervalSince1970:timeInteval];
    comps = [calendar components:unitFlags fromDate:date];
    NSUInteger Today =[comps weekday];
    if (Today==1) Today=7;
    else Today-=1;
    timeInteval -=60*60*24*Today;
    
    //计算出当前日期与第一个日期之间所差天数，得出最终坐标
    NSTimeInterval timeIntevalNow =[ToolUtils intervalFromDate:[NSDate date]];
    int count =(timeIntevalNow-timeInteval)/(60*60*24);
    
    if (count>42||count<0) {//如果超出每页所能展示的最大天数则返回“-1”。以此判断为不显示
        return CGRectMake(-1, -1, 0, 0);
    }
    float Y=((count-1)/7)*SizeHeigit+offSetSize;
    float X=((count-1)%7)*SizeWidth+5;
    return CGRectMake(X, Y, SizeWidth, SizeWidth);
}

//获取当天的月数
- (NSUInteger)getCalendarMonth:(NSDate *)date{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    NSUInteger month =[comps month];
    return month;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
