//
//  favViewController.m
//  itgirl
//
//  Created by gnamit on 11/1/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import "favViewController.h"
#import "AppDelegate.h"
#import "mainImageView.h"
@interface favViewController ()

@end

@implementation favViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)scrollViewTapped{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"favoritesScreenTapped" object:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    NSMutableArray *favs = delegate.ds.favorites;
    [mainScrollView setContentSize:CGSizeMake(320, 380*(1+[favs count]/10))];
    int x=0;
    int y=0;
    scrollViewBGButton.frame = CGRectMake(0, 0, 320, mainScrollView.frame.size.height);
    [scrollViewBGButton addTarget:self action:@selector(scrollViewTapped) forControlEvents:UIControlEventTouchUpInside];
    NSOperationQueue *queue = [NSOperationQueue new];
    mainImageViews = [[NSMutableArray alloc] init];
    for (NSMutableDictionary *thegirl in favs){
        mainImageView *newfav = [[[mainImageView alloc] initWithNibName:@"mainImageView" bundle:nil] autorelease];
        [mainImageViews addObject:newfav];
        CGRect frame = newfav.view.frame;
        frame.origin = CGPointMake(x, y);
        newfav.view.frame=frame;
        NSLog(@"setting the fav pic at frame %@", NSStringFromCGRect(frame));
        x = x+163;
        if (x >=320){
            x=0;
            y=y+85;
        }
        
        NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                            initWithTarget:delegate.ds
                                            selector:@selector(loadImageIntoMorePicImages:)
                                            object:[NSArray arrayWithObjects:[thegirl objectForKey:@"mainimage"],newfav, nil]];
        [queue addOperation:operation];
        [operation release];

        newfav.favView=TRUE;
        newfav.btnImageView.tag = [[thegirl objectForKey:@"id"] intValue];
        [mainScrollView addSubview:newfav.view];
    }

    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [mainImageViews removeAllObjects];
    [mainImageViews release];
    mainImageViews=nil;
    [mainScrollView release];
    [scrollViewBGButton release];
    [super dealloc];
}
- (void)viewDidUnload {
    [mainImageViews removeAllObjects];
    [mainImageViews release];
    mainImageViews=nil;
    [mainScrollView release];
    mainScrollView = nil;
    [scrollViewBGButton release];
    scrollViewBGButton = nil;
    [super viewDidUnload];
}
@end
