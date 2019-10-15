//
//  NBHomeViewController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "NBHomeViewController.h"
#import "NBHomeViewModel.h"
#import "NBVideoTableViewCell.h"
#import "VideoPlayViewController.h"
#import "UIBarButtonItem+Extension.h"
#import <AVFoundation/AVFoundation.h>
#import "WBQRCodeVC.h"
#import <kkplayer/kkplayer.h>

@interface NBHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic) UITableView *tableView;



@end

@implementation NBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _homeVmodel = (NBHomeViewModel*)self.vmodel;
    
    KKMediaPlayController *vc = [KKMediaPlayController new];
    
    [self setupUI];
    
    [self bindSignal];
    
    [self rightNavItem];
    
}

-(void)rightNavItem{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"扫码" titleColor:[UIColor nbOringe] image:@"" target:self action:@selector(rightItemClick)];
    
}

-(void)rightItemClick{
    WBQRCodeVC *WBVC = [[WBQRCodeVC alloc] init];
    [self QRCodeScanVC:WBVC];
}

- (void)QRCodeScanVC:(UIViewController *)scanVC {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            [self.navigationController pushViewController:scanVC animated:YES];
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self.navigationController pushViewController:scanVC animated:YES];
                break;
            }
            case AVAuthorizationStatusDenied: {
                
                [self showAlertTitle:@"温馨提示" content:@"请去-> [设置 - 隐私 - 相机 - NBPlayer] 打开访问开关" cancle:@"" sure:@"" cancleAction:^{
                    
                } sureAction:^{
                    [NSObject openQFAppSetting];
                }];

                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    [self showAlertTitle:@"温馨提示" content:@"未检测到您的摄像头" cancle:@"取消" sure:@"确定" cancleAction:^{
        
    } sureAction:^{
        
    }];
}

-(void)bindSignal{
    @weakify(self)
    [self.homeVmodel.videsSuj subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.tableView reloadData];
    }];
    
    [self.homeVmodel loadDocumentLibraryFile];
}


-(void)setupUI{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        [_tableView registerClass:[NBVideoTableViewCell class] forCellReuseIdentifier:@"NBVideoTableViewCell"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.homeVmodel.videoArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBVideoTableViewCell"];
    VideoMessage *meg = self.homeVmodel.videoArray[indexPath.row];
    
    [cell updateCell:meg];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //http://video-oss.qiaofangyun.com/uatTest_companyasdf123sa1s/video/2019/08/13/1565676969.292076/A5B177F0-0872-4785-ABB4-E3F245952754L0001.mp4
    VideoMessage *meg = self.homeVmodel.videoArray[indexPath.row];
    NSURL *fileUrl = [NSURL fileURLWithPath:meg.filePath];
    VideoPlayViewModel *videovm = [[VideoPlayViewModel alloc]initWithUrl:fileUrl];
    VideoPlayViewController *videovc = [[VideoPlayViewController alloc]initwithViewModel:videovm];
    [self.navigationController pushViewController:videovc animated:true];
}



@end
