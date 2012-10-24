//
//  ViewController.m
//  itgirl
//
//  Created by gnamit on 10/13/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import "ViewController.h"
#import "itgirlconstants.h"
@implementation UIImage (Extras)

#pragma mark -
#pragma mark Scale and crop image

- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
        {
            scaleFactor = widthFactor; // scale to fit height
        }
        else
        {
            scaleFactor = heightFactor; // scale to fit width
        }
        
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
        {
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil)
    {
        NSLog(@"could not scale image");
    }
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
@interface ViewController ()

@end

@implementation ViewController
-(void)dismissAlerter{
    [alerter dismissWithClickedButtonIndex:0 animated:YES];

}
-(void)viewLoaded:(NSObject *)thisView{
    mainImageView *curview = (mainImageView*)thisView;
    if (thisView == currentView || thisView==prevView || thisView==nextView){
        
        curview.btnImageView.frame=CGRectMake(0, 0, 320, 480);
        curview.mainImageViewer.frame = CGRectMake(0, 0, 320, 480);
        curview.btnImageView.enabled=FALSE;
        curview.btnImageView.tag=kControlViewBtn;

        curview.btnImageView.alpha=0.0f;
    }
}
-(void)renderMetaInfo:(NSDictionary*)todaysgirl{
    [mainTitle setText:[todaysgirl objectForKey:@"location"]];
    mainTitle.text = [mainTitle.text uppercaseString];
    [mainTitle sizeToFit];
    //    [mainTitle setText:[NSString stringWithFormat:@"%@ %@ from %@", [todaysgirl objectForKey:@"fname"],[todaysgirl objectForKey:@"lname"], [todaysgirl objectForKey:@"location"] ]];
    [nameLabel setText:[NSString stringWithFormat:@"%@ %@", [todaysgirl objectForKey:@"fname"],[todaysgirl objectForKey:@"lname"]] ];
    nameLabel.text = [nameLabel.text uppercaseString];
    [labelAge setText:[NSString stringWithFormat:@"%@", [todaysgirl objectForKey:@"age"]]];
    [labelethnicity setText:[NSString stringWithFormat:@"%@", [todaysgirl objectForKey:@"ethnicity"]]];
    [labelFactoid setText:[NSString stringWithFormat:@"%@", [todaysgirl objectForKey:@"factoid"]]];
    NSLog(@"name frame %@", NSStringFromCGRect(nameLabel.frame));
    [nameLabel sizeToFit];
    NSLog(@"name frame autofit %@", NSStringFromCGRect(nameLabel.frame));
    NSLog(@"label Age %@", NSStringFromCGRect(labelAge.frame));
    
    [labelAge sizeToFit];
    NSLog(@"label Age autofit %@", NSStringFromCGRect(labelAge.frame));
    
    CGRect frame = labelAge.frame;
    frame.origin.x = nameLabel.frame.origin.x;
    frame.origin.y = nameLabel.frame.origin.y+nameLabel.frame.size.height + 5.0f;
    labelAge.frame= frame;
    NSLog(@"label Age manual fit %@", NSStringFromCGRect(labelAge.frame));
    
    [labelethnicity sizeToFit];
    frame = labelethnicity.frame;
    frame.origin.x = labelAge.frame.origin.x;
    frame.origin.y = labelAge.frame.origin.y+labelAge.frame.size.height + 5.0f;
    labelethnicity.frame= frame;
    [labelFactoid sizeToFit];
    frame = labelFactoid.frame;
    frame.origin.x = labelethnicity.frame.origin.x;
    frame.origin.y = labelethnicity.frame.origin.y+labelethnicity.frame.size.height + 5.0f;
    labelFactoid.frame= frame;

}
-(void)loadImageForGirl:(NSDictionary*)todaysgirl intoView:(mainImageView *)thisView{
    NSArray *girlpics = [todaysgirl objectForKey:@"girlpics"];

    if ([todaysgirl objectForKey:@"mainimage"]){
        [thisView setImageForButton:[delegate.ds loadImage:[todaysgirl objectForKey:@"mainimage"]]];
        thisView.picKey = [todaysgirl objectForKey:@"mainimage"];
    }
    //            [mainPic setImage:[delegate.ds loadImage:[todaysgirl objectForKey:@"mainimage"]]];
    else{
        if ([girlpics count] >0){
            [thisView setImageForButton:[delegate.ds loadImage:[girlpics objectAtIndex:0]]];
            [todaysgirl setValue:[girlpics objectAtIndex:0] forKey:@"mainimage"];
            thisView.picKey = [todaysgirl objectForKey:@"mainimage"];
            
            //                [mainPic setImage:[girlpics objectAtIndex:0]];
        }
        else{
            [NSException raise:@"Illegal girl" format:@"No image stored for todays it girl"];
        }
    }
    thisView.delegate=self;
    [thisView viewDidLoad];

}
-(void)loadImageView:(mainImageView*)thisView withGirl:(NSDictionary*)thisgirl withFrame:(CGRect)frame{
        
    thisView.view.frame=frame;
    [self loadImageForGirl:thisgirl intoView:thisView];
    [bgScrollView addSubview:thisView.view];
    thisView.delegate=self;

}

