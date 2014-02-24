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
#import "WorkView.h"
#import "HolidayView.h"
#import "NewsScheduleView.h"
#import "UpdataDate.h"
#import "NewsScheduleController.h"

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
    
    /*是否有置顶信息*/
    BOOL isFirst;
    
    /*第一次创建本地通知*/
    BOOL isAllInit;
    BOOL isWorkInit;
    BOOL isLifeInit;
    BOOL isBirthdayInit;
    BOOL isHolidayInit;
    
   
    
    NSDictionary *dicDcomentFirst;
    NSString *InitDaysTime;
    NSString *removeWarning;/*删除日程通告名*/
    warningDataInfo *warningDataFirstInfo;
}

- (id)init{
    self=[super init];
    if (self) {
        pagesAll=1;
        pagesWork=1;
        pageLife=1;
        pageBirthday=1;
        pageHoliday=1;
        
        isAllInit=YES;
        isWorkInit=YES;
        isLifeInit=YES;
        isBirthdayInit=YES;
        isHolidayInit=YES;
        
        isAllFirstLoad=YES;
        isWorkFirstLoad=YES;
        isLifeFirstLoad=YES;
        isBirthdayFirstLoad=YES;
        isHolidayFirstLoad=YES;
        
        tableView_Type =tableView_ScheduleType_All;
        
        InitDaysTime=@" 15:45";
        
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
        removeWarning=@"removeWarning";
        
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
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(removeWarningData:)
                                                    name:removeWarning
                                                  object:self];
    }
    return self;
}

- (void)initWithData{
    NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];
    isFirst=[[NSFileManager defaultManager] fileExistsAtPath:strPath];
    if (isFirst) {
        NSDictionary *dic =[[NSDictionary alloc] initWithContentsOfFile:strPath];
        dicDcomentFirst=[NSDictionary dictionaryWithDictionary:dic];
    }else{
        dicDcomentFirst=nil;
        dicDcomentFirst =[NSDictionary dictionary];
     [self getFirstSchedule];
    }
}

/*设置置顶提醒*/
- (void)getFirstSchedule{
    if (_arrAll.count==0) {
        _schedView.labelName.text=@"数据加载";
        return;
    }
    warningDataInfo * info =_arrAll[0];
    NSString *Title;
    if ([info.warningType isEqualToString:@"2"]&&![info.isUserHandAdd isEqualToString:@"0"]){
        Title =[info.content stringByAppendingString:@" 的生日"];
        _schedView.labelName.text=Title;
    }
    else {
        Title=info.content;
        _schedView.labelName.text=Title;
    }
     _schedView.labelBirthday.text = info.warningDate;
    _schedView.labelDays.attributedText =[DetailTextView setDateAttributedString:info.remainTime];
    warningDataFirstInfo=info;
}

/*同步置顶信息*/
- (void)updateFirstSchedule:(warningDataInfo *)info{
     NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];//设置地址
    NSMutableDictionary *dicFirst=[[NSMutableDictionary alloc] init];
    [dicFirst setObject:info.content forKey:@"name"];/*提醒标题*/
    [dicFirst setObject:info.warningDate forKey:@"date"];//时间
    [dicFirst setObject:info.warningID forKey:@"ID"];//日程ID
    [dicFirst  setObject:info.RequestType forKey:@"reqeatType"];//重复类型
    [dicFirst setObject:info.warningType forKey:@"ScheduleType"];//日程类型
    if(info.isUserHandAdd)[dicFirst setObject:info.isUserHandAdd forKey:@"dataType"];//是否为手动添加
    
    [dicFirst writeToFile:strPath atomically:NO];//写入沙盒
    
    NSString *Title;
    if ([info.warningType isEqualToString:@"2"]&&![info.isUserHandAdd isEqualToString:@"0"]){
        Title =[info.content stringByAppendingString:@" 的生日"];
        _schedView.labelName.text=Title;
    }
    else {
        Title=info.content;
        _schedView.labelName.text=Title;
    }
    _schedView.labelBirthday.text = info.warningDate;
    _schedView.labelDays.attributedText =[DetailTextView setDateAttributedString:info.remainTime];
    warningDataFirstInfo=info;
}

