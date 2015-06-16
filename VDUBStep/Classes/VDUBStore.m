//
//  VDUBStore.m
//  VDUBStep
//
//  Copyright (c) 2015 VDUB Software. All rights reserved.
//

#import "VDUBStore.h"

#import <CoreData/CoreData.h>

static VDUBStore *_sharedInstance;
static NSString *const VDUBStoreName = @"vdub.sqlite";

@implementation VDUBStore
{
	NSManagedObjectModel *_model;
	NSPersistentStoreCoordinator *_coordinator;	
	NSManagedObjectContext *_mainContext;
}

+ (void)initialize
{
	if (_sharedInstance == nil) {
		_sharedInstance = [VDUBStore new];
	}
}

+ (VDUBStore *)sharedInstance
{
	return _sharedInstance;
}

+ (NSManagedObjectContext *)mainContext
{
	return [[self sharedInstance] mainContext];
}

#pragma mark -

- (NSManagedObjectModel *)model
{
	if (_model == nil) {
		NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
		_model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
	}
	
	return _model;
}

- (NSPersistentStoreCoordinator *)coordinator
{
	if (_coordinator == nil) {
		_coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self model]];
	}
	
	return _coordinator;
}

- (void)setupCoreDataStackWithURL:(NSURL *)storeURL
{
	storeURL = [storeURL URLByAppendingPathComponent:VDUBStoreName];

	NSLog(@"opening %@", storeURL);
	
	NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES,
							   NSInferMappingModelAutomaticallyOption : @YES };
	NSError *error = nil;
	if (![[self coordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
													URL:storeURL options:options error:&error])
	{
		NSLog(@"error opening persistant store, removing");
		
		error = nil;
		if (![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]) {
			NSLog(@"error removing persistant store %@, giving up", storeURL);
		} else if (![[self coordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL
														   options:options error:&error])
		{
			NSLog(@"error opening persistant store, giving up");
		}
	}
	
	if (error) {
		_mainContext = nil;
	} else {
		_mainContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		[_mainContext setPersistentStoreCoordinator:[self coordinator]];
		[_mainContext setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
	}
}

#pragma mark -

- (NSManagedObjectContext *)mainContext
{
	return _mainContext;
}

//- (void)contextDidSave:(NSNotification *)notification
//{
//	NSDictionary *userInfo = [notification userInfo];
//	// arguments casted so importer target doesn't flag them with a warning
//	DNSLog(@"merging changes into main: %ld inserted, %ld updated, %ld deleted",
//				 (long)[[userInfo objectForKey:@"inserted"] count],
//				 (long)[[userInfo objectForKey:@"updated"] count],
//				 (long)[[userInfo objectForKey:@"deleted"] count]);
//	
//	[_mainContext performBlock:^{
//		[_mainContext mergeChangesFromContextDidSaveNotification:notification];
//	}];
//}
//
//#pragma mark -
//
//- (BOOL)save
//{
//	BOOL success;
//	
//	DNSLog(@"saving in %@", [NSThread isMainThread] ? @"main" : @"background");
//	
//	NSError *error = nil;
//	success = [[self context] save:&error];
//	if (!success) {
//		DNSLog(@"%@", error.localizedDescription);
//	}
//	
//	return success;
//}

@end
