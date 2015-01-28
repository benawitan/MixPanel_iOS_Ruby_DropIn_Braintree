//
//  AppDelegate.h
//  SpinCity
//
//  Created by Choon Yan, CY 2014
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Mixpanel.h"
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


@property (strong, nonatomic) UIWindow *window;

@property(strong, nonatomic) User *user;

@end
