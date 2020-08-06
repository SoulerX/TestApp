//
//  LoginViewController.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/31.
//  Copyright © 2020 netease. All rights reserved.
//

#import "LoginViewController.h"

#import "HomeViewController.h"
#import "DataForFMDB.h"


@interface LoginViewController ()

@property(nonatomic , weak)IBOutlet UIImageView *iconview;
@property(nonatomic , weak)IBOutlet UIView *inputView;

@property(nonatomic , weak)IBOutlet UITextField *accountTextField;
@property(nonatomic , weak)IBOutlet UITextField *passwordTextField;
@property(nonatomic , weak)IBOutlet UIButton *loginButton;
@property(nonatomic , weak)IBOutlet UIButton *clearAccountButton;
@property(nonatomic , weak)IBOutlet UIButton *clearPasswordButton;
@property(nonatomic , weak)IBOutlet UIButton *isvisiblePasswordButton;
@property(nonatomic , weak)IBOutlet UIButton *forgetPasswordButton;
@property(nonatomic , weak)IBOutlet UIButton *registerAccountButton;

@property(nonatomic , assign) CGFloat angle;

@end

@implementation LoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.angle = 0;
    
    self.inputView.layer.cornerRadius = 10;
    self.inputView.layer.masksToBounds = YES;

    [self startAnimation];
    
    [self initButton];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)startAnimation{
    CGAffineTransform endAngle = CGAffineTransformMakeRotation(self.angle * (M_PI / 180.0f));

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.01 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        weakSelf.iconview.transform = endAngle;
    } completion:^(BOOL finished) {
        weakSelf.angle += 2; [weakSelf startAnimation];
    }];
}

- (void)initButton{
    self.passwordTextField.secureTextEntry = YES;
    self.passwordTextField.text = @"";
    
    [self.clearAccountButton addTarget:self action:@selector(clearAccount) forControlEvents:UIControlEventTouchUpInside];
    
    [self.clearPasswordButton addTarget:self action:@selector(clearPassword) forControlEvents:UIControlEventTouchUpInside];
    
    [self.isvisiblePasswordButton addTarget:self action:@selector(isVisible:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.loginButton addTarget:self action:@selector(clickLogin) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.layer.cornerRadius=5;
    self.loginButton.layer.masksToBounds=YES;
    
    [self.forgetPasswordButton addTarget:self action:@selector(btForget) forControlEvents:UIControlEventTouchUpInside];
    
    [self.registerAccountButton addTarget:self action:@selector(btRegister) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clearAccount{
    self.accountTextField.text=@"";
}

- (void)clearPassword{
    self.passwordTextField.text=@"";
}

- (void)isVisible:(UIButton*)button{
    button.selected = !button.selected;
    
    if(button.selected)
    {
        self.passwordTextField.secureTextEntry = NO;
        
        [self.isvisiblePasswordButton  setImage:[UIImage imageNamed:@"icon_预览"] forState:UIControlStateNormal];
    }
    else
    {
        self.passwordTextField.secureTextEntry = YES;
        
        [self.isvisiblePasswordButton setImage:[UIImage imageNamed:@"眼睛-闭"] forState:UIControlStateNormal];
    }
    [self.passwordTextField becomeFirstResponder];
}

- (void)popTip:(NSString*)tips{
    NSLog(@"弹窗");
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:tips preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction * cancelAc = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"确定");
        if([tips isEqualToString:@"账号不能为空!!!"] ||[tips isEqualToString:@"账号或密保错误!!!"])
            [self btForget];
        else if([tips isEqualToString:@"输入格式不正确!!!"]||[tips isEqualToString:@"该账号已存在!!!"]||[tips isEqualToString:@"SQL格式不正确!!!"])
            [self btRegister];
    }];
    
    [alertVC addAction:cancelAc];
    
    [self presentViewController:alertVC animated:YES completion:nil];
}

// 登录
- (void)clickLogin{
    if([[DataForFMDB sharedDataBase]checkAccountPassword:self.accountTextField.text passwordString:self.passwordTextField.text])
    {
        HomeViewController *vc = [HomeViewController new];
        
        __weak typeof(self) weakSelf = self;
        
        vc.passingValue = ^(void){
            [weakSelf clearPassword];
        };
        
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
        [self popTip:@"账号或密码错误"];
}

// 注册用户
- (void) btRegister{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"注册账号"
                                                                              message:@"REGISTER"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"你的账号...";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"你的密码...";
    }];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
           textField.placeholder = @"你的密保...";
       }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(alertController.textFields[0].text.length>0 && alertController.textFields[1].text.length>0  && alertController.textFields[2].text.length>0)
        {
            int result =[[DataForFMDB sharedDataBase]addAccount:alertController.textFields[0].text passwordString:alertController.textFields[1].text protectionString: alertController.textFields[2].text];
            
            if(result==0)
                [weakSelf popTip:@"该账号已存在!!!"];
            else if(result==-1)
                [weakSelf popTip:@"SQL格式不正确!!!"];
            else if(result==1)
                ;
        }
        else
        {
            [weakSelf popTip:@"输入格式不正确!!!"];
        }
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

// 找回密码
- (void) btForget{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"找回密码"
                                                                              message:@"REFIND"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = @"你的账号...";
        
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
           textField.placeholder = @"你的密保...";
       }];
    
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if(alertController.textFields[0].text.length<=0)
        {
            [weakSelf popTip:@"账号不能为空!!!"];
          
        }
        
        NSString *psd = [[DataForFMDB sharedDataBase]backAccountPassword:alertController.textFields[0].text protectionString:alertController.textFields[1].text];
       
        if(psd != nil)
            [weakSelf popTip:[NSString stringWithFormat:@"password:%@",psd]];
        else
            [weakSelf popTip:@"账号或密保错误!!!"];
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