#pragma mark - 按钮
/*添加日程提醒*/
- (void)btnAddSchedule{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    NewsScheduleView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"NewsScheduleView"];
    [self.schedView presentViewController:detaView animated:YES completion:nil];
    detaView.btnCancel.hidden=YES;
    detaView.schedView=self.schedView;
    detaView.newsScheduleDelegate=self;
}

/*push到详细页面*/
- (void)PushMassTextView{
    if ([warningDataFirstInfo.warningType isEqualToString:@"0"]||[warningDataFirstInfo.warningType isEqualToString:@"1"]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
        [self.schedView.navigationController pushViewController:detaView animated:YES];
        detaView.info=warningDataFirstInfo;
        detaView.WorkViewDelegate=self;
    }else{
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        HolidayView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HolidayView"];
        [self.schedView.navigationController pushViewController:detaView animated:YES];
        detaView.info =warningDataFirstInfo;
        detaView.HolidayViewDelegate=self;
    }
}

#pragma mark - 更新数据(newsScheduleDelegate,HolidayViewDelegate,WorkViewDelegate)
- (void)upDataScheduleList:(int)TableViewType{

    self.HUD = [[MBProgressHUD alloc] initWithView:self.schedView.navigationController.view];
	[self.schedView.navigationController.view addSubview:self.HUD];
	self.HUD.labelText = @"更新日程";
	// Set determinate bar mode
	self.HUD.delegate = self;
    [self.HUD show:YES];
    
    
    NSString *strPath =[NSString stringWithFormat:@"%@/%@/%@/%@.plist",DocumentsDirectory,user.msisdn,user.eccode,Warning_Frist];//设置地址
    BOOL isboolFirst=[[NSFileManager defaultManager] fileExistsAtPath:strPath];
    
    if (!isboolFirst) {
        isFirst=NO;
        dicDcomentFirst=nil;
        dicDcomentFirst=[NSDictionary dictionary];
    }else {
        isFirst=YES;
        dicDcomentFirst =[NSDictionary dictionaryWithContentsOfFile:strPath];
    }
    
    pagesAll=1;
    isPullDownAll=YES;
    [packageData getWarningDatas:self pages:pagesAll Type:10000 SELType:notificationNameAll];
    switch (TableViewType) {
        case 0:{
            
            pagesWork=1;
            isPullDownWork=YES;/*重新刷新数据*/
            isWorkInit=YES;/*更新本地通知*/
            [packageData getWarningDatas:self pages:pagesWork Type:0 SELType:notificationNameWork];
        }
            break;
            
        case 1:{
            pageLife=1;
            isPullDownLife=YES;
            isLifeInit=YES;
            [packageData getWarningDatas:self pages:pageLife Type:1 SELType:notificationNameLife];
        }
            break;
            
        case 2:{
            pageBirthday=1;
            isPullDownBirthday=YES;
            isBirthdayInit=YES;
            [packageData getWarningDatas:self pages:pageBirthday Type:2 SELType:notificationNameBirthday];
        }
            break;
            
        case 3:{
            pageHoliday=1;
            isPullDownHoliday=YES;
            isHolidayInit=YES;
            [packageData getWarningDatas:self pages:pageHoliday Type:3 SELType:notificationNameHoliday];
        }
            break;
        default:
            break;
    }
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
    if (info.warningList&&info.warningList.count>0)
    [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_All];
    
    if (_arrAll.count!=0) {
        _schedView.tableViewAll.separatorStyle=YES;
        _schedView.imageFirst.userInteractionEnabled=YES;
    }else{
        [ToolUtils alertInfo:@"暂无数据"];
    }

    _schedView.tableViewAll.reachedTheEnd=NO;
    [_schedView.tableViewAll reloadDataPull];
    
    if (!isFirst) {/*设置置顶内容*/
        [self getFirstSchedule];
    }
    
    /*创建通告*/
    if (isAllInit)[self addAllLocalNotification];
    
    if (self.HUD)[self.HUD hide:YES afterDelay:1];
   
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
    if (info.warningList&&info.warningList.count>0)
        [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_Work];
        
    if (_arrWork.count!=0) {
        _schedView.tableViewWork.separatorStyle=YES;
    }else{
//        [ToolUtils alertInfo:@"暂无数据"];
    }
    
//    if (_arrWork.count>=info.AllCount) {
        _schedView.tableViewWork.reachedTheEnd=NO;
//    }else {
//        _schedView.tableViewWork.reachedTheEnd=YES;
//    }
    
    [_schedView.tableViewWork reloadDataPull];
    
    if (isWorkInit){/*创建通告*/
        [self addWarningLocalNotification:_arrWork initWithOrBool:&isWorkInit];
    }
    
     if (self.HUD)[self.HUD hide:YES afterDelay:1];
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
    
    if (info.warningList&&info.warningList.count>0)
        [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_Life];
        
    if (_arrLife.count!=0) {
        _schedView.tableViewLife.separatorStyle=YES;
    }else{
//        [ToolUtils alertInfo:@"暂无数据"];
    }
    
//   if (_arrLife.count>=info.AllCount) {
        _schedView.tableViewLife.reachedTheEnd=NO;
//    }else {
//        _schedView.tableViewLife.reachedTheEnd=YES;
//    }
    [_schedView.tableViewLife reloadDataPull];
    
    if (isLifeInit) {/*创建通告*/
        [self addWarningLocalNotification:_arrLife initWithOrBool:&isLifeInit];
    }
    
     if (self.HUD)[self.HUD hide:YES afterDelay:1];
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
    
    //按时间重新排列数据 remainTime
    if (info.warningList&&info.warningList.count>0)
         [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_Birthday];
        
    if (_arrBirthday.count!=0) {
        _schedView.tableViewBirthday.separatorStyle=YES;
    }else{
    // [ToolUtils alertInfo:@"暂无数据"];
    }
    
//    if (_arrBirthday.count>=info.AllCount) {
        _schedView.tableViewBirthday.reachedTheEnd=NO;
//    }else {
//        _schedView.tableViewBirthday.reachedTheEnd=YES;
//    }
    [_schedView.tableViewBirthday reloadDataPull];
    
    if (isBirthdayInit) {/*创建通告*/
        [self mergerWarningTypeToBirthday:_arrBirthday isInit:&isBirthdayInit];
    }
    
     if (self.HUD)[self.HUD hide:YES afterDelay:1];
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
    
     if (info.warningList&&info.warningList.count>0)
         [self updateTableViewDateMinToMax:info.warningList tableViewType:tableView_ScheduleType_Holiday];
         
    if (_arrholiday.count!=0) {
        _schedView.tableViewHoliday.separatorStyle=YES;
    }else{
//        [ToolUtils alertInfo:@"暂无数据"];
    }

    
//    if (_arrholiday.count>=info.AllCount) {
        _schedView.tableViewHoliday.reachedTheEnd=NO;
//    }else {
//        _schedView.tableViewHoliday.reachedTheEnd=YES;
//    }
    [_schedView.tableViewHoliday reloadDataPull];
    
    if (isHolidayInit){/*创建通告*/
        [self addWarningLocalNotification:_arrholiday initWithOrBool:&isHolidayInit];
    }
    
     if (self.HUD)[self.HUD hide:YES afterDelay:1];
}


