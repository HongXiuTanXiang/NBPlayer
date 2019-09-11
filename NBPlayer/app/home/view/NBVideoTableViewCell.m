//
//  NBVideoTableViewCell.m
//  
//
//  Created by Mac on 2019/9/4.
//

#import "NBVideoTableViewCell.h"


@interface NBVideoTableViewCell()
@property(nonatomic, strong) UIImageView *iconView;
@property(nonatomic, strong) UILabel *videoTitleLab;
@property(nonatomic, strong) UILabel *fileEditTimeLab;
@property(nonatomic, strong) UILabel *videoTimeLab;
@property(nonatomic, strong) UIImageView *arrowView;

@end

@implementation NBVideoTableViewCell


-(void)updateCell:(VideoMessage*)vmsg{
    self.videoTitleLab.text = vmsg.name;
    self.videoTimeLab.text = vmsg.timeLength;
    self.fileEditTimeLab.text = vmsg.editTime;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    _iconView = [[UIImageView alloc]init];
    _iconView.image = [UIImage imageNamed:@"apple_logo"];
    [self.contentView addSubview:self.iconView];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.top.mas_equalTo(self.contentView.mas_top).offset(10);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-10);
        make.width.mas_equalTo(80);
    }];
    
    _arrowView = [[UIImageView alloc]init];
    _arrowView.image = [UIImage imageNamed:@"jiantou"];
    [self.contentView addSubview:_arrowView];
    [_arrowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.centerY.mas_equalTo(self.contentView.mas_centerY);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(20);
    }];
    
    _videoTitleLab = [UILabel labelWithText:@"视频标题" fontName:kFontRegular fontSize:16 fontColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_videoTitleLab];
    [_videoTitleLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.top.mas_equalTo(self.iconView.mas_top);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    _fileEditTimeLab = [UILabel labelWithText:@"2019-09-04" fontName:kFontRegular fontSize:14 fontColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:_fileEditTimeLab];
    [_fileEditTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.top.mas_equalTo(_videoTitleLab.mas_bottom).offset(10);
        make.height.mas_equalTo(18);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
    
    _videoTimeLab = [UILabel labelWithText:@"2019-09-04 18:11" fontName:kFontRegular fontSize:14 fontColor:[UIColor darkGrayColor] textAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.videoTimeLab];
    [_videoTimeLab makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconView.mas_right).offset(10);
        make.top.mas_equalTo(_fileEditTimeLab.mas_bottom).offset(10);
        make.height.mas_equalTo(15);
        make.right.mas_equalTo(self.contentView.mas_right);
    }];
}

@end
