//
//  ViewController.m
//  itgirl
//
//  Created by gnamit on 10/13/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import "ViewController.h"
#import "itgirlconstants.h"
@interface ViewController ()

@end

@implementation ViewController


#pragma mark -
#pragma mark mainImageView Delegate methods
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
-(void)expandImage:(NSString *)imageTag{
    
    if([imageTag intValue] != kControlViewBtn){
        mainImageView *thisview = [[imagePreviews objectForKey:imageTag] retain];
        [thisview.view removeFromSuperview];
        [bgScrollView addSubview:thisview.view];
        [imagePreviews removeObjectForKey:imageTag];
        thisview.view.frame = currentView.view.frame;
        if(currentView){
            [currentView release];
            currentView=nil;
        }
        currentView=thisview;
        currentView.btnImageView.tag=kControlViewBtn;
        currentView.btnImageView.enabled=NO;
        [self hideControls];
    }
    NSMutableDictionary *todaysgirl = [delegate.ds.userSelections objectForKey:currentGirlKey];
    [todaysgirl setValue:currentView.picKey forKey:@"mainimage"];
    
    
}
#pragma mark -
#pragma mark display current girl and fill up scrollview
-(void)renderMetaInfo:(NSDictionary*)todaysgirl{
    [mainTitle setText:[todaysgirl objectForKey:@"location"]];
    mainTitle.text = [mainTitle.text uppercaseString];
    [noBtnCityName setText:mainTitle.text];

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
    NSString *picKey;
    if ([todaysgirl objectForKey:@"mainimage"]){
        picKey = [todaysgirl objectForKey:@"mainimage"];
//        [thisView setImageForButton:[delegate.ds loadImage:[todaysgirl objectForKey:@"mainimage"]]];
        thisView.picKey = [todaysgirl objectForKey:@"mainimage"];
    }
    else{
        NSArray *girlpics = [todaysgirl objectForKey:@"girlpics"];

        if ([girlpics count] >0){
            picKey = [girlpics objectAtIndex:0];
//            [thisView setImageForButton:[delegate.ds loadImage:[girlpics objectAtIndex:0]]];
            [todaysgirl setValue:[girlpics objectAtIndex:0] forKey:@"mainimage"];
            thisView.picKey = [todaysgirl objectForKey:@"mainimage"];
        }
        else{
            [NSException raise:@"Illegal girl" format:@"No image stored for todays it girl"];
        }
    }
    NSOperationQueue *queue = [NSOperationQueue new];
    
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:delegate.ds
                                        selector:@selector(loadImageIntoMorePicImages:)
                                        object:[NSArray arrayWithObjects:picKey,thisView, nil]];
    [queue addOperation:operation];
    [operation release];

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
    if([delegate.ds.favorites containsObject:todaysgirl]){
        [addToFavs setImage:[UIImage imageNamed:@"heartred.png"] forState:UIControlStateNormal];
        
    }
    else{
        [addToFavs setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];

    }
    //currentGirlKey will keep track of who is the current girl in our user selection dictionary. There's also the index that we can iterate through but for now lets keep both
    
    NSArray *girlpics = [todaysgirl objectForKey:@"girlpics"];
    if([girlpics count] <2){
        morePicsView.hidden=YES;
    }
    else{
        morePicsView.hidden=NO;
    }
    //only display more pics if there are more pics
    //the meta info like age name etc is only for the current girl. Need to figure out how to deal with formatting for longer names
    [self renderMetaInfo:todaysgirl];
    //doesn't need to be done everytime but whatevs
    [bgScrollView setContentSize:CGSizeMake(960, 480)];
    
    //Load current view
    if(!currentView)/*{
        [currentView.view removeFromSuperview];
        
        [currentView release];
        currentView=nil;
    }*/
        currentView = [[mainImageView alloc] initWithNibName:@"mainImageView" bundle:nil];
    [self loadImageView:currentView withGirl:todaysgirl withFrame:CGRectMake(320, 0, 320, 480)];
    
    //Load previous girl
    int prevgirlindex = currentGirlIndex-1;
    if (currentGirlIndex ==0){
        prevgirlindex = [[delegate.ds girls] count]-1;
    }
    NSMutableDictionary *yestgirl = [self getGirl:prevgirlindex ];
    if(!prevView)/*{
        [prevView.view removeFromSuperview];
        
        [prevView release];
        prevView=nil;
    }*/
        prevView = [[mainImageView alloc] initWithNibName:@"mainImageView" bundle:nil];
    [self loadImageView:prevView withGirl:yestgirl withFrame:CGRectMake(0, 0, 320, 480)];

    //load next girl
    int nextgirlindex = currentGirlIndex+1;
    if (nextgirlindex >=[[[delegate ds] girls] count]){
        nextgirlindex =0;
    }
    NSMutableDictionary *nextgirl = [self getGirl:nextgirlindex ];
    if(!nextView)/*{
        [nextView.view removeFromSuperview];
        
        [nextView release];
        nextView=nil;
    }*/
        nextView = [[mainImageView alloc] initWithNibName:@"mainImageView" bundle:nil];
    [self loadImageView:nextView withGirl:nextgirl withFrame:CGRectMake(640, 0, 320, 480)];
    //Make sure control view is always int he front
    [self.view bringSubviewToFront:controlView];
}
-(void)imagesLoadedMoveTheScroller{
    [bgScrollView setContentOffset:CGPointMake(320, 0)];

}
#pragma mark -
#pragma mark inital load methods
-(void)finishedloading{
    currentGirlIndex = [[[delegate ds] girls] count]-1;
    [self loadCurrentIndex];
}
-(void)dismissAlerter{
    [alerter dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)loadStuff{
    //This method loads up the data from the server and then loads the latest girl as per our query. I believe this should call delegate load and finish first before going down to dismiss the alertview. Assuming it loads successfully it will call finishedloading to display our data. Should implement something for when it doesnt work.
    delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate load]){
        [self performSelectorOnMainThread:@selector(finishedloading) withObject:nil waitUntilDone:NO];
    }
    [self performSelectorOnMainThread:@selector(dismissAlerter) withObject:nil waitUntilDone:NO];
}

