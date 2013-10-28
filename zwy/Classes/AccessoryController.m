//
//  AccessoryController.m
//  zwy
//
//  Created by cqsxit on 13-10-19.
//  Copyright (c) 2013年 sxit. All rights reserved.
//

#import "AccessoryController.h"
#import "DownloadCell.h"
#import "CheckAccessoryView.h"
#import "officeDetaInfo.h"
@implementation AccessoryController{
    NSString * strEndPath;
    NSString * strIngPath;
    NSMutableArray * arrFileManagerDowning;
    NSMutableArray * arrFileManagerDownEnd;
}

- (id)init{
    self =[super init];
    if (self) {
        //注册通知
        //附件下载
        [[NSNotificationCenter defaultCenter]addObserver:self
                                                selector:@selector(downAccessory:)
                                                    name:@"downAccessory"
                                                  object:nil];
        
        strIngPath =[DocumentsDirectory stringByAppendingPathComponent:@"IngDown.plist"];
        NSArray * IngDown =[NSArray arrayWithContentsOfFile:strIngPath];
        if (IngDown) {
            self.arrDowning =[[NSMutableArray alloc] initWithArray:IngDown];
            arrFileManagerDowning =[[NSMutableArray alloc] initWithArray:IngDown];
        }else{
            self.arrDowning=[[NSMutableArray alloc] init];
            arrFileManagerDowning =[[NSMutableArray alloc] init];
        }
        
        strEndPath =[DocumentsDirectory stringByAppendingPathComponent:@"EndDown.plist"];
        NSArray * EndDown =[NSArray arrayWithContentsOfFile:strEndPath];
        if (EndDown) {
             self.arrEnddown =[[NSMutableArray alloc] initWithArray:EndDown];
            arrFileManagerDownEnd=[[NSMutableArray alloc] initWithArray:EndDown];
        }else{
            self.arrEnddown =[[NSMutableArray alloc] init];
            arrFileManagerDownEnd =[[NSMutableArray alloc] init];
        }
    }
    return self;
}

/*通知--接收下载任务*/
- (void)downAccessory:(NSNotification *)notification{
    officeDetaInfo * info =[notification object];
    NSDictionary * dic =@{@"text":info.filename,@"url":info.url};
    NSMutableArray * arr =[[NSMutableArray alloc] init];
    [arr addObject:dic];
    for (int i=0; i<_arrDowning.count; i++) {
        [arr addObject:_arrDowning[i]];
    }
    
    [_arrDowning removeAllObjects];
    _arrDowning=NULL;
    _arrDowning =[[NSMutableArray alloc] initWithArray:arr];
    
    
    [arrFileManagerDowning removeAllObjects];
    arrFileManagerDowning=NULL;
    arrFileManagerDowning =[[NSMutableArray alloc] initWithArray:arr];
    [arrFileManagerDowning writeToFile:strIngPath atomically:NO];
    
   [_accView.tableViewDowning beginUpdates];
   [_accView.tableViewDowning insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
   [_accView.tableViewDowning endUpdates];
}


-(void)segmentAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    if (Index==0) {
        self.accView.tableViewDowning.hidden=NO;
        self.accView.tableViewEndDown.hidden=YES;
    }else{
        self.accView.tableViewDowning.hidden=YES;
        self.accView.tableViewEndDown.hidden=NO;
    }
}

