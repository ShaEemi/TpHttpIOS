//
//  WebViewController.m
//  TpWeb
//
//  Created by Sharon Colin on 01/12/2016.
//  Copyright © 2016 Sharon Colin. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Navigateur";
    NSURL *urlweb = [NSURL URLWithString:_urlLoad];
    NSURLRequest *requete = [NSURLRequest requestWithURL:urlweb];
    [_navigateur loadRequest:requete];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