-(NSMutableDictionary*)getGirl:(NSInteger)girlIndex{
    NSMutableDictionary *thegirl = [[[delegate ds] girls] objectAtIndex:girlIndex];
    if(![delegate.ds.userSelections objectForKey:[thegirl objectForKey:@"id"]])
        [delegate.ds.userSelections setValue:thegirl forKey:[thegirl objectForKey:@"id"]];
    else{
        thegirl = [delegate.ds.userSelections objectForKey:[thegirl objectForKey:@"id"]];
    }

    return thegirl;
}
-(void)loadCurrentIndex{
        NSMutableDictionary *todaysgirl = [self getGirl:currentGirlIndex];
    if(currentGirlKey){
        [currentGirlKey release];
        currentGirlKey=nil;
    }
    currentGirlKey = [[todaysgirl objectForKey:@"id"] retain];

    [self renderMetaInfo:todaysgirl];
    
    [bgScrollView setContentSize:CGSizeMake(960, 480)];

    [bgScrollView setContentOffset:CGPointMake(320, 0)];
    if(currentView){
        [currentView.view removeFromSuperview];
        
        [currentView release];
        currentView=nil;
    }
    currentView = [[mainImageView alloc] initWithNibName:@"mainImageView" bundle:nil];

    [self loadImageView:currentView withGirl:todaysgirl withFrame:CGRectMake(320, 0, 320, 480)];
    
//    [self.view addSubview:currentView.view];
    NSArray *girlpics = [todaysgirl objectForKey:@"girlpics"];
    if([girlpics count] <2){
        morePicsView.hidden=YES;
    }
    else{
        morePicsView.hidden=NO;
    }
    
    int prevgirlindex = currentGirlIndex-1;
    if (currentGirlIndex ==0){
        prevgirlindex = [[delegate.ds girls] count]-1;
        
    }
    
    NSMutableDictionary *yestgirl = [self getGirl:prevgirlindex ];
    if(prevView){
        [prevView.view removeFromSuperview];
        
        [prevView release];
        prevView=nil;
    }
    prevView = [[mainImageView alloc] initWithNibName:@"mainImageView" bundle:nil];

    [self loadImageView:prevView withGirl:yestgirl withFrame:CGRectMake(0, 0, 320, 480)];

    
    int nextgirlindex = currentGirlIndex+1;
    if (nextgirlindex >=[[[delegate ds] girls] count]){
        nextgirlindex =0;
        
    }
    
    NSMutableDictionary *nextgirl = [self getGirl:nextgirlindex ];
    if(nextView){
        [nextView.view removeFromSuperview];
        
        [nextView release];
        nextView=nil;
    }
    nextView = [[mainImageView alloc] initWithNibName:@"mainImageView" bundle:nil];
    
    [self loadImageView:nextView withGirl:nextgirl withFrame:CGRectMake(640, 0, 320, 480)];

    
    //Make sure control view is always int he front
    [self.view bringSubviewToFront:controlView];
/*
    [UIView animateWithDuration:0.5f animations:^{
            currentView.btnImageView.alpha=1.0f;
            prevView.btnImageView.alpha=1.0f;
        }];
 */
    

}
-(void)finishedloading{
    currentGirlIndex = [[[delegate ds] girls] count]-1;
    [self loadCurrentIndex];
    [self.view bringSubviewToFront:controlView];
}
-(void)loadStuff{
    //This method loads up the data from the server and then loads the latest girl as per our query
    delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate load]){
        [self performSelectorOnMainThread:@selector(finishedloading) withObject:nil waitUntilDone:NO];
    }
    [delegate.ds performSelectorInBackground:@selector(storeFutureInfo) withObject:nil];
    [self performSelectorOnMainThread:@selector(dismissAlerter) withObject:nil waitUntilDone:NO];
}
-(void)showTodaysGirl{
    currentGirlIndex = [[[delegate ds] girls] count]-1;
    [self loadCurrentIndex];
    controlView.hidden=TRUE;

}
- (IBAction)displayControls:(id)sender {
    if(moreShown)
        [self showMorePics];
    if (controlView.hidden){
        controlView.hidden=FALSE;
        [UIView animateWithDuration:0.6f animations:^{
            controlView.alpha=1.0f;
        }completion:^(BOOL finished){}];
    }
    else{
        
        [UIView animateWithDuration:0.6f animations:^{
            controlView.alpha=0.0f;
        }completion:^(BOOL finished){
            controlView.hidden=TRUE;
            [self.view bringSubviewToFront:controlView];
        }];
    }
    
}

