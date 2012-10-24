//
//  ViewController.h
//  itgirl
//
//  Created by gnamit on 10/13/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SHK.h"
#import "bonvenoLabel.h"
#import "mainImageView.h"
@interface ViewController : UIViewController<UIGestureRecognizerDelegate, imageDelegate, UIScrollViewDelegate>
{
    IBOutlet UIView *nameView;
    UIAlertView *alerter;
    AppDelegate *delegate;
    IBOutlet UIImageView *mainPic;
    IBOutlet UIView *controlView;

    IBOutlet UIButton *shareGirl;
    IBOutlet UIButton *prevGirl;
    IBOutlet UILabel *labelFactoid;
    IBOutlet UILabel *labelAge;
    IBOutlet UILabel *labelethnicity;
    IBOutlet UILabel *mainTitle;
    IBOutlet UIButton *addToFavs;
    int currentGirlIndex;
    NSObject *currentGirlKey;
    IBOutlet UIButton *nextGirl;
    IBOutlet bonvenoLabel *nameLabel;
    IBOutlet UIButton *morePicsBtn;
    IBOutlet UIImageView *morePicsBg;
    IBOutlet UIView *morePicsView;
    NSMutableDictionary *imagePreviews;
    BOOL moreShown;
    mainImageView *currentView;
    mainImageView *prevView;
    mainImageView *nextView;

    IBOutlet UIScrollView *bgScrollView;
}
- (IBAction)displayControls:(id)sender;

@end
