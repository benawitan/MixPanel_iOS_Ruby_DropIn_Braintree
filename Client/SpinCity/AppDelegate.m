//
//  AppDelegate.m
//  SpinCity
//
//  Created by Choon Yan, CY 2014
//

#import "AppDelegate.h"
#import "MasterViewController.h"
#import "User.h"

@interface AppDelegate()
    @property (strong, nonatomic) Mixpanel *mixpanel;
@end

@implementation AppDelegate

NSString *const MIXPANEL_TOKEN = @"cabf011d2ab022136defacce2c241a62";


//bootstrap with sample user data
- (void)initializeUsers {
        
        [self addUser:@"Bill" plan:@"Regular" customer_id:[NSNumber numberWithInteger:100000] email:@"cyonlineshopping@gmail.com" country:@"Singapore" gender:@"M" language:@"English" mobile:@"+6596272429"];
    
        [self addUser:@"Steve" plan:@"Silver" customer_id:[NSNumber numberWithInteger:200000] email:@"cyonlineshopping@gmail.com" country:@"United States" gender:@"M" language:@"English" mobile:@"+15309888892"];
    
        [self addUser:@"Elon" plan:@"Gold" customer_id:[NSNumber numberWithInteger:300000] email:@"cyonlineshopping@gmail.com" country:@"South Africa" gender:@"M" language:@"English" mobile:@"+6596272429"];
    
        [self addUser:@"Melissa" plan:@"Gold" customer_id:[NSNumber numberWithInteger:400000] email:@"cyonlineshopping@gmail.com" country:@"Japan" gender:@"F" language:@"Japanese" mobile:@"+6596272429"];
    
        [self addUser:@"Sheryl" plan:@"Platinum" customer_id:[NSNumber numberWithInteger:500000] email:@"cyonlineshopping@gmail.com" country:@"Taiwan" gender:@"F" language:@"Chinese" mobile:@"+6596272429"];
    

}
    - (void)addUser:(NSString *)name plan:(NSString *)plan customer_id:(NSNumber *)customer_id email:(NSString *)email country:(NSString *)country gender:(NSString *)gender language:(NSString *)language mobile:(NSString *)mobile{
    
        User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
        
        user.name = name;
        user.plan = plan;
        user.customer_id = customer_id;
        user.email = email;
        user.country = country;
        user.gender = gender;
        user.language = language;
        user.mobile =  mobile;
        
        
        // Save the context.
        NSError *error = nil;
        if (![user.managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
}

//fetch a random user from Core Data
- (User *)fetchRandomUser{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    [request setEntity:[NSEntityDescription entityForName:@"User"
                                   inManagedObjectContext:self.managedObjectContext]];
    
    NSError *error = nil;
    NSArray *fetchResults;
    fetchResults = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!fetchResults||!error) {
        NSLog(@"Fetch results error %@", error);
    }
    
    User *user = [fetchResults objectAtIndex:arc4random()%[fetchResults count]];

    return user;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    MasterViewController *controller = (MasterViewController *)navigationController.topViewController;
    
    controller.managedObjectContext = self.managedObjectContext;
    [self deleteAllEntities:@"Album"];
    [self deleteAllEntities:@"User"];
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    //Add mixpanel tracker for opening app event
    [Mixpanel sharedInstanceWithToken:MIXPANEL_TOKEN];
    self.mixpanel = [Mixpanel sharedInstance];
    [self.mixpanel track:@"App Opened"];
    
    //Bootstrap users and track a random user each time the app loads
    [self initializeUsers];
    User *user = [self fetchRandomUser];
    [self.mixpanel identify:[user.customer_id stringValue]];
    [self.mixpanel.people set:@{@"Plan":user.plan,@"$name":user.name,@"$email":user.email,@"Country":user.country,@"Gender":user.gender,
                                @"Language":user.language,@"$phone":user.mobile}];
    NSLog(@"User Logged: %@",user.name);
    //set data upload interval to 10 secs for demo. default is 60 secs
    self.mixpanel.flushInterval = 10;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self.mixpanel track:@"App Session"];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self.mixpanel timeEvent:@"App Session"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "demo.app.braintree.coredatatest" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SpinCity" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SpinCity.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

//reset sample data
- (void)deleteAllEntities:(NSString *)nameEntity
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:nameEntity];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [self.managedObjectContext deleteObject:object];
    }
    
    error = nil;
    [self.managedObjectContext save:&error];
}


@end
