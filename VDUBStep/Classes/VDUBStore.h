//
//  VDUBStore.h
//  VDUBStep
//
//  Copyright (c) 2015 VDUB Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface VDUBStore : NSObject

+ (VDUBStore *)sharedInstance;

+ (void)setupCoreDataStackWithURL:(NSURL *)storeURL;

+ (NSManagedObjectContext *)mainContext;
+ (NSManagedObjectContext *)backgroundContext;

@end
