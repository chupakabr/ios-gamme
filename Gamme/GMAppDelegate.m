//
//  GMAppDelegate.m
//  Gamme
//
//  Created by Valeriy Chevtaev on 1/23/12.
//  Copyright (c) 2012 7bit. All rights reserved.
//

#import "GMAppDelegate.h"
#import "FlurryAnalytics.h"

#import "GMByPlatformViewController.h"
#import "GMByGenreViewController.h"
#import "GMByDeveloperViewController.h"
#import "GMHomeViewController.h"
#import "GMStatsViewController.h"

#import "GMModels.h"

#import "GMLog.h"
#import "GMDate.h"

#import <CoreData/CoreData.h>



// Exception handler
void uncaughtExceptionHandler(NSException *exception);
void uncaughtExceptionHandler(NSException *exception) {
    [FlurryAnalytics logError:@"Uncaught" message:@"Crash!" exception:exception];
}


//
// Privates

@interface GMAppDelegate (Privates)

- (void) initUI;

- (void) initPersistense;
- (NSURL *) persistentStoreURL;

@end



//
// Publics

@implementation GMAppDelegate


@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize managedObjectContext = managedObjectContext_;


+ (GMAppDelegate *)instance
{
    return (GMAppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (GMPersistenceHelper *)persistenceHelper
{
    if (!persistenceHelper_) {
        persistenceHelper_ = [[GMPersistenceHelper alloc] initWithManagedObjectContext:self.managedObjectContext];
    }
    
    return persistenceHelper_;
}

- (void)dealloc
{
    GMLog(@"AppDelegate - dealloc()");
    
    [_window release];
    [_tabBarController release];
    
    if (persistenceHelper_) {
        [persistenceHelper_ release];
    }
    
    [persistentStoreCoordinator_ release];
    [managedObjectContext_ release];
    
    [super dealloc];
}


#pragma mark - UI privates

- (void) initUI
{
    GMLog(@"AppDelegate - initUI()");
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    NSString *byPlatformNibName,
            *byDeveloperNibName,
            *byGenreNibName,
            *homeNibName,
            *statsNibName;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // iPhone
        byPlatformNibName = @"GMByPlatformViewController_iPhone";
        byDeveloperNibName = @"GMByDeveloperViewController_iPhone";
        byGenreNibName = @"GMByGenreViewController_iPhone";
        homeNibName = @"GMHomeViewController_iPhone";
        statsNibName = @"GMStatsViewController_iPhone";
    } else {
        // iPad
        byPlatformNibName = @"GMByPlatformViewController_iPad";
        byDeveloperNibName = @"GMByDeveloperViewController_iPad";
        byGenreNibName = @"GMByGenreViewController_iPad";
        homeNibName = @"GMHomeViewController_iPad";
        statsNibName = @"GMStatsViewController_iPad";
    }
    
    UIViewController *byPlatformRootController = [[[GMByPlatformViewController alloc] initWithNibName:byPlatformNibName bundle:nil] autorelease];
    UINavigationController *byPlatformController = [[[UINavigationController alloc] initWithRootViewController:byPlatformRootController] autorelease];
    [byPlatformController setNavigationBarHidden:YES];
    
    UIViewController *byDeveloperRootController = [[[GMByDeveloperViewController alloc] initWithNibName:byDeveloperNibName bundle:nil] autorelease];
    UINavigationController *byDeveloperController = [[[UINavigationController alloc] initWithRootViewController:byDeveloperRootController] autorelease];
    [byDeveloperController setNavigationBarHidden:YES];
    
    UIViewController *byGenreRootController = [[[GMByGenreViewController alloc] initWithNibName:byGenreNibName bundle:nil] autorelease];
    UINavigationController *byGenreController = [[[UINavigationController alloc] initWithRootViewController:byGenreRootController] autorelease];
    [byGenreController setNavigationBarHidden:YES];
    
    UIViewController *homeRootController = [[[GMHomeViewController alloc] initWithNibName:homeNibName bundle:nil] autorelease];
    UINavigationController *homeController = [[[UINavigationController alloc] initWithRootViewController:homeRootController] autorelease];
    [homeController setNavigationBarHidden:YES];
    
    UIViewController *statsRootController = [[[GMStatsViewController alloc] initWithNibName:statsNibName bundle:nil] autorelease];
    UINavigationController *statsController = [[[UINavigationController alloc] initWithRootViewController:statsRootController] autorelease];
    [statsController setNavigationBarHidden:YES];
    
    
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:homeController, byGenreController, byPlatformController, byDeveloperController, statsController, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
}


#pragma mark - App states

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    GMLog(@"AppDelegate - applicationDidFinishLaunching()");
    
    // Init exception handler
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    
    // Init flurry.com
    [FlurryAnalytics startSession:@"TODO YOUR FLURRY KEY"];
    
    // Init persistense
    [self initPersistense];
    
    // Init UI
    [self initUI];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    GMLog(@"AppDelegate - applicationWillResignActive()");
    
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    GMLog(@"AppDelegate - applicationDidEnterBackground()");
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    GMLog(@"AppDelegate - applicationWillEnterForeground()");
    
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    GMLog(@"AppDelegate - applicationDidBecomeActive()");
    
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    GMLog(@"AppDelegate - applicationWillTerminate()");
    
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}


