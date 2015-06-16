//
//  NSManagedObjectContext+VDUB.m
//  VDUBStep
//
//  Copyright (c) 2015 VDUB Software. All rights reserved.
//

#import "NSManagedObjectContext+VDUB.h"

@implementation NSManagedObjectContext (VDUB)

- (BOOL)save
{
	NSError *error = nil;
	BOOL successful = [self save:&error];
	if (error) {
		NSLog(@"error saving: %@", error);
	}
	return successful;
}

@end
