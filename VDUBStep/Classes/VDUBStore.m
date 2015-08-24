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
	NSManagedObjectContext *_backgroundContext;
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

+ (void)setupCoreDataStackWithURL:(NSURL *)storeURL
{
	return [[self sharedInstance] setupCoreDataStackWithURL:storeURL];
}

+ (NSManagedObjectContext *)mainContext
{
	return [[self sharedInstance] mainContext];
}

+ (NSManagedObjectContext *)backgroundContext
{
	return [[self sharedInstance] backgroundContext];
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
	NSLog(@"opening %@", storeURL);
	
	NSDictionary *options = @{ NSMigratePersistentStoresAutomaticallyOption : @YES,
							   NSInferMappingModelAutomaticallyOption : @YES };
	NSError *error = nil;
	if (![[self coordinator] addPersistentStoreWithType:NSSQLiteStoreType configuration:nil
													URL:storeURL options:options error:&error])
	{
		NSLog(@"error opening persistent store, removing (%@)", error);
		
		error = nil;
		if (![[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]) {
			NSLog(@"error removing persistent store, giving up (%@)", error);
		} else if (![[self coordinator] addPersistentStoreWithType:NSSQLiteStoreType
													 configuration:nil URL:storeURL
														   options:options error:&error])
		{
			NSLog(@"error opening persistent store, giving up (%@)", error);
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

- (NSManagedObjectContext *)backgroundContext
{
	if (!_backgroundContext) {
		_backgroundContext = [[NSManagedObjectContext alloc] init];
		[_backgroundContext setPersistentStoreCoordinator:[self coordinator]];

		// listen for notification to merge background context changes into main context
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextDidSave:)
													 name:NSManagedObjectContextDidSaveNotification
												   object:_backgroundContext];
	}

	return _backgroundContext;
}

- (void)contextDidSave:(NSNotification *)notification
{
	[_mainContext performBlock:^{
		[_mainContext mergeChangesFromContextDidSaveNotification:notification];
	}];
}

@end
