//
//  mainImageView.m
//  itgirl
//
//  Created by gnamit on 10/22/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import "mainImageView.h"
#import "itgirlconstants.h"
@interface mainImageView ()

@end

@implementation mainImageView
@synthesize btnImageView =_btnImageView, bgImage;
@synthesize delegate;
@synthesize picKey;
@synthesize mainImageViewer;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [mainImageViewer setImage:bgImage];
//    [_btnImageView setImage:bgImage forState:UIControlStateNormal];
    if([delegate respondsToSelector:@selector(viewLoaded:)]){
        [delegate viewLoaded:self];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_btnImageView release];
    [picKey release];
    [mainImageViewer release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setBtnImageView:nil];
    [picKey release];
    picKey=nil;
    [mainImageViewer release];
    mainImageViewer = nil;
    [super viewDidUnload];

}
-(void)setImageForButton:(UIImage*)newimage{
    if(mainImageViewer){
        [mainImageViewer setImage:bgImage];
    }
        bgImage=newimage;
}
- (IBAction)tappedImage:(id)sender {
    int tag = ((UIButton*)sender).tag;
 
    if ([delegate respondsToSelector:@selector(expandImage:)]){
        [delegate expandImage:[NSString stringWithFormat:@"%i",tag] ];
    }
    if(tag != kControlViewBtn){
        [UIView animateWithDuration:1.0f animations:^{
        [self.view setFrame:CGRectMake(0, 0, 320, 480)];
        [_btnImageView setFrame:CGRectMake(0, 0, 320, 480)];
            [mainImageViewer setFrame:CGRectMake(0, 0, 320, 480)];
    }completion:^(BOOL finished){
      //  if ([delegate respondsToSelector:@selector(expandImage:)]){
       //     [delegate expandImage:[NSString stringWithFormat:@"%i",tag] ];
       // }
    }];
        }
}
@end
