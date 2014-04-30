//
//  CTAppDelegate.h
//  CarlTour
//
//  Created by Daniel Alabi on 4/29/14.
//  Copyright (c) 2014 CarlTour. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