//unused but i think it will come up again...
-(void)showTodaysGirl{
    currentGirlIndex = [[[delegate ds] girls] count]-1;
    [self loadCurrentIndex];
    controlView.hidden=TRUE;
}

#pragma mark -
#pragma mark control screen handling
-(NSInteger)heightForMorPics{
    return ([[[delegate.ds.girls objectAtIndex:currentGirlIndex] objectForKey:@"girlpics"] count] -1)* 90;
}
-(void)bringThisViewToFront:(NSNotification*)note{
    UIView *viewer = (UIView*)[note object];
    if ([viewer class] == [UIView class])
        [self.view bringSubviewToFront:viewer];
}
-(void)hideControls{
    //Wanted to avoid this method but seems like I need to hide everything without animating it for the expanding image
    controlView.alpha=0.0f;
    controlView.hidden=TRUE;
    [self.view bringSubviewToFront:controlView];
    
    nameView.hidden=NO;
    moreShown=FALSE;
    int height = [self heightForMorPics];
    nameView.alpha=1.0f;
    CGRect frame = morePicsBg.frame;
    frame.size.height= frame.size.height-height;
    morePicsBg.frame=frame;
    for (NSString *keyval  in imagePreviews){
        mainImageView *iView = [imagePreviews objectForKey:keyval];
        
        [iView.view removeFromSuperview];
    }
    [imagePreviews removeAllObjects];
    [imagePreviews release];
    imagePreviews = nil;


}
- (IBAction)displayControls:(id)sender {
    //If we are dismissing and more pics are shown click that to dismiss it first
    if(moreShown)
        [self showMorePics];
    
    if (controlView.hidden){
        controlView.hidden=FALSE;
        [UIView animateWithDuration:0.2f animations:^{
            controlView.alpha=1.0f;
        }completion:^(BOOL finished){}];
    }
    else{
        
        [UIView animateWithDuration:0.2f animations:^{
            controlView.alpha=0.0f;
        }completion:^(BOOL finished){
            controlView.hidden=TRUE;
            [self.view bringSubviewToFront:controlView];
        }];
    }
    
}
//Just scorll over to the next or previous girl. The scroll view delegate handles updating it so it recenters and you can keep scrolling infinitely
-(void)showNextGirl{
    if(moreShown)
        [self showMorePics];

    [bgScrollView setContentOffset:CGPointMake(640, 0) animated:YES];

}
-(void)showPreviousGirl{
    if(moreShown)
        [self showMorePics];

    [bgScrollView setContentOffset:CGPointMake(0, 0) animated:YES];

}
-(void)showMorePics{
    if(moreShown){
        nameView.hidden=NO;
        //name view is the view with all the extra info in it. we hide it when showing the girl pics
        [UIView animateWithDuration:0.3f animations:^{
            int height = [self heightForMorPics];

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
        NSOperationQueue *queue = [NSOperationQueue new];

        for (NSString *pic in pics){
            if (![[todaysgirl objectForKey:@"mainimage"] isEqualToString:pic]){
                mainImageView *previewView = [[[mainImageView alloc] initWithNibName:@"mainImageView" bundle:nil] autorelease];
                
                previewView.delegate=self;

                NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                                    initWithTarget:delegate.ds
                                                    selector:@selector(loadImageIntoMorePicImages:)
                                                    object:[NSArray arrayWithObjects:pic,previewView, nil]];
                [queue addOperation:operation];
                [operation release];

                //[self performSelectorInBackground:@selector(loadImageIntoMorePicImages:) withObject:];
                CGRect frame = previewView.view.frame;
                
                //whoo magic math. this layout is still chanign so leaving in the magic for now
                frame.origin.x = morePicsView.frame.origin.x+ morePicsBtn.frame.origin.x+20.0f;
                frame.origin.y = morePicsView.frame.origin.y+morePicsBtn.frame.origin.y+80*count+50.0f+count*10.0f;
                previewView.view.alpha=0.0f;
                previewView.view.frame=frame;
                previewView.picKey=pic;
                count++;
                previewView.btnImageView.tag = count+kImagesOffset;
                [imagePreviews setValue:previewView forKey:[NSString stringWithFormat:@"%i", count+kImagesOffset]];
                [self.view addSubview:previewView.view];
                
            }
        }
        [UIView animateWithDuration:0.3f animations:^{
            nameView.alpha=0;
            CGRect frame = morePicsBg.frame;
            int height = [self heightForMorPics];
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
-(void) addToFavorites{
    NSMutableDictionary *thegirl = [delegate.ds.userSelections objectForKey:currentGirlKey];
    NSMutableArray *favs = [delegate.ds favorites];
    if ([favs containsObject:thegirl]){
        [favs removeObject:thegirl];
        [addToFavs setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    }
    else{
        [favs addObject:thegirl];
        [addToFavs setImage:[UIImage imageNamed:@"heartred.png"] forState:UIControlStateNormal];
    }
}
-(void)showFavorites{
    if(!favViews){
    favViews = [[favViewController alloc] initWithNibName:@"favViewController" bundle:nil];
    favViews.view.frame = CGRectMake(0, -430, favViews.view.frame.size.width, 430);
    [self.view addSubview:favViews.view];
    [UIView animateWithDuration:0.6f animations:^{
        CGRect frame = favViews.view.frame;
        frame.origin = CGPointZero;
        favViews.view.frame=frame;
    }];
    }
    else{
        [UIView animateWithDuration:0.6f animations:^{
            favViews.view.frame = CGRectMake(0, -430, favViews.view.frame.size.width, 430);
 
        }completion:^(BOOL finished){
            [favViews.view removeFromSuperview];
            [favViews release];
            favViews=nil;
        }];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    moreShown=FALSE;
    currentGirlKey=nil;
    controlView.alpha=0.0f;
    currentGirlIndex=-1;
    delegate = [[UIApplication sharedApplication] delegate];
    //Alert view with loading indic. I really shoudl subclass this or something
    alerter = [[[UIAlertView alloc] initWithTitle:@"Loading" message:@"Loading Provider Information" delegate:self cancelButtonTitle:nil otherButtonTitles: nil]  autorelease];
    UIActivityIndicatorView *loading = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    [loading setFrame:CGRectMake(125,90,30,30)];
    [loading startAnimating];
    [alerter addSubview:loading];
    [alerter show];
    [prevGirl addTarget:self action:@selector(showPreviousGirl) forControlEvents:UIControlEventTouchUpInside];
    [nextGirl addTarget:self action:@selector(showNextGirl) forControlEvents:UIControlEventTouchUpInside];
    [addToFavs addTarget:self action:@selector(addToFavorites) forControlEvents:UIControlEventTouchUpInside];
    [showFavs addTarget:self action:@selector(showFavorites) forControlEvents:UIControlEventTouchUpInside];
 //   [shareGirl addTarget:self action:@selector(shareKitHndle) forControlEvents:UIControlEventTouchUpInside];
    [morePicsBtn addTarget:self action:@selector(showMorePics) forControlEvents:UIControlEventTouchUpInside];
    UITapGestureRecognizer *tapGesture = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(displayControls:)] autorelease];
    tapGesture.delegate=self;
    tapGesture.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tapGesture];
    [self performSelectorInBackground:@selector(loadStuff) withObject:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(bringThisViewToFront:) name:@"BringToFront" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imagesLoadedMoveTheScroller) name:@"ImageLoadedIntoView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadGirlFromKey:) name:@"loadFavGirlIntoPage" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showFavorites) name:@"favoritesScreenTapped" object:nil];
	// Do any additional setup after loading the view, typically from a nib.
}
#pragma mark Scroll View Delegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //Infininte scrolling
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
        if (currentGirlIndex < 0)
            currentGirlIndex=[[[delegate ds] girls] count]-1;
        else if(currentGirlIndex >= [[[delegate ds] girls] count])
            currentGirlIndex=0;
        [self loadCurrentIndex];
    }
}
-(void)loadGirlFromKey:(NSNotification*)thenote{
    [UIView animateWithDuration:0.6f animations:^{
        favViews.view.frame = CGRectMake(0, -430, favViews.view.frame.size.width, 430);
        
    }completion:^(BOOL finished){
        [favViews.view removeFromSuperview];
        [favViews release];
        favViews=nil;
    }];

    NSString *newGirlKey = [thenote object];
   // NSMutableDictionary *todaysgirl = [delegate.ds.userSelections objectForKey:newGirlKey];
    int newindex= 0;

    for (newindex =0; newindex < [delegate.ds.girls count]; newindex++){
        if ([newGirlKey intValue] == [[[delegate.ds.girls objectAtIndex:newindex] objectForKey:@"id"] intValue])
            break;
    }
    currentGirlIndex = newindex;
    [self loadCurrentIndex];

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
    [showFavs release];
    [noBtnCityName release];
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
    [showFavs release];
    showFavs = nil;
    [noBtnCityName release];
    noBtnCityName = nil;
    [super viewDidUnload];
}
@end
