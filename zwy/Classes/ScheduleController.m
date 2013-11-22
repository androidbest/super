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
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewAll reloadDataPull];
        return;
    }
    
    warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownAll) {
        isPullDownAll=NO;
        pagesAll=1;
        [_arrAll removeAllObjects];
    }
    if (info.warningList&&info.warningList.count>0)[_arrAll addObjectsFromArray:info.warningList];
    if (_arrAll.count!=0) {
        _schedView.tableViewAll.separatorStyle=YES;
    }else{
        [ToolUtils alertInfo:@"暂无数据"];
    }
    
    if (_arrAll.count>=info.AllCount) {
        _schedView.tableViewAll.reachedTheEnd=NO;
    }else {
    _schedView.tableViewAll.reachedTheEnd=YES;
    }
    [_schedView.tableViewAll reloadDataPull];
}

//工作日程
- (void)notificationNameWorkData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewWork reloadDataPull];
        return;
    }
    
    warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownWork) {
        isPullDownWork=NO;
        pagesWork=1;
        [_arrWork removeAllObjects];
    }
    if (info.warningList&&info.warningList.count>0)[_arrWork addObjectsFromArray:info.warningList];
    if (_arrWork.count!=0) {
        _schedView.tableViewWork.separatorStyle=YES;
    }else{
        [ToolUtils alertInfo:@"暂无数据"];
    }
    
    if (_arrWork.count>=info.AllCount) {
        _schedView.tableViewWork.reachedTheEnd=NO;
    }else {
        _schedView.tableViewWork.reachedTheEnd=YES;
    }
    
    [_schedView.tableViewWork reloadDataPull];
}

//生活日程
- (void)notificationNameLifeData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewLife reloadDataPull];
        return;
    }
    
    warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownLife) {
        isPullDownLife=NO;
        pageLife=1;
        [_arrLife removeAllObjects];
    }
    
    if (info.warningList&&info.warningList.count>0)[_arrLife addObjectsFromArray:info.warningList];
    if (_arrLife.count!=0) {
        _schedView.tableViewLife.separatorStyle=YES;
    }else{
        [ToolUtils alertInfo:@"暂无数据"];
    }
    
    if (_arrLife.count>=info.AllCount) {
        _schedView.tableViewLife.reachedTheEnd=NO;
    }else {
        _schedView.tableViewLife.reachedTheEnd=YES;
    }
    [_schedView.tableViewLife reloadDataPull];
}

//生日日程
- (void)notificationNameBirthdayData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewBirthday reloadDataPull];
        return;
    }
    
    warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownBirthday) {
        isPullDownBirthday=NO;
        pageBirthday=1;
        [_arrBirthday removeAllObjects];
    }
    
    if (info.warningList&&info.warningList.count>0)[_arrBirthday addObjectsFromArray:info.warningList];
    if (_arrBirthday.count!=0) {
        _schedView.tableViewBirthday.separatorStyle=YES;
    }else{
        [ToolUtils alertInfo:@"暂无数据"];
    }
    
    if (_arrBirthday.count>=info.AllCount) {
        _schedView.tableViewBirthday.reachedTheEnd=NO;
    }else {
        _schedView.tableViewBirthday.reachedTheEnd=YES;
    }
    [_schedView.tableViewBirthday reloadDataPull];
}

