//
//  ScheduleController.m
//  zwy
//
//  Created by cqsxit on 13-11-18.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "ScheduleController.h"
#import "ScheduleCell.h"
#import "DetailTextView.h"
@implementation ScheduleController{

    tableViewScheduleType tableView_Type;
    NSString *notificationNameAll;
    NSString *notificationNameWork;
    NSString *notificationNameLife;
    NSString *notificationNameBirthday;
    NSString *notificationNameHoliday;
    
    /*请求的页数*/
    int pagesAll;
    int pagesWork;
    int pageLife;
    int pageBirthday;
    int pageHoliday;
    
    /*是否是第一次请求数据*/
    BOOL isAllFirstLoad;
    BOOL isWorkFirstLoad;
    BOOL isLifeFirstLoad;
    BOOL isBirthdayFirstLoad;
    BOOL isHolidayFirstLoad;
    
    /*是否下拉刷新*/
    BOOL isPullDownAll;
    BOOL isPullDownWork;
    BOOL isPullDownLife;
    BOOL isPullDownBirthday;
    BOOL isPullDownHoliday;
}

- (id)init{
    self=[super init];
    if (self) {
        pagesAll=1;
        pagesWork=1;
        pageLife=1;
        pageBirthday=1;
        pageHoliday=1;
        
        isAllFirstLoad=YES;
        isWorkFirstLoad=YES;
        isLifeFirstLoad=YES;
        isBirthdayFirstLoad=YES;
        isHolidayFirstLoad=YES;
        
        tableView_Type =tableView_ScheduleType_All;
        _arrAll =[[NSMutableArray alloc] init];
        _arrWork=[[NSMutableArray alloc] init];
        _arrLife =[[NSMutableArray alloc] init];
        _arrBirthday=[[NSMutableArray alloc] init];
        _arrholiday =[[NSMutableArray alloc] init];
      
        notificationNameAll=@"notificationNameAll";
        notificationNameWork=@"notificationNameWork";
        notificationNameLife=@"notificationNameLife";
        notificationNameBirthday=@"notificationNameBirthday";
        notificationNameHoliday=@"notificationNameHoliday";
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameAllData:)
                                                    name:notificationNameAll
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameWorkData:)
                                                    name:notificationNameWork
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameLifeData:)
                                                    name:notificationNameLife
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameBirthdayData:)
                                                    name:notificationNameBirthday
                                                  object:self];
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(notificationNameHolidayData:)
                                                    name:notificationNameHoliday
                                                  object:self];
        
    }
    return self;
}

/*添加日程提醒*/
- (void)btnAddSchedule{
    [_schedView performSegueWithIdentifier:@"ScheduleToNewsView" sender:nil];
}


#pragma mark -接受数据信息
//所有日程
- (void)notificationNameAllData:(NSNotification *)notification{
    if (isPullDownAll) {
        isPullDownAll=NO;
    }
    
    if (_arrAll.count!=0) {
        _schedView.tableViewAll.separatorStyle=YES;
    }
    [_schedView.tableViewAll reloadDataPull];
}

//工作日程
- (void)notificationNameWorkData:(NSNotification *)notification{
    if (isPullDownWork) {
        
    }
    
    if (_arrWork.count!=0) {
        _schedView.tableViewWork.separatorStyle=YES;
    }
    [_schedView.tableViewWork reloadDataPull];
}

//生活日程
- (void)notificationNameLifeData:(NSNotification *)notification{
    if (isPullDownLife) {
        
    }
    
    if (_arrLife.count!=0) {
        _schedView.tableViewLife.separatorStyle=YES;
    }
    [_schedView.tableViewLife reloadDataPull];
}

//生日日程
- (void)notificationNameBirthdayData:(NSNotification *)notification{
    if (isPullDownBirthday) {
        
    }
    
    if (_arrBirthday.count!=0) {
        _schedView.tableViewBirthday.separatorStyle=YES;
    }
    [_schedView.tableViewBirthday reloadDataPull];
}

//节日日程
- (void)notificationNameHolidayData:(NSNotification *)notification{
    if (isPullDownHoliday) {
        
    }
    
    if (_arrholiday.count!=0) {
        _schedView.tableViewHoliday.separatorStyle=YES;
    }
    [_schedView.tableViewHoliday reloadDataPull];
}

#pragma mark - 选择卡按钮
-(void)segmentAction:(UISegmentedControl *)Seg{
    switch (Seg.selectedSegmentIndex) {
        case 0:{
            tableView_Type=tableView_ScheduleType_All;
            _schedView.tableViewAll.hidden=NO;
            _schedView.tableViewWork.hidden=YES;
            _schedView.tableViewLife.hidden=YES;
            _schedView.tableViewBirthday.hidden=YES;
            _schedView.tableViewHoliday.hidden=YES;
        }
            break;
            
        case 1:{
          tableView_Type=tableView_ScheduleType_Work;
            _schedView.tableViewAll.hidden=YES;
            _schedView.tableViewWork.hidden=NO;
            _schedView.tableViewLife.hidden=YES;
            _schedView.tableViewBirthday.hidden=YES;
            _schedView.tableViewHoliday.hidden=YES;
        }
            break;
            
        case 2:{
            tableView_Type=tableView_ScheduleType_Life;
            _schedView.tableViewAll.hidden=YES;
            _schedView.tableViewWork.hidden=YES;
            _schedView.tableViewLife.hidden=NO;
            _schedView.tableViewBirthday.hidden=YES;
            _schedView.tableViewHoliday.hidden=YES;
        }
            break;
            
        case 3:{
            tableView_Type=tableView_ScheduleType_Birthday;
            _schedView.tableViewAll.hidden=YES;
            _schedView.tableViewWork.hidden=YES;
            _schedView.tableViewLife.hidden=YES;
            _schedView.tableViewBirthday.hidden=NO;
            _schedView.tableViewHoliday.hidden=YES;
        }
            break;
            
        case 4:{
            tableView_Type=tableView_ScheduleType_Holiday;
            _schedView.tableViewAll.hidden=YES;
            _schedView.tableViewWork.hidden=YES;
            _schedView.tableViewLife.hidden=YES;
            _schedView.tableViewBirthday.hidden=YES;
            _schedView.tableViewHoliday.hidden=NO;
        }
            break;
            
        default:
            
            break;

    }
    [self loadDataTableView];/*选择卡刷新数据*/
}