/*删除回调*/
- (void)removeWarningData:(NSNotification *)notification{
    NSDictionary *dic =[notification userInfo];
    RespInfo *info =[AnalysisData ReTurnInfo:dic];

    if ([info.respCode isEqualToString:@"1"]) {
        [self showHUDText:@"网络错误,删除失败" showTime:1];
    }
}


//按时间重新排列数据 remainTime
- (void)updateTableViewDateMinToMax:(NSMutableArray *)array tableViewType:(tableViewScheduleType)tableViewType{
    NSMutableArray *arrInfo =[NSMutableArray arrayWithArray:[self changeArray:array orderWithKey:@"remainTimeInt" ascending:YES]];
    
    /***************************/
    for (warningDataInfo * info  in arrInfo) {
        if ([dicDcomentFirst[@"ID"] isEqualToString:info.warningID])[self updateFirstSchedule:info];/*同步置顶信息*/
    }
   
    
    switch (tableViewType) {
        case tableView_ScheduleType_All:{
            [_arrAll addObjectsFromArray:arrInfo];
        }
            break;
        case tableView_ScheduleType_Work:{
            [_arrWork addObjectsFromArray:arrInfo];
        }
            break;
        case tableView_ScheduleType_Life:{
            [_arrLife addObjectsFromArray:arrInfo];
        }
            break;
        case tableView_ScheduleType_Birthday:{
            [_arrBirthday addObjectsFromArray:arrInfo];
        }
            break;
        case tableView_ScheduleType_Holiday:{
            [_arrholiday addObjectsFromArray:arrInfo];
        }
            break;
        default:
            break;
    }
}