#pragma mark - UItableViewDetaSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==0) return _arrDowning.count;
    else                  return _arrEnddown.count;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag==0) {/*正在下载列表*/
        static NSString *strCell =@"Cell";
        DownloadCell *cell  =(DownloadCell *)[tableView dequeueReusableCellWithIdentifier:strCell];
          NSString *str =[DocumentsDirectory stringByAppendingPathComponent: [_arrDowning[indexPath.row] objectForKey:@"text"]];
        if (!cell) {
            cell=[[DownloadCell alloc] initWithDelegate:self URL:[_arrDowning[indexPath.row] objectForKey:@"url"] reuseIdentifier:strCell filePath:str];
        }
        
        
        cell.fileText.text=[_arrDowning[indexPath.row] objectForKey:@"text"];
        cell.tag=indexPath.row;
//        CGRect rect= cell.detailTextLabel.frame;
//        rect.size.width=40;
//        cell.detailTextLabel.frame=rect;
//        cell.detailTextLabel.text=;
//        cell.tag=indexPath.row;
        return cell;
    }
    
    else{/*已下载列表*/
    static NSString *strCell =@"EndDownCell";
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:strCell];
        if (!cell) {
            cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strCell];
            cell.textLabel.font=[UIFont systemFontOfSize:13];
        }
        cell.textLabel.text =[_arrEnddown[indexPath.row] objectForKey:@"text"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44.0f;
}

#pragma mark -UITableVIewDelegate
- (void)downloadCellSaveWithFilePath:(NSString *)FilePath DownloadCell:(DownloadCell *)cell{
   /*保存本地*/
    for (int i = 0; i<_arrDowning.count; i++) {
        NSDictionary *dic =_arrDowning[i];
        if ([[dic objectForKey:@"text"]isEqualToString:cell.fileText.text]) {
            [arrFileManagerDowning removeObject:dic];
            [arrFileManagerDowning writeToFile:strIngPath atomically:NO];
            
            if (![arrFileManagerDownEnd containsObject:dic]){
            [arrFileManagerDownEnd addObject:dic];
            [arrFileManagerDownEnd writeToFile:strEndPath atomically:NO];
            }
            
        }
    }
}


#pragma mark - UITableViewDelegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag==1) {
        return YES;
    }else{
        return NO;
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSString *uniquePath =[DocumentsDirectory stringByAppendingPathComponent:[_arrEnddown[indexPath.row] objectForKey:@"text"]];
       BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
        if (blHave) [[NSFileManager defaultManager] removeItemAtPath:uniquePath error:nil];
        [_arrEnddown removeObjectAtIndex:indexPath.row];
        [arrFileManagerDownEnd  removeObjectAtIndex:indexPath.row];
        [arrFileManagerDownEnd writeToFile:strEndPath atomically:NO];
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==0) {
        [self tableViewDowning:tableView didSelectRowAtIndexPath:indexPath];
    }else{
        [self tableViewEndDown:tableView didSelectRowAtIndexPath:indexPath];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*点击正在下载列表调用*/
- (void)tableViewDowning:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (UIView  *view in tableView.visibleCells) {
        
        if (view.tag==indexPath.row) {
            DownloadCell *cell =(DownloadCell *)view;
            
            if([cell.labelText.text isEqualToString:@"下载完成"]){
                
                /*查看附件*/
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                CheckAccessoryView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"CheckAccessoryView"];
                [self.accView.navigationController pushViewController:detaView animated:YES];
                detaView.url =[_arrDowning[indexPath.row] objectForKey:@"text"];
                /**********/
                
                /*删除对应行，并保存本地*/
                NSDictionary *dic =_arrDowning[indexPath.row];
                if (![_arrEnddown containsObject:dic]) [_arrEnddown addObject:_arrDowning[indexPath.row]];
                [_arrDowning removeObjectAtIndex:indexPath.row];
                [self.accView.tableViewEndDown reloadData];
                /******************/
                
                [tableView beginUpdates];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [tableView endUpdates];
                [self performSelector:@selector(reloadDownTableView) withObject:self afterDelay:0.2];
                

            }
            
        }
        
    }

}
- (void)reloadDownTableView{
        [self.accView.tableViewDowning reloadData];
}

/*点击已下载列表调用*/
- (void)tableViewEndDown:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    /*查看附件*/
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    CheckAccessoryView *detaView = [storyboard instantiateViewControllerWithIdentifier:@"CheckAccessoryView"];
    [self initBackBarButtonItem:self.accView];
    [self.accView.navigationController pushViewController:detaView animated:YES];
     detaView.url =[_arrEnddown[indexPath.row] objectForKey:@"text"];
}
@end
