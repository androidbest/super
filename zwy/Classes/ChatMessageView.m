//
//  ChatMessageView.m
//  zwy
//
//  Created by wangshuang on 12/17/13.
//  Copyright (c) 2013 sxit. All rights reserved.
//

#import "ChatMessageView.h"
#import "ChatMessageController.h"
#import "DAKeyboardControl.h"
#import "ToolUtils.h"

#define INPUT_HEIGHT 46.0f
@interface ChatMessageView ()

@end

@implementation ChatMessageView{
  
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    if(self){
        ChatMessageController *contacts=[ChatMessageController new];
        contacts.chatMessageView=self;
        self.controller=contacts;
        
        //键盘显示
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillShowKeyboard:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        //键盘隐藏
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleWillHideKeyboard:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
         if (!_arrPeoples) _arrPeoples=[[NSMutableArray alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_arrPeoples.count>0) {
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(0.0, 0.0, 25.0, 25.0);
        [rightBtn setImage:[UIImage imageNamed:@"tabItem_groupArBook_out"] forState:UIControlStateNormal];
        [rightBtn addTarget:self.controller action:@selector(rightDown) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        rightItem.style = UIBarButtonItemStylePlain;
        self.navigationItem.rightBarButtonItem =rightItem;
    }

    
    _send=[[UIButton alloc] initWithFrame:CGRectMake(265, 6, 50, 35)];
    [_send setBackgroundColor:[UIColor colorWithRed:0.26 green:0.47 blue:0.98 alpha:1.0]];
    _send.layer.masksToBounds = YES;
    _send.layer.cornerRadius = 6.0;
    [_send addTarget:self.controller action:NSSelectorFromString(@"sendMessage") forControlEvents:UIControlEventTouchUpInside];
    [_send setTitle:@"发送" forState:UIControlStateNormal];
    [_send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _send.titleLabel.font=[UIFont systemFontOfSize:13];
    [_send setEnabled:NO];
    [_send setAlpha:0.4];
    
    _voiceSend=[[UIButton alloc] initWithFrame:CGRectMake(59, 7, 250, 30)];
    [_voiceSend setBackgroundColor:[UIColor colorWithRed:0.26 green:0.47 blue:0.98 alpha:1.0]];
    _voiceSend.layer.masksToBounds = YES;
    _voiceSend.layer.cornerRadius = 6.0;
//    [_voiceSend addTarget:self.controller action:NSSelectorFromString(@"sendMessage") forControlEvents:UIControlEventTouchUpInside];
    [_voiceSend setTitle:@"按住 说话" forState:UIControlStateNormal];
    [_voiceSend setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _voiceSend.titleLabel.font=[UIFont systemFontOfSize:13];
    _voiceSend.hidden=YES;
    UILongPressGestureRecognizer *longPrees = [[UILongPressGestureRecognizer alloc]initWithTarget:self.controller action:NSSelectorFromString(@"recordBtnLongPressed:")];
    longPrees.delegate = self.controller;
    [_voiceSend addGestureRecognizer:longPrees];
    
    
    
    
    _im_text=[[UITextView alloc] initWithFrame:CGRectMake(49, 5, 208, 35)];
    _im_text.layer.masksToBounds=YES;
    _im_text.layer.cornerRadius=6.0;
    _im_text.layer.borderWidth=0.5;
    _im_text.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    _im_text.delegate=self.controller;
    
    _voicepress=[[UIButton alloc]initWithFrame:CGRectMake(9, 6, 38, 34)];
    [_voicepress setBackgroundImage:[UIImage imageNamed:@"voice_press"] forState:UIControlStateNormal];
    [_voicepress addTarget:self.controller action:NSSelectorFromString(@"voicepress:") forControlEvents:UIControlEventTouchUpInside];
    _voicepress.tag=0;
    
    
    _toolbar=[[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight-47,ScreenWidth, 47)];
    _toolbar.layer.borderWidth=0.5;
    _toolbar.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    [_toolbar setBackgroundColor:[UIColor whiteColor]];
   
    [_toolbar addSubview:_send];
    [_toolbar addSubview:_im_text];
    [_toolbar addSubview:_voicepress];
    [_toolbar addSubview:_voiceSend];
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-47)];
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    UIEdgeInsets insets=_tableview.contentInset;
    insets.top=64;
    _tableview.contentInset=insets;
    _tableview.delegate=self.controller;
    _tableview.dataSource=self.controller;
    
    
    
    UITapGestureRecognizer* singleRecognizer;
    singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self.controller action:NSSelectorFromString(@"SingleTap:")];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    //点击的手指数
    //singleRecognizer.numberOfTouchesRequired = 2;
    //给view添加一个手势监测；
    [_tableview addGestureRecognizer:singleRecognizer];
    
    // 滑动的 Recognizer
    UISwipeGestureRecognizer *swipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self.controller action:NSSelectorFromString(@"handleSwipe:")];
    //设置滑动方向
    [swipeRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [_tableview addGestureRecognizer:swipeRecognizer];
    
    
    [((ChatMessageController *)self.controller) initDatatoData];
    
    [self.view addSubview:_tableview];
    [self.view addSubview:_toolbar];
    
    //初始化播放器的时候如下设置
//    UInt32 sessionCategory = kAudioSessionCategory_MediaPlayback;
//    AudioSessionSetProperty(kAudioSessionProperty_AudioCategory,
//                            sizeof(sessionCategory),
//                            &sessionCategory);
//    
//    UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
//    AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,sizeof (audioRouteOverride),&audioRouteOverride);
//    
//    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
//    //默认情况下扬声器播放
//    [audioSession setActive:YES error:nil];
//    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    
    //初始化录音vc
    _recorderVC = [[ChatVoiceRecorderVC alloc]init];
    _recorderVC.vrbDelegate = self.controller;
    
    //初始化播放器
    _player = [[AVAudioPlayer alloc]init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MessageViewToOptionChatView"]) {
        [self.controller BasePrepareForSegue:segue sender:sender];
        return;
    } else if([segue.identifier isEqualToString:@"ChatMessageToEditingPeoplesView"]){
        [self.controller BasePrepareForSegue:segue sender:sender];
        return;
    }
    //将page2设定成Storyboard Segue的目标UIViewController
    id page2 = segue.destinationViewController;
    //将值透过Storyboard Segue带给页面2的string变数
    _chatData.status=@"1";
    [page2 setValue:_chatHead forKey:@"data"];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.title=_chatData.Name;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShowHide:(NSNotification *)notification
{
    CGRect keyboardRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
	double duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0.0f
                        options:[ToolUtils animationOptionsForCurve:curve]
                     animations:^{
                         CGFloat keyboardY = [self.view convertRect:keyboardRect fromView:nil].origin.y;
                         
                         CGRect inputViewFrame = _toolbar.frame;
                         CGFloat inputViewFrameY = keyboardY - inputViewFrame.size.height;
                         
                         // for ipad modal form presentations
                         CGFloat messageViewFrameBottom = self.view.frame.size.height - INPUT_HEIGHT;
                         if(inputViewFrameY > messageViewFrameBottom)
                             inputViewFrameY = messageViewFrameBottom;
                         
                         _toolbar.frame = CGRectMake(inputViewFrame.origin.x,
                                                                  inputViewFrameY,
                                                                  inputViewFrame.size.width,
                                                                  inputViewFrame.size.height);
                         UIEdgeInsets insets = _tableview.contentInset;
                         insets.bottom = self.view.frame.size.height - _toolbar.frame.origin.y - inputViewFrame.size.height;
                         _tableview.contentInset = insets;
                         _tableview.scrollIndicatorInsets = insets;
                         
                         NSInteger rows = [self.tableview numberOfRowsInSection:0];
                         if(rows > 0) {
                             [self.tableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows - 1 inSection:0]
                                                                   atScrollPosition:UITableViewScrollPositionBottom
                                                                           animated:YES];
                         }
                     }
                     completion:^(BOOL finished) {
                     }];
}

- (void)handleWillShowKeyboard:(NSNotification *)notification
{
    [self keyboardWillShowHide:notification];
}

-(void)handleWillHideKeyboard:(NSNotification *)notification{

//    CGRect inputViewFrame = self.toolbar.frame;
//    CGPoint keyboardOrigin = [self.view convertPoint:CGPointMake(0.0f, 371) fromView:nil];
//    inputViewFrame.origin.y = keyboardOrigin.y - inputViewFrame.size.height;
//    self.toolbar.frame = inputViewFrame;
//    
//    CGRect inputViewFrame1 = self.toolbar.frame;
//    inputViewFrame1.origin.y = self.view.bounds.size.height - inputViewFrame1.size.height;
//    self.toolbar.frame = inputViewFrame1;
    
    [self keyboardWillShowHide:notification];
}


//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [super touchesEnded:touches withEvent:event];
//    [_im_text resignFirstResponder];
//}

- (void)rightDown
{

}

-(void)dealloc{


}
@end
