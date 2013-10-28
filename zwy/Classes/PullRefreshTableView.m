//
//  PullRefreshTableView.m
//  ios6NewPull
//
//  Created by Mac on 13-9-13.
//  Copyright (c) 2013年 钟伟迪. All rights reserved.
//

#import "PullRefreshTableView.h"
#define kTextColor [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:1]
#define KTintColor [UIColor grayColor]
#define KAttributedColor [UIColor grayColor]
#define AFTERDELAY 0.0f
#define KLoadHeight 50.0f
#define kPROffsetY 30.f
#define ATTRIBUTRDTITLE @"正在加载数据"
#define ENDTITLE @"没有了哦"
#define UPDATATITLT @"数据刷新中"

@interface PullRefreshTableView ()

@property (strong ,nonatomic)UILabel * labelText;
@property (nonatomic ,strong)UIActivityIndicatorView * activity;

@property (nonatomic ,strong)UIView * UpView;
@property (nonatomic ,strong)UIRefreshControl * refresh;

@end

@implementation PullRefreshTableView{
    BOOL scrolling;
}

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
        self.PDelegate=delegate;
        self.dataSource=delegate;
        self.delegate=delegate;
    }
    return self;
}


- (void)initUI{
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = KTintColor;
    NSString *s = UPDATATITLT;
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:s];
    NSDictionary *refreshAttributes = @{NSForegroundColorAttributeName:KAttributedColor,};
    [attriString setAttributes:refreshAttributes range:NSMakeRange(0, attriString.length)];
    refresh.attributedTitle = attriString;
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refresh=refresh;
    [self addSubview:_refresh];
    
    _isUpdData=NO;
    scrolling=YES;
    self.reachedTheEnd=NO;
    //下拉背景视图
    self.UpView =[[UIView alloc] init];
    if (self.contentSize.height<self.frame.size.height) {
        _UpView.frame=CGRectMake(0, self.frame.size.height, ScreenWidth, 150);

    }else{
        _UpView.frame=CGRectMake(0, self.contentSize.height, ScreenWidth, 150);
    }
    _UpView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_UpView];
    
    //上拉指示灯
    self.activity= [[UIActivityIndicatorView alloc]
                    initWithFrame : CGRectMake(0, 0, 32.0f, 32.0f)];
    [_activity setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
    _activity.color=[UIColor blackColor];
    _activity.center =CGPointMake(40, kPROffsetY);
    [_UpView addSubview:_activity];
    //中心指示灯
    self.centerActivity =[[UIActivityIndicatorView alloc]
                          initWithFrame : CGRectMake(ScreenWidth/2-60, ScreenHeight/2-100, 32.0f, 32.0f)];
    [_centerActivity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    _centerActivity.color=[UIColor grayColor];
    [self addSubview:_centerActivity];
    
    
    //点击加载lable
    UILabel * labelUpdata =[[UILabel alloc] initWithFrame:self.centerActivity.frame];
    CGRect rect =labelUpdata.frame;
    rect.origin.x+=30;
    rect.size.width=150;
    rect.size.height=30;
    labelUpdata.frame=rect;
    labelUpdata.text =@"正在加载....";
    labelUpdata.font =[UIFont boldSystemFontOfSize:14];
    labelUpdata.textColor =[UIColor grayColor];
    self.labelUpdata=labelUpdata;
    [self addSubview:_labelUpdata];
    
    //提示title
    self.labelText =[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    _labelText.center=CGPointMake(self.frame.size.width/2, kPROffsetY);
    _labelText.textAlignment=NSTextAlignmentCenter;
    _labelText.backgroundColor=[UIColor clearColor];
    _labelText.textColor=kTextColor;
    _labelText.font=[UIFont systemFontOfSize:11];
    _labelText.text=ATTRIBUTRDTITLE;
    [self.UpView addSubview:_labelText];
}

//下拉缓冲
-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        scrolling=NO;
        _labelText.text=UPDATATITLT;
        NSString *s = UPDATATITLT;
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:s];
        NSDictionary *refreshAttributes = @{NSForegroundColorAttributeName:KAttributedColor,};
        [attriString setAttributes:refreshAttributes range:NSMakeRange(0, attriString.length)];
        refresh.attributedTitle = attriString;
        [self performSelector:@selector(handleData) withObject:nil afterDelay:AFTERDELAY];
    }
}

//自动更新
-(void)LoadDataBegin{
    scrolling=NO;
    _UpView.hidden=YES;
    _labelUpdata.hidden=NO;
    [_centerActivity startAnimating];
    [self performSelector:@selector(handleData) withObject:nil afterDelay:AFTERDELAY];
}

//下拉更新
-(void)handleData
{
    _labelText.text=UPDATATITLT;
    _reachedTheEnd=YES;
    
    /**///刷新数据
    [_activity stopAnimating];
    [self.PDelegate  upLoadDataWithTableView:self];
    /**/
}

//上拉加载
- (void)handlemoreData{
    [self.PDelegate refreshDataWithTableView:self];

}

//刷新
- (void)reloadDataPull{
    
    if (_centerActivity.isAnimating) {
        [_centerActivity stopAnimating];
    }
    
    [self reloadData];
    [_activity stopAnimating];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM d, h:mm:ss a"];
    NSString *s = [NSString stringWithFormat:@"最后更新时间: %@", [formatter stringFromDate:[NSDate date]]];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:s];
    NSDictionary *refreshAttributes = @{NSForegroundColorAttributeName:KAttributedColor,};
    [attriString setAttributes:refreshAttributes range:NSMakeRange(0, attriString.length)];
    self.refresh.attributedTitle = attriString;
    
    scrolling=YES;
    
    //根据数据内容判断是否可以下拉
    if (self.contentSize.height<self.frame.size.height) {
        self.UpView.frame=CGRectMake(0, self.frame.size.height, ScreenWidth, 150);
        _UpView.hidden=YES;
        _reachedTheEnd=NO;
    }else{
        self.UpView.frame=CGRectMake(0, self.contentSize.height, ScreenWidth, 150);
        _labelText.hidden=NO;
        if (_UpView.hidden) {
            _UpView.hidden=NO;
        }
    }
    

    if (_isUpdData) {
       _labelUpdata.text =@"加载失败,点我重新加载";
    }else{
        _labelUpdata.hidden=YES;
    }
    
    if (_reachedTheEnd) {
        _labelText.text=ATTRIBUTRDTITLE;
    }else{
        _labelText.text=ENDTITLE;
    }
    
    
    [self.refresh endRefreshing];
}

#pragma mark - ScrollDelegate
-(void)scrollViewDidPullScroll:(UIScrollView *)scrollView{
    float ScrollAllHeight =scrollView.contentOffset.y+scrollView.frame.size.height;
    float tabviewSizeHeight =scrollView.contentSize.height;
    if (ScrollAllHeight>tabviewSizeHeight && _reachedTheEnd&&scrolling) {
        [_activity startAnimating];
        if (_reachedTheEnd) {
            CGSize Size =self.contentSize;
            Size.height+=KLoadHeight;
            self.contentSize=Size;
        }
        [self performSelector:@selector(handlemoreData) withObject:nil afterDelay:AFTERDELAY];
        scrolling=NO;
    }
}

@end