-(void)showNextGirl{
    [bgScrollView setContentOffset:CGPointMake(640, 0) animated:YES];

}
-(void)showPreviousGirl{
    [bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}
- (UIImage*)imageWithImage:(UIImage*)image
              scaledToSize:(CGSize)newSize;
{
    UIGraphicsBeginImageContext( newSize );
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
-(void)expandImage:(NSString *)imageTag{
    
    if([imageTag intValue] == kControlViewBtn){
        [self displayControls:nil];
    }
    else{
    mainImageView *thisview = [[imagePreviews objectForKey:imageTag] retain];
        [self.view bringSubviewToFront:thisview.view];
    [imagePreviews removeObjectForKey:imageTag];
        if(currentView){
            [currentView release];
            currentView=nil;
        }
        currentView=thisview;
        currentView.btnImageView.tag=kControlViewBtn;
        [self displayControls:nil];
    }
    NSMutableDictionary *todaysgirl = [delegate.ds.userSelections objectForKey:currentGirlKey];
    [todaysgirl setValue:currentView.picKey forKey:@"mainimage"];
    
    
}
-(void)showMorePics{
    if(moreShown){
        nameView.hidden=NO;

        [UIView animateWithDuration:0.8f animations:^{
            int height = ([[[delegate.ds.girls objectAtIndex:currentGirlIndex] objectForKey:@"girlpics"] count] -1)* 75;

            nameView.alpha=1.0f;
            CGRect frame = morePicsBg.frame;
            
            frame.size.height= frame.size.height-height;
            morePicsBg.frame=frame;
            for (NSString *keyval in imagePreviews){
                mainImageView *iView = [imagePreviews objectForKey:keyval];
                iView.view.alpha=0.0f;
            }

            
        }completion:^(BOOL finished){
            for (NSString *keyval  in imagePreviews){
                mainImageView *iView = [imagePreviews objectForKey:keyval];

                [iView.view removeFromSuperview];
            }
            [imagePreviews removeAllObjects];
            [imagePreviews release];
            imagePreviews = nil;

        }];


    }
    else{
        NSArray *pics = [[delegate.ds.girls objectAtIndex:currentGirlIndex] objectForKey:@"girlpics"];
        NSDictionary *todaysgirl = [delegate.ds.userSelections objectForKey:currentGirlKey];
        imagePreviews = [[NSMutableDictionary alloc] init];
        int count =0 ;
        for (NSString *pic in pics){
            if (![[todaysgirl objectForKey:@"mainimage"] isEqualToString:pic]){
                mainImageView *previewView = [[[mainImageView alloc] initWithNibName:@"mainImageView" bundle:nil] autorelease];
                
                //UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 44)] autorelease];
                previewView.delegate=self;
                UIImage *newImage = [delegate.ds loadImage:pic];
                [previewView setImageForButton:newImage];
                CGRect frame = previewView.view.frame;
                frame.origin.x = morePicsView.frame.origin.x+ morePicsBtn.frame.origin.x+15.0f +23.0f;
                frame.origin.y = morePicsView.frame.origin.y+morePicsBtn.frame.origin.y+44*count+60.0f+count*20.0f;
                previewView.view.alpha=0.0f;
                previewView.view.frame=frame;
                previewView.picKey=pic;
                NSLog(@"frame is %@ and btn frame is %@", NSStringFromCGRect(previewView.view.frame), NSStringFromCGRect(previewView.btnImageView.frame));
                count++;
                previewView.btnImageView.tag = count+kImagesOffset;
                [imagePreviews setValue:previewView forKey:[NSString stringWithFormat:@"%i", count+kImagesOffset]];
//                [imagePreviews addObject:previewView];
                [self.view addSubview:previewView.view];
                
            }
        }
        [UIView animateWithDuration:0.8f animations:^{
            nameView.alpha=0;
            CGRect frame = morePicsBg.frame;
            int height = ([[[delegate.ds.girls objectAtIndex:currentGirlIndex] objectForKey:@"girlpics"] count] -1)* 75;
            for (NSString *key in imagePreviews){
                mainImageView *iView = [imagePreviews objectForKey:key];
                iView.view.alpha=1.0f;
            }
            frame.size.height= frame.size.height+height;
            morePicsBg.frame=frame;

            
        }completion:^(BOOL finished){
            nameView.hidden=YES;
        }];
    }
    moreShown=!moreShown;
}
- (void)shareKitHndle
{
	// Create the item to share (in this example, a url)
    SHKItem *img = [SHKItem image:mainPic.image title:mainTitle.text];
    
	// Get the ShareKit action sheet
	SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:img];
    
	// Display the action sheet
	[actionSheet showFromRect:CGRectMake(0, 0, 320, 44) inView:self.view animated:YES];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIControl class]] && (touch.view != currentView.btnImageView)) {
        // we touched a button, slider, or other UIControl
        return NO; // ignore the touch
    }
    return YES; // handle the touch
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    moreShown=FALSE;
    currentGirlKey=nil;
    controlView.alpha=0.0f;
    currentGirlIndex=-1;
    delegate = [[UIApplication sharedApplication] delegate];
    alerter = [[[UIAlertView alloc] initWithTitle:@"Loading" message:@"Loading Provider Information" delegate:self cancelButtonTitle:nil otherButtonTitles: nil]  autorelease];
    UIActivityIndicatorView *loading = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    [loading setFrame:CGRectMake(125,90,30,30)];
    [loading startAnimating];
    [alerter addSubview:loading];
    [alerter show];
    [prevGirl addTarget:self action:@selector(showPreviousGirl) forControlEvents:UIControlEventTouchUpInside];
    [nextGirl addTarget:self action:@selector(showNextGirl) forControlEvents:UIControlEventTouchUpInside];
    [shareGirl addTarget:self action:@selector(shareKitHndle) forControlEvents:UIControlEventTouchUpInside];
    [morePicsBtn addTarget:self action:@selector(showMorePics) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayControls:)] autorelease];
    tapGesture.delegate=self;
    tapGesture.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tapGesture];
    [self performSelectorInBackground:@selector(loadStuff) withObject:nil];

    
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int offset = scrollView.contentOffset.x;
    int page=0;
    switch (offset) {
        case 640:
            page++;
            break;
        case 320:
            break;
        case 0:
            page--;
            break;
        default:
            break;
    }
    if(page !=0){
        currentGirlIndex = currentGirlIndex+page;
        //wrap around
        NSLog(@"prev index is %i and count %i", currentGirlIndex, [[[delegate ds] girls] count]);
        if (currentGirlIndex < 0)
            currentGirlIndex=[[[delegate ds] girls] count]-1;
        else if(currentGirlIndex >= [[[delegate ds] girls] count])
            currentGirlIndex=0;
        NSLog(@"post index is %i and count %i", currentGirlIndex, [[[delegate ds] girls] count]);

        
        [self loadCurrentIndex];
    }
}
#pragma mark memory disposition stuff

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [mainPic release];
    [currentGirlKey release];
    [controlView release];
    [mainTitle release];
    [labelethnicity release];
    [labelAge release];
    [labelFactoid release];
    [addToFavs release];
    [prevGirl release];
    [shareGirl release];
    [nextGirl release];
    [nameLabel release];
    [morePicsBtn release];
    [morePicsBg release];
    [nameView release];
    [morePicsView release];
    [bgScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [currentGirlKey release];
    currentGirlKey=nil;
    [morePicsBtn release];
    morePicsBtn = nil;
    [morePicsBg release];
    morePicsBg = nil;
    [nameView release];
    nameView = nil;
    [morePicsView release];
    morePicsView = nil;
    [bgScrollView release];
    bgScrollView = nil;
    [super viewDidUnload];
}
@end