//节日日程
- (void)notificationNameHolidayData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (!dic)
    {
        [ToolUtils alertInfo:@"网络错误"];
        [_schedView.tableViewHoliday reloadDataPull];
        return;
    }
    
     warningInfo *info =[AnalysisData warningList:dic];
    
    if (isPullDownHoliday) {
        isPullDownHoliday=NO;
        pageHoliday=1;
        [_arrholiday removeAllObjects];
    }
    
     if (info.warningList&&info.warningList.count>0)[_arrholiday addObjectsFromArray:info.warningList];
    if (_arrholiday.count!=0) {
        _schedView.tableViewHoliday.separatorStyle=YES;
    }else{
        [ToolUtils alertInfo:@"暂无数据"];
    }

    
    if (_arrholiday.count>=info.AllCount) {
        _schedView.tableViewHoliday.reachedTheEnd=NO;
    }else {
        _schedView.tableViewHoliday.reachedTheEnd=YES;
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
            isAllFirstLoad=NO;
        }
        
    }else if(!_schedView.tableViewWork.hidden){
        /*第一次刷新数据(工作)*/
        if (_arrWork.count==0&&isWorkFirstLoad) {
             [_schedView.tableViewWork LoadDataBegin];
            isWorkFirstLoad=NO;
        }
        
    }else if (!_schedView.tableViewLife.hidden){
        /*第一次刷新数据(生活)*/
        if (_arrLife.count==0&&isLifeFirstLoad) {
             [_schedView.tableViewLife LoadDataBegin];
            isLifeFirstLoad=NO;
        }
        
    }else if (!_schedView.tableViewBirthday.hidden){
        /*第一次刷新数据(生日)*/
        if (_arrBirthday.count==0&&isBirthdayFirstLoad) {
             [_schedView.tableViewBirthday LoadDataBegin];
            isBirthdayFirstLoad=NO;
        }
        
    }else if (!_schedView.tableViewHoliday.hidden){
        /*第一次刷新数据(节日)*/
        if (_arrholiday.count==0&&isHolidayFirstLoad){
             [_schedView.tableViewHoliday LoadDataBegin];
            isHolidayFirstLoad=NO;
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
            ret=_arrAll.count;
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
            /***************************/
            warningDataInfo * info =_arrAll[indexPath.row];
            NSString *Title;
            if ([info.warningType isEqualToString:@"2"]){
                Title =[info.content stringByAppendingString:@" 的生日"];
                cell.labelTitle.text=nil;
                cell.labelTitle.attributedText=[DetailTextView setCellTitleAttributedString:Title];
            }
            else {
                Title=info.content;
                cell.labelTitle.text=Title;
            }
            cell.labelTime.text = info.warningDate;
            cell.labelDays.attributedText =[DetailTextView setCellTimeAttributedString:info.remainTime];
            /***************************/
        }
            break;
            
        case 1:{
            warningDataInfo *info =_arrWork[indexPath.row];
            cell.labelTitle.text=info.content;
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
            
        case 2:{
            warningDataInfo *info =_arrLife[indexPath.row];
            cell.labelTitle.text=info.content;
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
            
        case 3:{
            warningDataInfo *info =_arrBirthday[indexPath.row];
            NSString * Title =[info.content stringByAppendingString:@" 的生日"];
            cell.labelTitle.attributedText=[DetailTextView setCellTitleAttributedString:Title];
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
            
        case 4:{
            warningDataInfo *info =_arrholiday[indexPath.row];
            cell.labelTitle.text=info.content;
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
        default:
            
            break;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
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
            isPullDownAll=YES;
            [packageData getWarningDatas:self pages:pagesAll Type:10000 SELType:notificationNameAll];
        }
            break;
            
        case 1:{
            pagesWork=1;
            isPullDownWork=YES;
            [packageData getWarningDatas:self pages:pagesWork Type:0 SELType:notificationNameWork];
        }
            break;
            
        case 2:{
            pageLife=1;
            isPullDownLife=YES;
            [packageData getWarningDatas:self pages:pageLife Type:1 SELType:notificationNameLife];
        }
            break;
            
        case 3:{
             pageBirthday=1;
            isPullDownBirthday=YES;
             [packageData getWarningDatas:self pages:pageBirthday Type:2 SELType:notificationNameBirthday];
        }
            break;
            
        case 4:{
           pageHoliday=1;
            isPullDownHoliday=YES;
           [packageData getWarningDatas:self pages:pageHoliday Type:3 SELType:notificationNameHoliday];
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
            [packageData getWarningDatas:self pages:pagesAll Type:10000 SELType:notificationNameAll];
        }
            break;
            
        case 1:{
            pagesWork++;
            [packageData getWarningDatas:self pages:pagesWork Type:0 SELType:notificationNameWork];
        }
            break;
            
        case 2:{
            pageLife++;
            [packageData getWarningDatas:self pages:pageLife Type:1 SELType:notificationNameLife];
        }
            break;
            
        case 3:{
            pageBirthday++;
            [packageData getWarningDatas:self pages:pageBirthday Type:2 SELType:notificationNameBirthday];
        }
            break;
            
        case 4:{
            pageHoliday++;
            [packageData getWarningDatas:self pages:pageHoliday Type:3 SELType:notificationNameHoliday];
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
