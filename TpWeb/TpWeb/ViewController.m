//
//  ViewController.m
//  TpWeb
//
//  Created by Sharon Colin on 23/11/2016.
//  Copyright © 2016 Sharon Colin. All rights reserved.
//

#import "ViewController.h"
#import "WebViewController.h"
#import <CommonCrypto/CommonDigest.h> // pour le hash md5

@interface ViewController ()


@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // bloquer l'ecriture dans code = text view
    
    _code.editable = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (IBAction)search:(id)sender {

// on verifie l url = correct
    // creation cache
    // verifie si le cache existe
        // on verifie si il a + 7 jours
            // on le supprime
        // lecture html
    // cache existe pas
        // lecture html
        // ecriture dans cache
// si url non valid : message erreur

    
NSString *urlcomplete = self.url.text;
NSURL *urlvalid = [NSURL URLWithString: urlcomplete];
if (urlvalid && urlvalid.scheme && urlvalid.host) {
    NSURLSession * session = [NSURLSession sharedSession];
    NSURLSessionDataTask * task = [session dataTaskWithURL: urlvalid completionHandler:^(NSData * _Nullable data,NSURLResponse *_Nullable response, NSError * _Nullable error) {
        NSDictionary *dictio = [(NSHTTPURLResponse*)response allHeaderFields];
        NSLog(@"%@",dictio);
        if([dictio[@"Content-Type"] hasPrefix:@"image/"]){
            // recuperer la value de mon dictionnaire et l 'affichere dans un uiImage
            NSData *nomImage = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:urlcomplete]];
            _image.image = [UIImage imageWithData:nomImage];
            NSLog(@"%@",nomImage);
            NSLog(@"je suis dans l'image");
            
        } else {
           // afficher tout le code du dessou concerant html
            NSLog(@"date : %@ : %@", [NSDate new], data);
            NSString * html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (html.length > 0) {
                dispatch_async(dispatch_get_main_queue(),^ {
                    // creation du cache
                    NSFileManager* cache = [NSFileManager defaultManager];
                    NSUInteger hash = [urlcomplete hash]; //[self generateMD5:urlcomplete];
                    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
                    NSString *chemin = [path objectAtIndex:0];
                    NSString *slash = @"/";
                    NSString *fichier = [NSString stringWithFormat:@"%@%@%lu", chemin, slash, (unsigned long)hash];
                    //gestion date
                    NSDictionary* attrs = [cache attributesOfItemAtPath:fichier error:nil];
                    NSDate *datefichier = [attrs objectForKey:NSFileCreationDate];
                    NSDate *date = [NSDate date];
                    NSTimeInterval diff = [datefichier timeIntervalSinceDate: date];
                    int nombreJour = diff/86400;
                    //verification cas : cache exist + date
                    if ([cache fileExistsAtPath:fichier] && (nombreJour>=7)) {
                        [cache removeItemAtPath:fichier error:nil];
                        [cache createFileAtPath:fichier contents:nil attributes:nil];
                        NSLog(@"fichier ecraser");
                    } else if ([cache fileExistsAtPath:fichier] && (nombreJour<7)) {
                        NSString *contents = [[NSString alloc] initWithContentsOfFile:fichier encoding: NSUTF8StringEncoding error:nil];
                        _code.text = contents;
                        NSLog(@"lecture du cache");
                    } else{
                        _code.text = html;
                        [cache createFileAtPath:fichier contents:nil attributes:nil];
                        [html writeToFile:fichier atomically:YES encoding:NSUTF8StringEncoding error:nil];
                        NSLog(@"ecriture dans cache");
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(),^ {
                    _code.text = @" Le code html est vide ";
                });
            }
        }
        
    }];
    [task resume];
} else {
    _code.text = @" Veuillez écrire une URL correcte ";
}
}

// generer un mdr5 http://www.dolphincomputers.in/generating-md5-hash-in-objective-c/
//- (NSString *) generateMD5:(NSString *) input
//{
//    const char *cStr = [input UTF8String];
//    unsigned char digest[16];
//    CC_MD5( cStr, strlen(cStr), digest );
//    
//    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
//    
//    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
//        [output appendFormat:@"%02x", digest[i]];
//    
//    return  output;
//}

- (IBAction)btnWeb:(id)sender {
    // liaison vers la deuxième view
    NSString *urlcomplete = self.url.text;
    NSURL *urlvalid = [NSURL URLWithString: urlcomplete];
    if (urlvalid && urlvalid.scheme && urlvalid.host) {
        NSURLSession * session = [NSURLSession sharedSession];
        NSURLSessionDataTask * task = [session dataTaskWithURL: urlvalid completionHandler:^(NSData * _Nullable data,NSURLResponse *_Nullable response, NSError * _Nullable error) {
            NSLog(@"date : %@ : %@", [NSDate new], data);
            NSString * html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if (html.length>0) {
                dispatch_async(dispatch_get_main_queue(),^ {
                    WebViewController *wvc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebView"];
                    wvc.urlLoad = urlcomplete;
                    [self.navigationController pushViewController:wvc animated:YES];
                });
            } else {
                dispatch_async(dispatch_get_main_queue(),^ {
                    _code.text = @" Le code html est vide ";
                });
            }
        }];
        [task resume];
    } else {
        _code.text = @" Veuillez écrire une URL correcte ";
    }

}

@end
