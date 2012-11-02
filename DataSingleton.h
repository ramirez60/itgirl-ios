//
//  DataSingleton.h
//  itgirl
//
//  Created by gnamit on 10/13/12.
//  Copyright (c) 2012 gnamit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DataSingleton : NSObject
{
    FMDatabase *db;
    NSMutableArray *girls;
    NSMutableDictionary *userSelections;
    NSMutableArray *favorites;
}
@property (nonatomic, retain) NSMutableArray *favorites;
@property (nonatomic, retain) NSMutableArray *girls;
@property (nonatomic, retain) NSMutableDictionary *userSelections;
-(void)storeSettings;
+ (DataSingleton *)sharedSingleton;
-(UIImage *)loadImage:(NSString*)fromPath;
@end
