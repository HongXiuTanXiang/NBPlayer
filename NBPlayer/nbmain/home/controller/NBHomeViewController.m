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



@interface NBHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong ,nonatomic) UITableView *tableView;



@end

@implementation NBHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _homeVmodel = (NBHomeViewModel*)self.vmodel;
    
    NSArray *files = [self.homeVmodel loadDocumentLibraryFile];
    for (NSString *file in files) {
        NSLog(@"%@",file);
    }
    
    [self setupUI];
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
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NBVideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NBVideoTableViewCell"];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}



@end
