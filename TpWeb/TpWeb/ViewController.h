//
//  ViewController.h
//  TpWeb
//
//  Created by Sharon Colin on 23/11/2016.
//  Copyright © 2016 Sharon Colin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UITextView *code;
@property (weak, nonatomic) IBOutlet UITextField *url;

- (IBAction)search:(id)sender;
- (IBAction)btnWeb:(id)sender;

@end

