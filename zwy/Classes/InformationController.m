//
//  InformationController.m
//  zwy
//
//  Created by wangshuang on 10/12/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "InformationController.h"
#import "Constants.h"
#import "ToolUtils.h"
#import "TemplateCell.h"
#import "InformationInfo.h"
@implementation InformationController{
    NSString *page;
    NSMutableArray *arr0;
    NSMutableArray *arr1;
    NSInteger arr0Count;
    NSInteger arr1Count;
    BOOL isUpdata;
    BOOL isUpdata1;
    NSInteger selecter;
    NSString *start;
    NSString *end;
    NSString *start1;
    NSString *end1;

}

-(id)init{
    self=[super init];
    if(self){
        page=@"1";
        selecter=0;
        arr0=[NSMutableArray new];
        arr1=[NSMutableArray new];
        start=@"1";
        end=@"20";
        start1=@"1";
        end1=@"20";
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData:)
                                                    name:xmlNotifInfo
                                                  object:self];
        
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(handleData1:)
                                                    name:xmlNotifInfo1
                                                  object:self];

    }
    return self;
}

//页签选择
-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    switch (Index) {
        case 0:{
            //新闻资讯
            selecter=0;
            [self.informationView.listview reloadDataPull];
            self.informationView.listview.hidden=NO;
            self.informationView.listview1.hidden=YES;
        }
            break;
        case 1:{
            //经典笑话
            selecter=1;
            if(arr1.count==0){
                self.informationView.listview1.separatorStyle = NO;
                [self.informationView.listview1 reloadDataPull];
                [self.informationView.listview1 LoadDataBegin];
            }else{
                [self.informationView.listview1 reloadDataPull];
            }
            
            self.informationView.listview.hidden=YES;
            self.informationView.listview1.hidden=NO;
            
        }
            break;
    }
    
    
}

//处理网络数据
-(void)handleData:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (isUpdata) {
       [arr0 removeAllObjects];
        isUpdata=NO;
    }
    if(dic){
        RespList *list=[AnalysisData newsInfo:dic];
        
        if(list.resplist.count>0){
            [arr0 addObjectsFromArray:list.resplist];
            self.informationView.listview.separatorStyle = YES;
        }else{
            
            
            if(arr0.count==0)
            [ToolUtils alertInfo:@"暂无数据"];
            self.informationView.listview.reachedTheEnd=NO;
        }
    }else{
        [ToolUtils alertInfo:requestError];
    }
    [self.informationView.listview reloadDataPull];
}

//处理网络数据
-(void)handleData1:(NSNotification *)notification{
    NSDictionary *dic=[notification userInfo];
    if (isUpdata1) {
        [arr1 removeAllObjects];
        isUpdata1=NO;
    }
    if(dic){
        RespList *list=[AnalysisData JokeInfo:dic];
        if(list.resplist.count>0){
           [arr1 addObjectsFromArray:list.resplist];
            self.informationView.listview1.separatorStyle = YES;
        }else{
            if(arr1.count==0)
            [ToolUtils alertInfo:@"暂无数据"];
            self.informationView.listview1.reachedTheEnd=NO;
        }
    }else{
       // [ToolUtils alertInfo:requestError];
    }
    [self.informationView.listview1 reloadDataPull];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView.tag==0){
        return 60;
    }else{
        UITableViewCell * cell =[self tableView:tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView.tag==0){
        return arr0.count;
    }else{
        return arr1.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * strCell1 =@"cell1";
    static NSString * strCell2 =@"cell2";
    TemplateCell * cell;
    if(tableView.tag==0){
        cell =[tableView dequeueReusableCellWithIdentifier:strCell1];
        if (!cell) {
            cell = [[TemplateCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:strCell1];
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }
        InformationInfo *info=arr0[indexPath.row];
        cell.title.text=info.title;
        cell.content.text=info.content;
    }else{
        cell =[tableView dequeueReusableCellWithIdentifier:strCell2];
        if (!cell) {
            cell = [[TemplateCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                       reuseIdentifier:strCell2];
            cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
        }
        InformationInfo *info=arr1[indexPath.row];
        cell.content.text=info.content;
        cell.content.textColor=[UIColor blackColor];
        CGRect textRect = [cell.content.text boundingRectWithSize:CGSizeMake(280.0f, 1000.0f)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:@{NSFontAttributeName:cell.content.font}
                                             context:nil];
        CGRect rect=cell.content.frame;
        rect.size=textRect.size;
        rect.origin.y=5;
        cell.content.frame=rect;
        rect =cell.frame;
        rect.size.height=cell.content.frame.size.height+10;
        cell.frame=rect;
    }
    return cell;
}


/*下拉刷新*/
- (void)upLoadDataWithTableView:(PullRefreshTableView *)tableView{
    //    [self performSelector:@selector(upData) withObject:nil afterDelay:2];
    if(tableView.tag==0){
        start=@"1";
        end=@"20";
        isUpdata=YES;
        [packageData reqHotNewsInfoXml:self start:start end:end SELType:xmlNotifInfo];
    }else if(tableView.tag==1){
        start1=@"1";
        end1=@"20";
        isUpdata1=YES;
        [packageData reqJokeInfoXml:self start:start1 end:end1 SELType:xmlNotifInfo1];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
            [self.informationView performSegueWithIdentifier:@"informationtodetail" sender:self.informationView];
            [self initBackBarButtonItem:self.informationView];
            InformationInfo *info=arr0[indexPath.row];
        self.informationView.informationInfo=info;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*上拉加载*/
- (void)refreshDataWithTableView:(PullRefreshTableView *)tableView{
    //    [self performSelector:@selector(loadData) withObject:nil afterDelay:2];
    
    if(tableView.tag==0){
        NSInteger start_=[ToolUtils stringToNum:start];
        NSInteger end_=[ToolUtils stringToNum:end];
        start_+=20;
        end_+=20;
        start=[ToolUtils numToString:start_];
        end=[ToolUtils numToString:end_];
        [packageData reqHotNewsInfoXml:self start:start end:end SELType:xmlNotifInfo];
    }else{
        NSInteger start_1=[ToolUtils stringToNum:start1];
        NSInteger end_1=[ToolUtils stringToNum:end1];
        start_1+=20;
        end_1+=20;
        start1=[ToolUtils numToString:start_1];
        end1=[ToolUtils numToString:end_1];
        [packageData reqJokeInfoXml:self start:start1 end:end1 SELType:xmlNotifInfo1];
    }
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.tag==0){
    [self.informationView.listview scrollViewDidPullScroll:scrollView];
    }else{
    [self.informationView.listview1 scrollViewDidPullScroll:scrollView];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
