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
}
@property (nonatomic, retain) NSMutableArray *girls;
@property (nonatomic, retain) NSMutableDictionary *userSelections;
-(void)storeSettings;
-(void)storeFutureInfo;
+ (DataSingleton *)sharedSingleton;
-(UIImage *)loadImage:(NSString*)fromPath;
@end
