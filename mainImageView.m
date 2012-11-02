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
@synthesize favView;
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
//Tells our main VC that this view is loaded and the image is appropriately set (assuming one was set)
    if([delegate respondsToSelector:@selector(viewLoaded:)]){
        [delegate viewLoaded:self];
    }
    favView = false;
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
    //sets the image if the imageview object exists
    bgImage=newimage;

    if(mainImageViewer){
        [mainImageViewer setImage:bgImage];
    }
}
- (IBAction)tappedImage:(id)sender {
    // The button is clear and sits on top of the image. This is because I want it disabled and not interfering with my scrollview or tapgestures when its maximized only in preview mode. The delegate will take care of disabling this. kControlViewBtn just lets us know its the main view now.
    int tag = ((UIButton*)sender).tag;

    if (!favView){
    //This note is a little hacky. but in case there are multiple preview images wehn it expands i want it to be on top. will adjust for the proper heirarchy in the delegate method when it rejoins the scrollview class
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BringToFront" object:self.view];
    if(tag != kControlViewBtn){
        [UIView animateWithDuration:.6f animations:^{
            [self.view setFrame:CGRectMake(0, 0, 320, 480)];
            [_btnImageView setFrame:CGRectMake(0, 0, 320, 480)];
            [mainImageViewer setFrame:CGRectMake(0, 0, 320, 480)];
        }completion:^(BOOL finished){
            if ([delegate respondsToSelector:@selector(expandImage:)]){
                [delegate expandImage:[NSString stringWithFormat:@"%i",tag] ];
            }

                   }];
    }
    }
    else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loadFavGirlIntoPage" object:[NSString stringWithFormat:@"%i", tag]];
    }

}
@end