#pragma mark - Persistense

- (NSURL *)persistentStoreURL
{
    GMLog(@"AppDelegate - persistentStoreURL()");
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths lastObject];
    
    return [NSURL fileURLWithPath:[documentsDirectory stringByAppendingPathComponent:@"Gamme.sqlite"]];
}    

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    GMLog(@"AppDelegate - persistentStoreCoordinator()");
    
    if (persistentStoreCoordinator_ == nil) {
        
        NSManagedObjectModel * model = [NSManagedObjectModel mergedModelFromBundles:nil];
        persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        NSError *error = nil;
        NSPersistentStore *persistentStore = [persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[self persistentStoreURL] options:nil error:&error];
        
        NSAssert3(persistentStore != nil, @"GMAppDelegate - Unhandled error adding persistent store in %s at line %d: %@", __FUNCTION__, __LINE__, [error localizedDescription]);
    }
    
    return persistentStoreCoordinator_;
}

- (NSManagedObjectContext *)managedObjectContext
{
    GMLog(@"AppDelegate - managedObjectContext()");
    
    if (managedObjectContext_ == nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:self.persistentStoreCoordinator];
    }
    
    return managedObjectContext_;
}

- (void) initPersistense
{
    GMLog(@"AppDelegate - initPersistense()");
    
    NSError * errors;
    NSManagedObjectContext * moc = self.managedObjectContext;
    
    
    // Get entities
    NSEntityDescription * genreEntity = [self.persistenceHelper genreEntityDescription];
    NSEntityDescription * platformEntity = [self.persistenceHelper platformEntityDescription];
    NSEntityDescription * authorEntity = [self.persistenceHelper authorEntityDescription];
    
    
    //
    // Try to load existing data, create if no data exists
    
    BOOL hasSomeData = NO;
    NSFetchRequest * fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    
    // Fetch genres
    [fetchRequest setEntity:genreEntity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    NSArray * fetchResultList = [moc executeFetchRequest:fetchRequest error:&errors];
    if (!fetchResultList) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot execute fetch query for Genre"];
    }
    
    if ([fetchResultList count] <= 0) {
        GMLog(@"InitPersistense - no Genre data exists in the DB");
    } else {
        GMLog(@"InitPersistense - %d Genre entries exists in the DB", [fetchResultList count]);
        
        hasSomeData = YES;
        for (NSObject * genre in fetchResultList) {
            GMLog(@"  * Genre: %@", genre);
        }
    }
    
    // Fetch platforms
    fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:platformEntity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    fetchResultList = [moc executeFetchRequest:fetchRequest error:&errors];
    if (!fetchResultList) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot execute fetch query for Platform"];
    }
    
    if ([fetchResultList count] <= 0) {
        GMLog(@"InitPersistense - no Platform data exists in the DB");
    } else {
        GMLog(@"InitPersistense - %d Platform entries exists in the DB", [fetchResultList count]);
        
        hasSomeData = YES;
        for (NSObject * platform in fetchResultList) {
            GMLog(@"  * Platform: %@", platform);
        }
    }
    
    // Fetch developers
    fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    [fetchRequest setEntity:authorEntity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]]];
    fetchResultList = [moc executeFetchRequest:fetchRequest error:&errors];
    if (!fetchResultList) {
        [NSException raise:NSInternalInconsistencyException format:@"Cannot execute fetch query for Author"];
    }
    
    if ([fetchResultList count] <= 0) {
        GMLog(@"InitPersistense - no Author data exists in the DB");
    } else {
        GMLog(@"InitPersistense - %d Author entries exists in the DB", [fetchResultList count]);
        
        hasSomeData = YES;
        for (NSObject * author in fetchResultList) {
            GMLog(@"  * Author: %@", author);
        }
    }
    
    // Exit if some data already exists in the DB
    if (hasSomeData) {
        
        //
        // Check for default Platform
        fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:platformEntity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isSystem = %@", [NSNumber numberWithBool:YES]]];
        fetchResultList = [moc executeFetchRequest:fetchRequest error:&errors];
        if (!fetchResultList || [fetchResultList count] <= 0)
        {
            Platform * p0 = [self.persistenceHelper newPlatform];
            [p0 setTitle:@"*Unknown"];
            [p0 setIsSystem:[NSNumber numberWithBool:YES]];
            [self.persistenceHelper insertObjectNow:p0];        
        }
        
        
        //
        // Check for default Author
        fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
        [fetchRequest setEntity:authorEntity];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"isSystem = %@", [NSNumber numberWithBool:YES]]];
        fetchResultList = [moc executeFetchRequest:fetchRequest error:&errors];
        if (!fetchResultList || [fetchResultList count] <= 0)
        {
            Author * a0 = [self.persistenceHelper newAuthor];
            [a0 setTitle:@"*Unknown"];
            [a0 setIsSystem:[NSNumber numberWithBool:YES]];
            [self.persistenceHelper insertObjectNow:a0];
        }
        
        
        //
        // Ok
        GMLog(@"InitPersistense - There is some data in the DB already, so no need to upload default dump");
        return;
    }
    
    GMLog(@"InitPersistense - Bootstrap some default data for Genre|Platform|Author");
    
    
    //
    // Create default values (genres, platforms, developers) if DB doesn't have any
    //
    
    
    //
    // Genres
    
    Genre * genre0 = [self.persistenceHelper newGenre];
    [genre0 setTitle:@"*Other"];
    [genre0 setIsSystem:[NSNumber numberWithBool:YES]];
    [self.persistenceHelper insertObject:genre0];
    
    NSArray * defaultGenres = [NSArray arrayWithObjects:@"Action", @"Adventure", @"Arcade", @"Board", 
                        @"Casino", @"Family", @"Fighting", @"Horror", @"J-RPG",
                        @"Music", @"Puzzle", @"Racing", @"RPG", @"Simulation",
                        @"Sports", @"Strategy", @"Other", nil];
    for (NSString * genreTitle in defaultGenres) {
        Genre * genre = [self.persistenceHelper newGenre];
        [genre setTitle:genreTitle];
        [self.persistenceHelper insertObject:genre];
    }
    
    
    //
    // Platforms
    
    Platform * p0 = [self.persistenceHelper newPlatform];
    [p0 setTitle:@"*Unknown"];
    [p0 setIsSystem:[NSNumber numberWithBool:YES]];
    [self.persistenceHelper insertObject:p0];
    
    Platform * p1 = [self.persistenceHelper newPlatform];
    [p1 setTitle:@"Dreamcast"];
    [p1 setSite:@"http://www.sega.com"];
    [p1 setReleaseDate:[GMDate dateWithYear:1993 andMonth:11 andDay:27]];
    [self.persistenceHelper insertObject:p1];
    
    Platform * p2 = [self.persistenceHelper newPlatform];
    [p2 setTitle:@"Game Boy"];
    [p2 setReleaseDate:[GMDate dateWithYear:1989 andMonth:4 andDay:21]];
    [self.persistenceHelper insertObject:p2];
    
    Platform * p3 = [self.persistenceHelper newPlatform];
    [p3 setTitle:@"GameCube"];
    [p3 setSite:@"http://www.nintendo.com"];
    [p3 setReleaseDate:[GMDate dateWithYear:2001 andMonth:9 andDay:14]];
    [self.persistenceHelper insertObject:p3];
    
    Platform * p4 = [self.persistenceHelper newPlatform];
    [p4 setTitle:@"iPhone"];
    [p4 setSite:@"http://www.apple.com/iphone/"];
    [self.persistenceHelper insertObject:p4];
    
    Platform * p5 = [self.persistenceHelper newPlatform];
    [p5 setTitle:@"Mac"];
    [p5 setSite:@"http://www.apple.com/mac/"];
    [self.persistenceHelper insertObject:p5];
    
    Platform * p6 = [self.persistenceHelper newPlatform];
    [p6 setTitle:@"NES"];
    [p6 setSite:@"http://www.nintendo.com"];
    [p6 setReleaseDate:[GMDate dateWithYear:1983 andMonth:7 andDay:15]];
    [self.persistenceHelper insertObject:p6];
    
    Platform * p7 = [self.persistenceHelper newPlatform];
    [p7 setTitle:@"Nintendo 64"];
    [p7 setSite:@"http://www.nintendo.com"];
    [p7 setReleaseDate:[GMDate dateWithYear:1996 andMonth:6 andDay:23]];
    [self.persistenceHelper insertObject:p7];
    
    Platform * p8 = [self.persistenceHelper newPlatform];
    [p8 setTitle:@"Nintendo DS"];
    [p8 setSite:@"http://www.nintendo.com"];
    [p8 setReleaseDate:[GMDate dateWithYear:2004 andMonth:11 andDay:21]];
    [self.persistenceHelper insertObject:p8];
    
    Platform * p9 = [self.persistenceHelper newPlatform];
    [p9 setTitle:@"Nintendo Wii"];
    [p9 setSite:@"http://www.nintendo.com"];
    [p9 setReleaseDate:[GMDate dateWithYear:2006 andMonth:11 andDay:19]];
    [self.persistenceHelper insertObject:p9];
    
    Platform * p10 = [self.persistenceHelper newPlatform];
    [p10 setTitle:@"PC"];
    [self.persistenceHelper insertObject:p10];
    
    Platform * p11 = [self.persistenceHelper newPlatform];
    [p11 setTitle:@"PlayStation"];
    [p11 setSite:@"http://www.playstation.com"];
    [p11 setReleaseDate:[GMDate dateWithYear:1994 andMonth:12 andDay:3]];
    [self.persistenceHelper insertObject:p11];
    
    Platform * p12 = [self.persistenceHelper newPlatform];
    [p12 setTitle:@"PlayStation 2"];
    [p12 setSite:@"http://www.playstation.com"];
    [p12 setReleaseDate:[GMDate dateWithYear:2000 andMonth:3 andDay:4]];
    [self.persistenceHelper insertObject:p12];
    
    Platform * p13 = [self.persistenceHelper newPlatform];
    [p13 setTitle:@"PlayStation 3"];
    [p13 setSite:@"http://www.playstation.com"];
    [p13 setReleaseDate:[GMDate dateWithYear:2006 andMonth:11 andDay:11]];
    [self.persistenceHelper insertObject:p13];
    
    Platform * p14 = [self.persistenceHelper newPlatform];
    [p14 setTitle:@"PSP"];
    [p14 setSite:@"http://www.playstation.com"];
    [p14 setReleaseDate:[GMDate dateWithYear:2004 andMonth:12 andDay:12]];
    [self.persistenceHelper insertObject:p14];
    
    Platform * p15 = [self.persistenceHelper newPlatform];
    [p15 setTitle:@"PS Vita"];
    [p15 setSite:@"http://www.playstation.com"];
    [p15 setReleaseDate:[GMDate dateWithYear:2011 andMonth:12 andDay:17]];
    [self.persistenceHelper insertObject:p15];
    
    Platform * p16 = [self.persistenceHelper newPlatform];
    [p16 setTitle:@"SNES"];
    [p16 setSite:@"http://www.nintendo.com"];
    [p16 setReleaseDate:[GMDate dateWithYear:1990 andMonth:11 andDay:21]];
    [self.persistenceHelper insertObject:p16];
    
    Platform * p17 = [self.persistenceHelper newPlatform];
    [p17 setTitle:@"Xbox"];
    [p17 setSite:@"http://www.xbox.com"];
    [p17 setReleaseDate:[GMDate dateWithYear:2001 andMonth:11 andDay:15]];
    [self.persistenceHelper insertObject:p17];
    
    Platform * p18 = [self.persistenceHelper newPlatform];
    [p18 setTitle:@"Xbox 360"];
    [p18 setSite:@"http://www.xbox.com"];
    [p18 setReleaseDate:[GMDate dateWithYear:2005 andMonth:11 andDay:22]];
    [self.persistenceHelper insertObject:p18];
    
    Platform * p19 = [self.persistenceHelper newPlatform];
    [p19 setTitle:@"PlayStation 4"];
    [p19 setSite:@"http://www.playstation.com"];
    [p19 setReleaseDate:[GMDate dateWithYear:2013 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:p19];
    
    Platform * p20 = [self.persistenceHelper newPlatform];
    [p20 setTitle:@"Xbox 720"];
    [p20 setSite:@"http://www.xbox.com"];
    [p20 setReleaseDate:[GMDate dateWithYear:2013 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:p20];
    
    Platform * p21 = [self.persistenceHelper newPlatform];
    [p21 setTitle:@"Android"];
    [p21 setSite:@"http://www.android.com"];
    [p21 setReleaseDate:[GMDate dateWithYear:2008 andMonth:9 andDay:23]];
    [self.persistenceHelper insertObject:p21];
    
    Platform * p22 = [self.persistenceHelper newPlatform];
    [p22 setTitle:@"Sega Mega Drive"];
    [p22 setSite:@"http://www.sega.com"];
    [p22 setReleaseDate:[GMDate dateWithYear:1988 andMonth:10 andDay:29]];
    [self.persistenceHelper insertObject:p22];
    
    
    //
    // Authors
    
    Author * a0 = [self.persistenceHelper newAuthor];
    [a0 setTitle:@"*Unknown"];
    [a0 setIsSystem:[NSNumber numberWithBool:YES]];
    [self.persistenceHelper insertObject:a0];
    
    Author * a1 = [self.persistenceHelper newAuthor];
    [a1 setTitle:@"Square Enix"];
    [a1 setSite:@"http://www.square-enix.com"];
    [a1 setCountry:@"Japan"];
    [a1 setFoundationDate:[GMDate dateWithYear:2003 andMonth:4 andDay:1]];
    [self.persistenceHelper insertObject:a1];
    
    Author * a2 = [self.persistenceHelper newAuthor];
    [a2 setTitle:@"3DO"];
    [a2 setCountry:@"USA"];
    [a2 setFoundationDate:[GMDate dateWithYear:1991 andMonth:1 andDay:1]];
    [a2 setCloseDate:[GMDate dateWithYear:2003 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a2];
    
    Author * a3 = [self.persistenceHelper newAuthor];
    [a3 setTitle:@"Konami"];
    [a3 setSite:@"http://www.konami.com"];
    [a3 setCountry:@"Japan"];
    [a3 setFoundationDate:[GMDate dateWithYear:1969 andMonth:3 andDay:21]];
    [self.persistenceHelper insertObject:a3];
    
    Author * a4 = [self.persistenceHelper newAuthor];
    [a4 setTitle:@"2K Czech"];
    [a4 setSite:@"http://www.2kczech.com"];
    [a4 setCountry:@"Czech Republic"];
    [a4 setFoundationDate:[GMDate dateWithYear:1997 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a4];
    
    Author * a5 = [self.persistenceHelper newAuthor];
    [a5 setTitle:@"3G Studios"];
    [a5 setSite:@"http://www.3gstudios.com"];
    [a5 setCountry:@"USA, Reno"];
    [self.persistenceHelper insertObject:a5];
    
    Author * a6 = [self.persistenceHelper newAuthor];
    [a6 setTitle:@"Accolade"];
    [a6 setCountry:@"USA, California"];
    [a6 setFoundationDate:[GMDate dateWithYear:1984 andMonth:1 andDay:1]];
    [a6 setCloseDate:[GMDate dateWithYear:1999 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a6];
    
    Author * a7 = [self.persistenceHelper newAuthor];
    [a7 setTitle:@"Activision"];
    [a7 setSite:@"http://www.activision.com"];
    [a7 setCountry:@"USA, California"];
    [a7 setFoundationDate:[GMDate dateWithYear:1979 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a7];
    
    Author * a8 = [self.persistenceHelper newAuthor];
    [a8 setTitle:@"Akella"];
    [a8 setSite:@"http://en.akella.com"];
    [a8 setCountry:@"Russia, Moscow"];
    [a8 setFoundationDate:[GMDate dateWithYear:1995 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a8];
    
    Author * a9 = [self.persistenceHelper newAuthor];
    [a9 setTitle:@"Avalanche Studios"];
    [a9 setSite:@"http://www.avalanchestudios.se"];
    [a9 setCountry:@"Sweden, Stockholm"];
    [a9 setFoundationDate:[GMDate dateWithYear:2003 andMonth:3 andDay:1]];
    [self.persistenceHelper insertObject:a9];
    
    Author * a10 = [self.persistenceHelper newAuthor];
    [a10 setTitle:@"Bethesda Softworks"];
    [a10 setSite:@"http://www.bethsoft.com"];
    [a10 setCountry:@"USA, Rockville"];
    [a10 setFoundationDate:[GMDate dateWithYear:1986 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a10];
    
    Author * a11 = [self.persistenceHelper newAuthor];
    [a11 setTitle:@"BioWare"];
    [a11 setSite:@"http://www.bioware.com"];
    [a11 setCountry:@"Canada, Edmonton"];
    [a11 setFoundationDate:[GMDate dateWithYear:1995 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a11];
    
    Author * a12 = [self.persistenceHelper newAuthor];
    [a12 setTitle:@"Blizzard Entertainment"];
    [a12 setSite:@"http://eu.blizzard.com"];
    [a12 setCountry:@"USA, California"];
    [a12 setFoundationDate:[GMDate dateWithYear:1991 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a12];
    
    Author * a13 = [self.persistenceHelper newAuthor];
    [a13 setTitle:@"Bullfrog Productions"];
    [a13 setCountry:@"England, Guildford"];
    [a13 setFoundationDate:[GMDate dateWithYear:1987 andMonth:1 andDay:1]];
    [a13 setCloseDate:[GMDate dateWithYear:2004 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a13];
    
    Author * a14 = [self.persistenceHelper newAuthor];
    [a14 setTitle:@"Bungie Studios"];
    [a14 setSite:@"http://www.bungie.net"];
    [a14 setCountry:@"USA, Washington"];
    [a14 setFoundationDate:[GMDate dateWithYear:1991 andMonth:5 andDay:1]];
    [self.persistenceHelper insertObject:a14];
    
    Author * a15 = [self.persistenceHelper newAuthor];
    [a15 setTitle:@"Media.Vision"];
    [a15 setSite:@"http://www.media-vision.co.jp"];
    [a15 setCountry:@"Japan, Tokyo"];
    [a15 setFoundationDate:[GMDate dateWithYear:1993 andMonth:4 andDay:1]];
    [self.persistenceHelper insertObject:a15];
    
    Author * a16 = [self.persistenceHelper newAuthor];
    [a16 setTitle:@"CyberConnect2"];
    [a16 setSite:@"http://www.cyberconnect2.jp"];
    [a16 setCountry:@"Japan, Fukuoka"];
    [a16 setFoundationDate:[GMDate dateWithYear:1996 andMonth:2 andDay:16]];
    [self.persistenceHelper insertObject:a16];
    
    Author * a17 = [self.persistenceHelper newAuthor];
    [a17 setTitle:@"CCP Games"];
    [a17 setSite:@"http://www.ccpgames.com"];
    [a17 setCountry:@"Island, USA, China"];
    [a17 setFoundationDate:[GMDate dateWithYear:1997 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a17];
    
    Author * a18 = [self.persistenceHelper newAuthor];
    [a18 setTitle:@"Criterion Games"];
    [a18 setSite:@"http://criteriongames.com"];
    [a18 setCountry:@"England, Guildford"];
    [a18 setFoundationDate:[GMDate dateWithYear:1993 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a18];
    
    Author * a19 = [self.persistenceHelper newAuthor];
    [a19 setTitle:@"Crystal Dynamics"];
    [a19 setSite:@"http://crystald.com"];
    [a19 setCountry:@"USA, California"];
    [a19 setFoundationDate:[GMDate dateWithYear:1992 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a19];
    
    Author * a20 = [self.persistenceHelper newAuthor];
    [a20 setTitle:@"Crytek"];
    [a20 setSite:@"http://www.crytek.com"];
    [a20 setCountry:@"Germany, Frankfurt"];
    [a20 setFoundationDate:[GMDate dateWithYear:1999 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a20];
    
    Author * a21 = [self.persistenceHelper newAuthor];
    [a21 setTitle:@"Digital Illusions CE"];
    [a21 setSite:@"http://www.dice.se"];
    [a21 setCountry:@"Sweden, Stockholm"];
    [a21 setFoundationDate:[GMDate dateWithYear:1992 andMonth:5 andDay:1]];
    [self.persistenceHelper insertObject:a21];
    
    Author * a22 = [self.persistenceHelper newAuthor];
    [a22 setTitle:@"Epic Games"];
    [a22 setSite:@"http://epicgames.com"];
    [a22 setCountry:@"USA, North Carolina"];
    [a22 setFoundationDate:[GMDate dateWithYear:1991 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a22];
    
    Author * a23 = [self.persistenceHelper newAuthor];
    [a23 setTitle:@"Eurocom"];
    [a23 setSite:@"http://www.eurocom.co.uk"];
    [a23 setCountry:@"England, Derby"];
    [a23 setFoundationDate:[GMDate dateWithYear:1988 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a23];
    
    Author * a24 = [self.persistenceHelper newAuthor];
    [a24 setTitle:@"Firaxis Games"];
    [a24 setSite:@"http://www.firaxis.com"];
    [a24 setCountry:@"USA, Maryland"];
    [a24 setFoundationDate:[GMDate dateWithYear:1996 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a24];
    
    Author * a25 = [self.persistenceHelper newAuthor];
    [a25 setTitle:@"Firefly Studios"];
    [a25 setSite:@"http://www.fireflyworlds.com"];
    [a25 setCountry:@"England, London"];
    [a25 setFoundationDate:[GMDate dateWithYear:1999 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a25];
    
    Author * a26 = [self.persistenceHelper newAuthor];
    [a26 setTitle:@"Frictional Games"];
    [a26 setSite:@"http://www.frictionalgames.com/site"];
    [a26 setCountry:@"Sweden, Helsingborg"];
    [a26 setFoundationDate:[GMDate dateWithYear:2006 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a26];
    
    Author * a27 = [self.persistenceHelper newAuthor];
    [a27 setTitle:@"Funcom"];
    [a27 setSite:@"http://www.funcom.com"];
    [a27 setCountry:@"Norway, Oslo"];
    [a27 setFoundationDate:[GMDate dateWithYear:1993 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a27];
    
    Author * a28 = [self.persistenceHelper newAuthor];
    [a28 setTitle:@"Game Freak"];
    [a28 setSite:@"http://www.gamefreak.co.jp"];
    [a28 setCountry:@"Japan"];
    [a28 setFoundationDate:[GMDate dateWithYear:1989 andMonth:4 andDay:26]];
    [self.persistenceHelper insertObject:a28];
    
    Author * a29 = [self.persistenceHelper newAuthor];
    [a29 setTitle:@"Gearbox Software"];
    [a29 setSite:@"http://www.gearboxsoftware.com"];
    [a29 setCountry:@"USA, Texas"];
    [a29 setFoundationDate:[GMDate dateWithYear:1999 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a29];
    
    Author * a30 = [self.persistenceHelper newAuthor];
    [a30 setTitle:@"Guerrilla Games"];
    [a30 setSite:@"http://www.guerrilla-games.com"];
    [a30 setCountry:@"Netherlands, Amsterdam"];
    [a30 setFoundationDate:[GMDate dateWithYear:2004 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a30];
    
    Author * a31 = [self.persistenceHelper newAuthor];
    [a31 setTitle:@"id Software"];
    [a31 setSite:@"http://www.idsoftware.com"];
    [a31 setCountry:@"USA, Texas"];
    [a31 setFoundationDate:[GMDate dateWithYear:1991 andMonth:2 andDay:1]];
    [self.persistenceHelper insertObject:a31];
    
    Author * a32 = [self.persistenceHelper newAuthor];
    [a32 setTitle:@"Infinity Ward"];
    [a32 setSite:@"http://www.infinityward.com"];
    [a32 setCountry:@"USA, California"];
    [self.persistenceHelper insertObject:a32];
    
    Author * a33 = [self.persistenceHelper newAuthor];
    [a33 setTitle:@"Insomniac Games"];
    [a33 setSite:@"http://www.insomniacgames.com"];
    [a33 setCountry:@"USA"];
    [a33 setFoundationDate:[GMDate dateWithYear:1994 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a33];
    
    Author * a34 = [self.persistenceHelper newAuthor];
    [a34 setTitle:@"IO Interactive"];
    [a34 setSite:@"http://www.ioi.dk"];
    [a34 setCountry:@"Denmark, Copenhagen"];
    [a34 setFoundationDate:[GMDate dateWithYear:1998 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a34];
    
    Author * a35 = [self.persistenceHelper newAuthor];
    [a35 setTitle:@"Irrational Games"];
    [a35 setSite:@"http://irrationalgames.com"];
    [a35 setCountry:@"USA. Australia."];
    [a35 setFoundationDate:[GMDate dateWithYear:1997 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a35];
    
    Author * a36 = [self.persistenceHelper newAuthor];
    [a36 setTitle:@"Lionhead Studios"];
    [a36 setSite:@"http://lionhead.com"];
    [a36 setCountry:@"England, Guildford"];
    [a36 setFoundationDate:[GMDate dateWithYear:1997 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a36];
    
    Author * a37 = [self.persistenceHelper newAuthor];
    [a37 setTitle:@"Looking Glass Studios"];
    [a37 setCountry:@"USA, Cambridge"];
    [a37 setFoundationDate:[GMDate dateWithYear:1990 andMonth:1 andDay:1]];
    [a37 setCloseDate:[GMDate dateWithYear:2000 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a37];
    
    Author * a38 = [self.persistenceHelper newAuthor];
    [a38 setTitle:@"Media Molecule"];
    [a38 setSite:@"http://www.mediamolecule.com"];
    [a38 setCountry:@"England"];
    [a38 setFoundationDate:[GMDate dateWithYear:2006 andMonth:1 andDay:4]];
    [self.persistenceHelper insertObject:a38];
    
    Author * a39 = [self.persistenceHelper newAuthor];
    [a39 setTitle:@"Microsoft Game Studios"];
    [a39 setSite:@"http://www.microsoft.com/games/"];
    [a39 setCountry:@"USA, Redmond"];
    [a39 setFoundationDate:[GMDate dateWithYear:2002 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a39];
    
    Author * a40 = [self.persistenceHelper newAuthor];
    [a40 setTitle:@"Namco Bandai"];
    [a40 setSite:@"http://www.bandainamcogames.co.jp/english/"];
    [a40 setCountry:@"Japan, Tokyo"];
    [a40 setFoundationDate:[GMDate dateWithYear:2006 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a40];
    
    Author * a41 = [self.persistenceHelper newAuthor];
    [a41 setTitle:@"Naughty Dog"];
    [a41 setSite:@"http://www.naughtydog.com"];
    [a41 setCountry:@"USA, California"];
    [a41 setFoundationDate:[GMDate dateWithYear:1984 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a41];
    
    Author * a42 = [self.persistenceHelper newAuthor];
    [a42 setTitle:@"NCsoft"];
    [a42 setSite:@"http://global.ncsoft.com/global/"];
    [a42 setCountry:@"South Korea, Seoul"];
    [a42 setFoundationDate:[GMDate dateWithYear:1997 andMonth:3 andDay:11]];
    [self.persistenceHelper insertObject:a42];
    
    Author * a43 = [self.persistenceHelper newAuthor];
    [a43 setTitle:@"Neversoft"];
    [a43 setSite:@"http://www.neversoft.com"];
    [a43 setCountry:@"USA, California"];
    [a43 setFoundationDate:[GMDate dateWithYear:1994 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a43];
    
    Author * a44 = [self.persistenceHelper newAuthor];
    [a44 setTitle:@"Nintendo"];
    [a44 setSite:@"http://www.nintendo.co.jp"];
    [a44 setCountry:@"Japan, Kyoto"];
    [a44 setFoundationDate:[GMDate dateWithYear:1889 andMonth:9 andDay:23]];
    [self.persistenceHelper insertObject:a44];
    
    Author * a45 = [self.persistenceHelper newAuthor];
    [a45 setTitle:@"Obsidian Entertainment"];
    [a45 setSite:@"http://www.obsidianent.com"];
    [a45 setCountry:@"USA, California"];
    [a45 setFoundationDate:[GMDate dateWithYear:2003 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a45];
    
    Author * a46 = [self.persistenceHelper newAuthor];
    [a46 setTitle:@"Pandemic Studios"];
    [a46 setSite:@"http://www.pandemicstudios.com"];
    [a46 setCountry:@"USA. Australia."];
    [a46 setFoundationDate:[GMDate dateWithYear:1998 andMonth:1 andDay:1]];
    [a46 setCloseDate:[GMDate dateWithYear:2009 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a46];
    
    Author * a47 = [self.persistenceHelper newAuthor];
    [a47 setTitle:@"PopCap Games"];
    [a47 setSite:@"http://www.popcap.com"];
    [a47 setCountry:@"USA"];
    [a47 setFoundationDate:[GMDate dateWithYear:2000 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a47];
    
    Author * a48 = [self.persistenceHelper newAuthor];
    [a48 setTitle:@"Quantic Dream"];
    [a48 setSite:@"http://www.quanticdream.com"];
    [a48 setCountry:@"France, Paris"];
    [a48 setFoundationDate:[GMDate dateWithYear:1997 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a48];
    
    Author * a49 = [self.persistenceHelper newAuthor];
    [a49 setTitle:@"Raven Software"];
    [a49 setSite:@"http://www.ravensoft.com"];
    [a49 setCountry:@"USA"];
    [a49 setFoundationDate:[GMDate dateWithYear:1990 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a49];
    
    Author * a50 = [self.persistenceHelper newAuthor];
    [a50 setTitle:@"Remedy Entertainment"];
    [a50 setSite:@"http://www.remedygames.com"];
    [a50 setCountry:@"Finland, Espoo"];
    [a50 setFoundationDate:[GMDate dateWithYear:1995 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a50];
    
    Author * a51 = [self.persistenceHelper newAuthor];
    [a51 setTitle:@"Revolution Software"];
    [a51 setSite:@"http://revolution.co.uk"];
    [a51 setCountry:@"England, York"];
    [a51 setFoundationDate:[GMDate dateWithYear:1990 andMonth:3 andDay:1]];
    [self.persistenceHelper insertObject:a51];
    
    Author * a52 = [self.persistenceHelper newAuthor];
    [a52 setTitle:@"Rockstar Games"];
    [a52 setSite:@"http://www.rockstargames.com"];
    [a52 setCountry:@"USA, New York City"];
    [a52 setFoundationDate:[GMDate dateWithYear:1998 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a52];
    
    Author * a53 = [self.persistenceHelper newAuthor];
    [a53 setTitle:@"Running with Scissors"];
    [a53 setSite:@"http://www.postalgames.com"];
    [a53 setCountry:@"USA, Arizona"];
    [a53 setFoundationDate:[GMDate dateWithYear:1997 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a53];
    
    Author * a54 = [self.persistenceHelper newAuthor];
    [a54 setTitle:@"Splash Damage"];
    [a54 setSite:@"http://www.splashdamage.com"];
    [a54 setCountry:@"UK, London"];
    [a54 setFoundationDate:[GMDate dateWithYear:2001 andMonth:5 andDay:1]];
    [self.persistenceHelper insertObject:a54];
    
    Author * a55 = [self.persistenceHelper newAuthor];
    [a55 setTitle:@"Starbreeze Studios"];
    [a55 setSite:@"http://www.starbreeze.com"];
    [a55 setCountry:@"Sweden, Uppsala"];
    [a55 setFoundationDate:[GMDate dateWithYear:1998 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a55];
    
    Author * a56 = [self.persistenceHelper newAuthor];
    [a56 setTitle:@"Take Two Interactive"];
    [a56 setSite:@"http://www.take2games.com"];
    [a56 setCountry:@"USA, New York City"];
    [a56 setFoundationDate:[GMDate dateWithYear:1993 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a56];
    
    Author * a57 = [self.persistenceHelper newAuthor];
    [a57 setTitle:@"Team17"];
    [a57 setSite:@"http://www.team17.com"];
    [a57 setCountry:@"England"];
    [a57 setFoundationDate:[GMDate dateWithYear:1990 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a57];
    
    Author * a58 = [self.persistenceHelper newAuthor];
    [a58 setTitle:@"Tecmo Koei"];
    [a58 setSite:@"http://www.koeitecmo.co.jp"];
    [a58 setCountry:@"Japan, Yokohama"];
    [a58 setFoundationDate:[GMDate dateWithYear:2009 andMonth:4 andDay:1]];
    [self.persistenceHelper insertObject:a58];
    
    Author * a59 = [self.persistenceHelper newAuthor];
    [a59 setTitle:@"THQ"];
    [a59 setSite:@"http://www.thq.com"];
    [a59 setCountry:@"USA, California"];
    [a59 setFoundationDate:[GMDate dateWithYear:1989 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a59];
    
    Author * a60 = [self.persistenceHelper newAuthor];
    [a60 setTitle:@"Traveller's Tales"];
    [a60 setSite:@"http://www.ttgames.com"];
    [a60 setCountry:@"England, Knutsford"];
    [a60 setFoundationDate:[GMDate dateWithYear:1989 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a60];
    
    Author * a61 = [self.persistenceHelper newAuthor];
    [a61 setTitle:@"Treyarch"];
    [a61 setSite:@"http://www.treyarch.com"];
    [a61 setCountry:@"USA, California"];
    [a61 setFoundationDate:[GMDate dateWithYear:1996 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a61];
    
    Author * a62 = [self.persistenceHelper newAuthor];
    [a62 setTitle:@"Valve Corporation"];
    [a62 setSite:@"http://www.valvesoftware.com"];
    [a62 setCountry:@"USA, Washington"];
    [a62 setFoundationDate:[GMDate dateWithYear:1996 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a62];
    
    Author * a63 = [self.persistenceHelper newAuthor];
    [a63 setTitle:@"Wildfire Studios"];
    [a63 setSite:@"http://www.wildfire.com.au"];
    [a63 setCountry:@"Australia, Brisbane"];
    [a63 setFoundationDate:[GMDate dateWithYear:1995 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a63];
    
    Author * a64 = [self.persistenceHelper newAuthor];
    [a64 setTitle:@"Yuke's"];
    [a64 setSite:@"http://www.yukes.co.jp"];
    [a64 setCountry:@"Japan, Osaka"];
    [a64 setFoundationDate:[GMDate dateWithYear:1993 andMonth:2 andDay:26]];
    [self.persistenceHelper insertObject:a64];
    
    Author * a65 = [self.persistenceHelper newAuthor];
    [a65 setTitle:@"ZeniMax Online Studios"];
    [a65 setSite:@"http://www.zenimaxonline.com"];
    [a65 setCountry:@"USA, Maryland"];
    [a65 setFoundationDate:[GMDate dateWithYear:2007 andMonth:1 andDay:1]];
    [self.persistenceHelper insertObject:a65];
    
    Author * a66 = [self.persistenceHelper newAuthor];
    [a66 setTitle:@"Capcom"];
    [a66 setSite:@"http://www.capcom.com"];
    [a66 setCountry:@"Japan, Osaka"];
    [a66 setFoundationDate:[GMDate dateWithYear:1979 andMonth:5 andDay:30]];
    [self.persistenceHelper insertObject:a66];
    
    
    //
    // Save persistent store
    
    [self.persistenceHelper save];
}


@end
