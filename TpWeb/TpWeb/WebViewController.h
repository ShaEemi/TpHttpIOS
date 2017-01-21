//
//  WebViewController.h
//  TpWeb
//
//  Created by Sharon Colin on 01/12/2016.
//  Copyright © 2016 Sharon Colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property IBOutlet UIWebView *navigateur;
@property (strong, nonatomic) NSString *urlLoad;

@end