/*选择卡刷新数据*/
- (void)loadDataTableView{
    if (!_schedView.tableViewAll.hidden) {
        /*第一次刷新数据(全部)*/
        if (_arrAll.count==0&&isAllFirstLoad) {
            [_schedView.tableViewAll LoadDataBegin];
        }
        
    }else if(!_schedView.tableViewWork.hidden){
        /*第一次刷新数据(工作)*/
        if (_arrWork.count==0&&isWorkFirstLoad) {
             [_schedView.tableViewWork LoadDataBegin];
        }
        
    }else if (!_schedView.tableViewLife.hidden){
        /*第一次刷新数据(生活)*/
        if (_arrLife.count==0&&isLifeFirstLoad) {
             [_schedView.tableViewLife LoadDataBegin];
        }
        
    }else if (!_schedView.tableViewBirthday.hidden){
        /*第一次刷新数据(生日)*/
        if (_arrBirthday.count==0&&isBirthdayFirstLoad) {
             [_schedView.tableViewBirthday LoadDataBegin];
        }
        
    }else if (!_schedView.tableViewHoliday.hidden){
        /*第一次刷新数据(节日)*/
        if (_arrholiday.count==0&&isHolidayFirstLoad){
             [_schedView.tableViewHoliday LoadDataBegin];
        }
        
    }
}

#pragma mark -UItableviewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger ret=0;
    switch (tableView.tag) {
        case 0:{
            ret=_arrAll.count+10;
        }
            break;
            
        case 1:{
            ret=_arrWork.count;
        }
            break;
            
        case 2:{
            ret=_arrLife.count;
        }
            break;
            
        case 3:{
            ret=_arrBirthday.count;
        }
            break;
            
        case 4:{
            ret=_arrholiday.count;
        }
            break;
        default:
            
            break;
    }
    return ret;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell =@"cell";
    ScheduleCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[ScheduleCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:strCell];
    }
    switch (tableView.tag) {
        case 0:{
            cell.labelTime.text=@"2013-03-06";
            cell.labelTitle.text=@"激素上网";
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:@"123"];
        }
            break;
            
        case 1:{
            cell.labelTime.text=@"2013-03-06";
            cell.labelTitle.text=@"激素上网";
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:@"123"];
        }
            break;
            
        case 2:{
            cell.labelTime.text=@"2013-03-06";
            cell.labelTitle.text=@"激素上网";
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:@"123"];
        }
            break;
            
        case 3:{
            cell.labelTime.text=@"2013-03-06";
            cell.labelTitle.text=@"激素上网";
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:@"123"];
        }
            break;
            
        case 4:{
            cell.labelTime.text=@"2013-03-06";
            cell.labelTitle.text=@"激素上网";
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:@"123"];
        }
            break;
        default:
            
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.schedView performSegueWithIdentifier:@"ScheduleToHolidayView" sender:nil];
    switch (tableView.tag) {
        case 0:{

        }
            break;
            
        case 1:{

        }
            break;
            
        case 2:{

        }
            break;
            
        case 3:{

        }
            break;
            
        case 4:{

        }
            break;
        default:
            
            break;
    }
}

/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    switch (tableView.tag) {
        case 0:{
            pagesAll=1;
        }
            break;
            
        case 1:{
            pagesWork=1;
        }
            break;
            
        case 2:{
            pageLife=1;
        }
            break;
            
        case 3:{
             pageBirthday=1;
        }
            break;
            
        case 4:{
           pageHoliday=1;
        }
            break;
        default:
            
            break;
    }

}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    switch (tableView.tag) {
        case 0:{
            pagesAll++;
        }
            break;
            
        case 1:{
            pagesWork++;
        }
            break;
            
        case 2:{
            pageLife++;
        }
            break;
            
        case 3:{
            pageBirthday++;
        }
            break;
            
        case 4:{
            pageHoliday++;
        }
            break;
        default:
            
            break;
    }

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.tag==0){
        [self.schedView.tableViewAll scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==1){
        [self.schedView.tableViewWork scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==2){
        [self.schedView.tableViewLife scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==3){
        [self.schedView.tableViewBirthday scrollViewDidPullScroll:scrollView];
    }else if(scrollView.tag==4){
        [self.schedView.tableViewHoliday scrollViewDidPullScroll:scrollView];
    }
}

@end
