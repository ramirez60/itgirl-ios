//
//  DataSingleton.m
//  itgirl
//
//  Created by gnamit on 10/13/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import "DataSingleton.h"
#import "itgirlconstants.h"
static DataSingleton *shared = NULL;

@implementation DataSingleton
@synthesize girls;
@synthesize userSelections;
+ (DataSingleton *)sharedSingleton
{
    
    if ( !shared || shared == NULL )
    {
        // allocate the shared instance, because it hasn't been done yet
        shared = [[DataSingleton alloc] init];
    }
    
    return shared;
	
}
-(BOOL)saveImage:(NSString *)fromPath{
    NSString* urlStr = [kServerURL stringByAppendingString:fromPath];
	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"%@", urlStr);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:fromPath];
    
    
	
    //  NSString *writableDBPath = [[NSBundle mainBundle] pathForResource:fromPath ofType:@"png"];
    NSData *imgfile;
    BOOL success = FALSE;

    if (![fileManager fileExistsAtPath:writableDBPath]){

	NSLog(@"%@", urlStr);
    NSError *error;


    NSURL* url = [NSURL URLWithString: urlStr];
    imgfile = [[NSData dataWithContentsOfURL:url] retain];
    if(imgfile != nil){
        if ([fileManager fileExistsAtPath:writableDBPath])
            [fileManager removeItemAtPath:writableDBPath error:&error];
        NSMutableArray *components = [[writableDBPath componentsSeparatedByString:@"/"] mutableCopy];
        [components removeLastObject];
        NSString *pathtomake = [components componentsJoinedByString:@"/"];
        
        [fileManager createDirectoryAtPath:pathtomake withIntermediateDirectories:YES attributes:nil error:&error];
        
        success = [fileManager createFileAtPath:writableDBPath contents:imgfile attributes:nil];
        if(success)
            NSLog(@"Image %@ downloaded", fromPath);
        else
            NSLog(@"Failing");
  
    }
    }
    else
        success=TRUE;
    return success;
    
}
-(UIImage *)loadImage:(NSString*)fromPath{
    UIImage *newimage;
    NSString* urlStr = [kServerURL stringByAppendingString:fromPath];
	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"%@", urlStr);
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:fromPath];
    
    
	
    //  NSString *writableDBPath = [[NSBundle mainBundle] pathForResource:fromPath ofType:@"png"];
    NSData *imgfile;
    if ([fileManager fileExistsAtPath:writableDBPath]){
        imgfile = [fileManager contentsAtPath:writableDBPath];
    }
    else{
        if( [self saveImage:fromPath]){
            if ([fileManager fileExistsAtPath:writableDBPath]){
                imgfile = [fileManager contentsAtPath:writableDBPath];
            }

        }
        else{
            NSLog(@"Cant save");
        }
        
    }
    
    
    newimage = [[UIImage alloc] initWithData:imgfile];
    return newimage;
}

-(void)storeFutureInfo{
    //Loads up the future girls after the girls up to today ahve been loaded. Separate method because this can be done in the background
    NSDate *today = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:today];
    [format release];
    
    FMResultSet *appset = [db executeQuery:[NSString stringWithFormat:@"SELECT * from core_itgirl where itgirldate <= '%@' order by itgirldate", dateString]];
    FMResultSet *imageset;
    while (appset && [appset next]){
        NSMutableDictionary *thisgirl = [[appset resultDict] mutableCopy];
        NSLog(@"Loading girl %@", thisgirl);
        int thisgirlid = [appset intForColumn:@"id"];
        imageset = [db executeQuery:@"SELECT * from core_girlimage where girlid_id == ?", [NSNumber numberWithInt:thisgirlid]];
        NSMutableArray  *images = [[NSMutableArray alloc] init];
        while (imageset && [imageset next]){
            NSString *pathForIcon = [imageset stringForColumn:@"image"];
            [self saveImage:pathForIcon];
            if ( [imageset boolForColumn:@"mainimage"]){
                [thisgirl setValue:pathForIcon forKey:@"mainimage"];
                
            }
                [images addObject:pathForIcon];
        }
        [thisgirl setValue:images forKey:@"girlpics"];
        
        [images release];
    }

}
-(void)loadData{
    NSDate *today = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [format stringFromDate:today];
    [format release];

    FMResultSet *appset = [db executeQuery:[NSString stringWithFormat:@"SELECT * from core_itgirl where itgirldate <= '%@' order by itgirldate", dateString]];
    FMResultSet *imageset;
    while (appset && [appset next]){
        NSMutableDictionary *thisgirl = [[appset resultDict] mutableCopy];
        int thisgirlid = [appset intForColumn:@"id"];
        imageset = [db executeQuery:@"SELECT * from core_girlimage where girlid_id == ?", [NSNumber numberWithInt:thisgirlid]];
        NSMutableArray  *images = [[NSMutableArray alloc] init];
        while (imageset && [imageset next]){
            NSString *pathForIcon = [imageset stringForColumn:@"image"];
            [self saveImage:pathForIcon];
            if ( [imageset boolForColumn:@"mainimage"]){
                [thisgirl setValue:pathForIcon forKey:@"mainimage"];
                
            }
           // else{
                [images addObject:pathForIcon];
          //  }
        }
        [thisgirl setValue:images forKey:@"girlpics"];
        
        [images release];
        [girls addObject:thisgirl];
    }
}
-(void) getDB{
    NSString* urlStr = [kServerURL stringByAppendingString:kDatabaseFileName];
	urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"%@", urlStr);
	NSURL* url = [NSURL URLWithString: urlStr];
	NSData *dbFile = [[NSData dataWithContentsOfURL:url] retain];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:kDatabaseFileName];
	NSError *error;
    
    if(dbFile != nil){
        [fileManager removeItemAtPath:writableDBPath error:&error];
        
        NSLog(@"Loading new db file");
        
        BOOL success = [fileManager createFileAtPath:writableDBPath contents:dbFile attributes:nil];
        if(success)
            NSLog(@"DB Downloaded");
        else
            NSLog(@"Failing");
    }
    else
    {
        NSLog(@"No internet connection or something. HELP");
    }
}

- (id)init
{
    self = [super init];
	if ( self  )
	{
        // loaded db from the net

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:kDatabaseFileName];
        girls = [[NSMutableArray alloc] init];
        [self getDB];
        if([fileManager fileExistsAtPath:writableDBPath]) {
            // If tehre's no db loaded into documents load the one from the bundle.
            // This will allow us to push updates if we write code that handles that stuff in the future.
            db = [[FMDatabase databaseWithPath:writableDBPath] retain];
            
            if (![db open]) {
                
                NSAssert1(0, @"Could not open db. Error code %d", [db lastErrorCode]);
            }
            else{
                [self loadData];
            }
        }
        
        
        // load user settings
        writableDBPath = [documentsDirectory stringByAppendingPathComponent:kPlistFileName];
                
        if ([fileManager isReadableFileAtPath:writableDBPath]){
           userSelections = [NSKeyedUnarchiver unarchiveObjectWithFile:writableDBPath];
            userSelections = [userSelections mutableCopy];
        }
        else{
            userSelections = [[NSMutableDictionary alloc] init];
        }

 
    }
	return self;
	
}
-(void)storeSettings{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:kPlistFileName];
    if( [NSKeyedArchiver archiveRootObject:userSelections toFile:writableDBPath]){
        NSLog(@"User settings saved");
        
    }
    else{
        NSLog(@"Error saving user settings");
    }
    
}
@end