/*日程排序*/
- (NSArray *) changeArray:(NSMutableArray *)dicArray orderWithKey:(NSString *)key ascending:(BOOL)yesOrNo{
    NSMutableArray *arrBefore;//未过期日程array
    NSMutableArray *arrAfter;//已过期日程array
    NSMutableArray *arrAll;//排序完成的日程array
    
    //设置排序方式key
    NSSortDescriptor *distanceDescriptor = [[NSSortDescriptor alloc] initWithKey:key ascending:yesOrNo];
    NSArray *descriptors = [NSArray arrayWithObjects:distanceDescriptor,nil];
    
    //未过期日程排序
    NSPredicate *thePredicate = [NSPredicate predicateWithFormat:@"SELF.remainTimeInt >= 0"];
    arrBefore =[NSMutableArray arrayWithArray:[dicArray filteredArrayUsingPredicate:thePredicate]];
    [arrBefore sortUsingDescriptors:descriptors];
    
    //已过期日程排序
    arrAfter=dicArray;
    [arrAfter removeObjectsInArray:arrBefore];
    [arrAfter sortUsingDescriptors:descriptors];
    
    arrAll =[NSMutableArray new];
    [arrAll addObjectsFromArray:arrBefore];
    [arrAll addObjectsFromArray:arrAfter];
    
    
    return arrAll;
    
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
        if (_arrLife.count==0&&isLifeFirstLoad){
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
    DAContextMenuCell * cell =[tableView dequeueReusableCellWithIdentifier:strCell];
    if (!cell) {
        cell = [[DAContextMenuCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                   reuseIdentifier:strCell];
    }
    warningDataInfo *info;
    
    switch (tableView.tag) {
        case 0:{
            /***************************/
            cell.delegate=self.schedView.tableViewAll;
            info =_arrAll[indexPath.row];
            NSString *Title;
            if ([info.warningType isEqualToString:@"2"]&&![info.isUserHandAdd isEqualToString:@"0"]){
                Title =[info.content stringByAppendingString:@" 的生日"];
                cell.labelTitle.text=nil;
                cell.labelTitle.attributedText=[DetailTextView setCellTitleAttributedString:Title];
                cell.labelTime.text = info.brithdayDate;
            }
            else {
                Title=info.content;
                cell.labelTitle.text=Title;
                cell.labelTime.text = info.warningDate;
            }
            cell.labelDays.attributedText =[DetailTextView setCellTimeAttributedString:info.remainTime];
            /***************************/
        }
            break;
            
        case 1:
        {   cell.delegate=self.schedView.tableViewWork;
            info =_arrWork[indexPath.row];
            cell.labelTitle.text=info.content;
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
            
        case 2:{
            cell.delegate=self.schedView.tableViewLife;
            info =_arrLife[indexPath.row];
            cell.labelTitle.text=info.content;
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
            
        case 3:{
            cell.delegate=self.schedView.tableViewBirthday;
            info =_arrBirthday[indexPath.row];
            /*如果为手动添加标题后面不自动添加“的生日“字段*/
            if ([info.isUserHandAdd isEqualToString:@"0"]) {
                cell.labelTitle.text=info.content;
            }else{
                NSString * Title =[info.content stringByAppendingString:@" 的生日"];
                cell.labelTitle.text=nil;
                cell.labelTitle.attributedText=[DetailTextView setCellTitleAttributedString:Title];
                
            }
            cell.labelTime.text=info.brithdayDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
            
        case 4:{
            cell.delegate=self.schedView.tableViewHoliday;
            info =_arrholiday[indexPath.row];
            cell.labelTitle.text=info.content;
            cell.labelTime.text=info.warningDate;
            cell.labelDays.attributedText=[DetailTextView setCellTimeAttributedString:info.remainTime];
        }
            break;
        default:
            
            break;
    }
    /*同步置顶信息*/
    if ([dicDcomentFirst[@"ID"] isEqualToString:info.warningID]){
        cell.moreOptionsButtonTitle=@"取消置顶";
    }else {
         cell.moreOptionsButtonTitle=@"置顶";
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (tableView.tag) {
        case 0:{
        warningDataInfo * info =_arrAll[indexPath.row];
            if ([info.warningType isEqualToString:@"0"]||[info.warningType isEqualToString:@"1"]||([info.isUserHandAdd isEqualToString:@"0"]&&[info.warningType isEqualToString:@"3"])) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
                [self.schedView.navigationController pushViewController:detaView animated:YES];
                detaView.info=info;
                detaView.WorkViewDelegate=self;
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                HolidayView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HolidayView"];
                [self.schedView.navigationController pushViewController:detaView animated:YES];
                detaView.info =info;
                detaView.HolidayViewDelegate=self;
            }
        }
            break;
            
        case 1:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
            [self.schedView.navigationController pushViewController:detaView animated:YES];
            detaView.info=_arrWork[indexPath.row];
            detaView.WorkViewDelegate=self;
        }
            break;
            
        case 2:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
            [self.schedView.navigationController pushViewController:detaView animated:YES];
            detaView.info=_arrLife[indexPath.row];
            detaView.WorkViewDelegate=self;
        }
            break;
            
        case 3:{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
            HolidayView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HolidayView"];
            [self.schedView.navigationController pushViewController:detaView animated:YES];
            detaView.info =_arrBirthday[indexPath.row];
            detaView.HolidayViewDelegate=self;
        }
            break;
            
        case 4:{
            warningDataInfo *info =_arrholiday[indexPath.row];
            if ([info.isUserHandAdd isEqualToString:@"0"]) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                WorkView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"WorkView"];
                [self.schedView.navigationController pushViewController:detaView animated:YES];
                detaView.info=info;
                detaView.WorkViewDelegate=self;
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                HolidayView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"HolidayView"];
                [self.schedView.navigationController pushViewController:detaView animated:YES];
                detaView.info =info;
                detaView.HolidayViewDelegate=self;
            }

        }
            break;
        default:
            
            break;
    }
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

#pragma mark - PullRefreshDelegate delegate  点击置顶按钮时调用
/*置顶日程操作*/
- (void)contextMenuCellDidSelectMoreOption:(PullRefreshTableView *)tableView  withCell:(DAContextMenuCell *)cell{
    NSIndexPath *indexPath=[tableView indexPathForCell:cell];
    warningDataInfo *info;
    switch (tableView.tag) {
        case 0:{
            info =_arrAll[indexPath.row];
        }
            break;
            
        case 1:{
            info =_arrWork[indexPath.row];
        }
            break;
            
        case 2:{
            info =_arrLife[indexPath.row];
        }
            break;
            
        case 3:{
            info =_arrBirthday[indexPath.row];
        }
            break;
            
        case 4:{
            info =_arrholiday[indexPath.row];
        }
            break;
        default:
    
            break;
    }
   
    if ([dicDcomentFirst[@"ID"] isEqualToString:info.warningID]){/*取消置顶*/
      [self showHUDText:@"取消成功" showTime:1.0];
      [NewsScheduleController deleteFirstWarningWithID:info.warningID LocalNotificationWithDelete:NO];/*删除置顶*/
      cell.moreOptionsButtonTitle=@"置顶";
        
    }else {/*同步置顶*/
        
      [self updateFirstSchedule:info];
       [self showHUDText:@"置顶成功" showTime:1.0];
        for (DAContextMenuCell *cell1 in tableView.visibleCells) {
            if ([tableView indexPathForCell:cell1].row ==[tableView indexPathForCell:cell].row)
                cell1.moreOptionsButtonTitle=@"取消置顶";
            else
                cell1.moreOptionsButtonTitle=@"置顶";
        }
        
    }
    
    [self initWithData];
    [self updateOtherTableView:info];
}

/*对应更新其它tableView的信息*/
- (void)updateOtherTableView:(warningDataInfo *)info{
    if ([info.warningType isEqualToString:@"0"]&&_schedView.tableViewWork.hidden) {
 
        [self.schedView.tableViewWork reloadData];
        
    }else if ([info.warningType isEqualToString:@"1"]&&_schedView.tableViewLife.hidden){

        [self.schedView.tableViewLife reloadData];
        
    }else if ([info.warningType isEqualToString:@"2"]&&_schedView.tableViewBirthday.hidden){
 
        [self.schedView.tableViewBirthday reloadData];
        
    }else if ([info.warningType isEqualToString:@"3"]&&_schedView.tableViewHoliday.hidden){

        [self.schedView.tableViewHoliday reloadData];
    }
    
    /**/
    if (_schedView.tableViewAll.hidden) {
        [_schedView.tableViewAll  reloadData];
    }
}

#pragma mark - PullRefreshDelegate delegate  点击删除按钮时调用
/*删除日程操作*/
- (void)contextMenuCellDidSelectDeleteOption:(PullRefreshTableView *)tableView withCell:(DAContextMenuCell *)cell{
    NSIndexPath *indexPath=[tableView indexPathForCell:cell];
    warningDataInfo *info;
    switch (tableView.tag) {
        case 0:{
            info =_arrAll[indexPath.row];
            /*系统节日不能删除*/
            if ([info.isUserHandAdd isEqualToString:@"3"]&&[info.warningType isEqualToString:@"3"]){
                [ToolUtils alertInfo:@"系统日程,不能删除"];
                return;
            }
            [_arrAll removeObject:info];
        }
            break;
            
        case 1:{
            info =_arrWork[indexPath.row];
            [_arrWork removeObject:info];
        }
            break;
            
        case 2:{
            info =_arrLife[indexPath.row];
            [_arrLife removeObject:info];
        }
            break;
            
        case 3:{
            info =_arrBirthday[indexPath.row];
            [_arrBirthday removeObject:info];
        }
            break;
            
        case 4:{
            info =_arrholiday[indexPath.row];
            if ([info.isUserHandAdd isEqualToString:@"3"]&&[info.warningType isEqualToString:@"3"]){
                [ToolUtils alertInfo:@"系统日程,不能删除"];
                return;
            }
              [_arrholiday removeObject:info];
        }
            break;
        default:
            
            break;
    }
    
    /*删除对应的cell*/
    [cell.superview sendSubviewToBack:cell];
    tableView.customEditing = NO;
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
    /*更新对应数据*/
    [self updateGrouping:info];
}


/*删除全部日程分组里面的某个日程时，同步分组日程信息*/
- (void)updateGrouping:(warningDataInfo *)info{
    if ([info.warningType isEqualToString:@"0"]&&_schedView.tableViewWork.hidden) {
        for (warningDataInfo * info1 in _arrWork) {
            if ([info1.warningID isEqualToString:info.warningID]) {
                 [_arrWork removeObject:info1];
                 break;
            }
        }
        [self.schedView.tableViewWork reloadData];
        
    }else if ([info.warningType isEqualToString:@"1"]&&_schedView.tableViewLife.hidden){
        for (warningDataInfo * info1 in _arrLife) {
            if ([info1.warningID isEqualToString:info.warningID]) {
                [_arrLife removeObject:info1];
                 break;
            }
        }
        [self.schedView.tableViewLife reloadData];
        
    }else if ([info.warningType isEqualToString:@"2"]&&_schedView.tableViewBirthday.hidden){
        for (warningDataInfo * info1 in _arrBirthday) {
            if ([info1.warningID isEqualToString:info.warningID]) {
                [_arrBirthday removeObject:info1];
                 break;
            }
        }
        [self.schedView.tableViewBirthday reloadData];
        
    }else if ([info.warningType isEqualToString:@"3"]&&_schedView.tableViewHoliday.hidden){
        for (warningDataInfo * info1 in _arrholiday) {
            if ([info1.warningID isEqualToString:info.warningID]) {
                [_arrholiday removeObject:info1];
                 break;
            }
        }
       [self.schedView.tableViewHoliday reloadData];
    }
    
    /**/
    if (_schedView.tableViewAll.hidden) {
        for (warningDataInfo * info1 in _arrAll) {
            if ([info1.warningID isEqualToString:info.warningID]) {
                [_arrAll removeObject:info1];
                break;
            }
        }
        [_schedView.tableViewAll  reloadData];
    }

    /*发送删除请求*/
    [self deleteWarning:info.warningID];
}


/*发送删除请求*/
- (void)deleteWarning:(NSString *)ID{
    /*发送请求*/
    [packageData deleteWarningData:self
                         warningID:ID
                           SELType:removeWarning];
    
    /*更新置顶信息*/
    if ([dicDcomentFirst[@"ID"] isEqualToString:ID]){
        [NewsScheduleController deleteFirstWarningWithID:ID
                             LocalNotificationWithDelete:YES];
    }
    [self initWithData];
}

#pragma mark -pullTableView
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

//创建本地通告（全部）
- (void)addAllLocalNotification{
    NSArray*allLocalNotification=[[UIApplication sharedApplication] scheduledLocalNotifications];
    for(UILocalNotification*localNotification in allLocalNotification){
            [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
    }
    
    int count;
    if (_arrAll.count>10) count=10;
    else count=_arrAll.count;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    for (int i=0; i<count; i++) {
        warningDataInfo *info =_arrAll[i];
        NSString *strDate =[info.warningDate stringByAppendingString:InitDaysTime];
        NSDate *dateWarning =[dateFormatter dateFromString:strDate];
        NSTimeInterval time_warning =[dateWarning timeIntervalSince1970];
        NSTimeInterval time_now=[[NSDate date] timeIntervalSince1970];
        /*添加本地通知*/
        if (time_warning>=time_now)[self addLocalNotification:info isMerger:NO];
        
    }
    isAllInit=NO;
}

//创建本地通告（分类）
- (void)addWarningLocalNotification:(NSMutableArray *)array initWithOrBool:(BOOL *)Bool{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    *Bool=NO;/*将初始化日程提醒的标识设NO，避免下拉刷新时重复初始化本地通知*/
    int count;
    if (array.count>5) count=5;
    else count=array.count;
    
    
  NSArray*allLocalNotification=[[UIApplication sharedApplication]scheduledLocalNotifications];
    if (array.count>0) {
        /*删除重复的本地通知*/
        for(UILocalNotification*localNotification in allLocalNotification){
            NSString *alarmValue =[localNotification.userInfo objectForKey:@"warningType"];
            if ([alarmValue isEqualToString:[array[0] warningType]]) {
                [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
            }
        }
        /****************/
    }
    
    for (int i=0; i<count; i++) {
        warningDataInfo *info =array[i];
    
        NSString *strDate =[info.warningDate stringByAppendingString:InitDaysTime];
        NSDate *dateWarning =[dateFormatter dateFromString:strDate];
        
        NSTimeInterval time_warning =[dateWarning timeIntervalSince1970];
        NSTimeInterval time_now=[[NSDate date] timeIntervalSince1970];
        /****************/
        /*添加本地通知*/
        if (time_warning>=time_now) [self addLocalNotification:info isMerger:NO];
       /****************/
    }
    
}

//合并生日日程提醒
- (void)mergerWarningTypeToBirthday:(NSArray *)array isInit:(BOOL *)Bool{
    /*删除重复的本地通知*/
    NSArray*allLocalNotification=[[UIApplication sharedApplication]scheduledLocalNotifications];
    if (array.count>0) {
        for(UILocalNotification*localNotification in allLocalNotification){
            NSString *alarmValue =[localNotification.userInfo objectForKey:@"warningType"];
            if ([alarmValue isEqualToString:[array[0] warningType]]||!alarmValue) {
                [[UIApplication sharedApplication]cancelLocalNotification:localNotification];
            }
        }
        /****************/
    }
    
    *Bool=NO;/*将初始化日程提醒的标识设NO，避免下拉刷新时重复初始化本地通知*/
    int count;
    if (array.count>10) count=10;
    else count=array.count;
    NSString *TitleContents;
    BOOL isMerger=NO;
    
    if (count<=1)[self addLocalNotification:array[0] isMerger:YES];
    
    for (int i=1; i<count; i++) {
        warningDataInfo *info1 =array[i];
        warningDataInfo *info2 =array[i-1];
        if ([info1.remainTime isEqualToString:info2.remainTime]) {/*如果前后2个日程时间相同,则合并(只合并提示的人员名)*/
            if (!TitleContents)TitleContents =[NSString stringWithFormat:@"%@,%@",info1.content ,info2.content];
            else TitleContents  =[NSString stringWithFormat:@"%@,%@",TitleContents,info1.content];
            isMerger=YES;
        }else {/*否则结束合并,并创建合并后的本地通知*/
            if (isMerger)/*如果有合并的信息则按合并的创建本地通知,并同时需要创建当前循环“i”对应的本地通知*/
                          {[self setMergerWarningLocal:info2.warningDate content:TitleContents];
                           [self addLocalNotification:info1 isMerger:YES];}
            
            else if(i==1)/*如果前面没有合并的信息,表示只需添加单个信息的本地通知,这里需创建2个(下标 i 是从 1 还是计数的)*/
                          {[self addLocalNotification:info1 isMerger:YES];
                           [self addLocalNotification:info2 isMerger:YES];}
            
            else/*否则创建单个人的本地通知*/
                          {[self addLocalNotification:info1 isMerger:YES];}
            
            TitleContents=nil;
            isMerger=NO;
        }
        
    }

}


/*设置合并日程提醒本地通知*/
- (void)setMergerWarningLocal:(NSString *)stringDate content:(NSString *)contents{
    stringDate = [stringDate stringByReplacingOccurrencesOfString:@"//" withString:@" "];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate =[stringDate stringByAppendingString:InitDaysTime];
    NSDate * date =[dateFormatter dateFromString:strDate];
    UILocalNotification*notification=[[UILocalNotification alloc]init];
    notification.fireDate=date;//开始时间
    notification.timeZone=[NSTimeZone defaultTimeZone];// 设置时区
    notification.soundName=UILocalNotificationDefaultSoundName;//播放音乐类型
    notification.alertBody=[contents stringByAppendingString:@"  等人的生日"];//提示的消息
    notification.soundName=@"ping.caf";
    notification.alertAction = @"打开"; //提示框按钮
    notification.hasAction=NO;//是否显示额外的按钮
    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
}

/*设置本地通知信息*/
- (void)addLocalNotification:(warningDataInfo *)info isMerger:(BOOL)isMerger{
    /*如果为生日祝福,会在后面合并里面做处理,避免重复创建*/
    if (!isMerger &&[info.warningType isEqualToString:@"2"])return;
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *strDate =[info.warningDate stringByAppendingString:InitDaysTime];
    NSDate * date =[dateFormatter dateFromString:strDate];
    UILocalNotification*notification=[[UILocalNotification alloc]init];

    if(notification!=nil){
        notification.fireDate=date;//开始时间
        notification.timeZone=[NSTimeZone defaultTimeZone];// 设置时区
        notification.soundName=UILocalNotificationDefaultSoundName;//播放音乐类型
        NSString *strBody;
        if ([info.warningType isEqualToString:@"2"]) {
            strBody=[NSString stringWithFormat:@"%@ 的生日",info.content];
        }else{
            strBody=info.content;
        }
        
        if ([info.RequestType isEqualToString:@"1"]) {
            notification.repeatInterval=NSCalendarUnitWeekdayOrdinal;
        }else if([info.RequestType isEqualToString:@"2"]){
            notification.repeatInterval =NSCalendarUnitMonth;
        }else if([info.RequestType isEqualToString:@"3"]){
            notification.repeatInterval=NSCalendarUnitYear;
        }
        
        notification.alertBody=strBody;//提示的消息
        notification.alertLaunchImage = @"lunch.png";// 这里可以设置从通知启动的启动界面，类似Default.png的作用。
        notification.soundName=@"ping.caf";
        notification.alertAction = @"打开"; //提示框按钮
        notification.hasAction=NO;//是否显示额外的按钮
        
        NSMutableDictionary *dicInfo =[[NSMutableDictionary alloc] init];
        [dicInfo setObject:strBody forKey:@"content"];
        [dicInfo setObject:info.warningID forKey:@"ID"];
        [dicInfo setObject:info.RequestType forKey:@"RequestType"];
        [dicInfo setObject:info.warningType forKey:@"warningType"];
        [dicInfo setObject:info.remainTime forKey:@"remainTime"];
        [dicInfo setObject:info.UserTel forKey:@"UserTel"];
        [dicInfo setObject:info.warningDate forKey:@"warningDate"];
        if (info.isUserHandAdd)[dicInfo setObject:info.isUserHandAdd forKey:@"dataType"];
        
        notification.userInfo=dicInfo;//notification信息
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    }

}

- (void)showHUDText:(NSString *)text showTime:(NSTimeInterval)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.schedView.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText =text;
    hud.margin = 10.f;
    hud.yOffset = 170.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:time];
}

@end
