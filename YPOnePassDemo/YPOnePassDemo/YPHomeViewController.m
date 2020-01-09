//
//  YPHomeViewController.m
//  YPOneLoginApp
//
//  Created by qipeng_yuhao on 2019/11/12.
//  Copyright © 2019 QiPeng. All rights reserved.
//

#import "YPHomeViewController.h"


@interface YPHomeViewController ()

@property (strong, nonatomic) UIImageView *bgImageView;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *sloganLabel;
@property (strong, nonatomic) UIButton *verifyBtn;
@property (strong, nonatomic) UILabel *versionInfoLabel;


@end

@implementation YPHomeViewController

#pragma mark - Getter

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        _bgImageView.image = [UIImage imageNamed:@"bg1"];
        
    }
    return _bgImageView;
}

- (UIImageView *)logoImageView{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yunpianLogo2"]];
        [_logoImageView sizeToFit];
        
    }
    return _logoImageView;
}

- (UILabel *)sloganLabel{
    if (!_sloganLabel) {
        _sloganLabel = [[UILabel alloc] init];
        [_sloganLabel setText:@"您的新一代\n身份验证解决方案"];
        [_sloganLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
        [_sloganLabel setTextColor:Black0Color];
        _sloganLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _sloganLabel.numberOfLines = 0;
        [_sloganLabel sizeToFit];
    }
    return _sloganLabel;
}

- (UIButton *)verifyBtn{
    if (!_verifyBtn) {
        _verifyBtn = [[UIButton alloc] init];
        _verifyBtn.backgroundColor = Purple0Color;
        _verifyBtn.layer.masksToBounds = YES;
        _verifyBtn.layer.cornerRadius = 5.0;
        [_verifyBtn.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_verifyBtn setTitle:@"本机校验" forState:UIControlStateNormal];
        [_verifyBtn setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_verifyBtn setTitleColor:UIColor.grayColor forState:UIControlStateSelected];
        [_verifyBtn addTarget:self action:@selector(verifyClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _verifyBtn;
}

- (UILabel *)versionInfoLabel{
    if (!_versionInfoLabel) {
        _versionInfoLabel = [[UILabel alloc] init];
        _versionInfoLabel.text = [TEST_HOST isEqualToString:@"https://mobileauth.yunpian.com"]?@"云片移动认证产品体验v2.0.0":@"测试环境";
        _versionInfoLabel.textColor = UIColor.grayColor;
        if (@available(iOS 8.2, *)) {
            _versionInfoLabel.font = [UIFont systemFontOfSize:11 weight:0.5];
        } else {
            _versionInfoLabel.font = [UIFont systemFontOfSize:11];
        }
        _versionInfoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _versionInfoLabel;
}

//563*1218 325*568  1.7*2.1

#pragma mark - ViewController life

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.sloganLabel];
    [self.view addSubview:self.verifyBtn];
    [self.view addSubview:self.versionInfoLabel];
    
    
}

- (void)viewDidLayoutSubviews{
    [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.top.mas_equalTo(StatusBarH + 10);
    }];
    
    [_sloganLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.bottom.equalTo(self.versionInfoLabel.mas_top).mas_equalTo(-230);
    }];
        
    [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.mas_equalTo(60);
        make.top.equalTo(self.sloganLabel.mas_bottom).mas_offset(60);
    }];
    
    [_versionInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {//注意刘海屏的安全距离
            make.bottom.mas_equalTo(- (SafeBottom + 20));
        } else {
            make.bottom.mas_equalTo(- 20);
        }
        make.left.right.mas_equalTo(0);
    }];

}


#pragma mark - click


- (void)verifyClick:(UIButton *)sender{
    YPVerifyViewController *ypVerifyVC = [[YPVerifyViewController alloc] init];
    [self.navigationController pushViewController:ypVerifyVC animated:YES];
}

@end
