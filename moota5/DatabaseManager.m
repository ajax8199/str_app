//
//  DatabaseManager.m
//  StrengthApp
//
//  Created by Jonny Torcivia on 11/18/11.
//  Copyright (c) 2011 Elegance Applications. All rights reserved.
//

#import "DatabaseManager.h"
#import <stdlib.h>
#import "sqlite3.h"
#import "ExerciseObject.h"
#import "SQLiteManager.h"


#define DB_VERSION 1

@implementation DatabaseManager 

static DatabaseManager*_sharedDatabaseManager = nil;

+(id)sharedDatabaseManager
{
	@synchronized([DatabaseManager class])
	{
		if (!_sharedDatabaseManager)
			_sharedDatabaseManager = [[DatabaseManager alloc] init];
		return _sharedDatabaseManager;
	}
	return nil;
}

+(id)alloc
{
	@synchronized([DatabaseManager class])
	{
		NSAssert(_sharedDatabaseManager == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedDatabaseManager = [super alloc];
		return _sharedDatabaseManager;
	}
	return nil;
}



-(NSString*) returnLocalDay {
    // Set up local date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Date format
    dateFormatter.dateFormat = @"dd";
    // Set local timezone
    NSTimeZone *localTime = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTime];
    return [dateFormatter stringFromDate:[NSDate date]];
 
}
-(NSString*) returnLocalMonth {
    // Set up local date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Date format
    dateFormatter.dateFormat = @"MM";
    // Set local timezone
    NSTimeZone *localTime = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTime];
    return [dateFormatter stringFromDate:[NSDate date]];

}
-(NSString*) returnLocalYear {
    // Set up local date
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // Date format
    dateFormatter.dateFormat = @"yyyy";
    // Set local timezone
    NSTimeZone *localTime = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTime];
    return [dateFormatter stringFromDate:[NSDate date]];

}
-(NSString*) returnLocalTime {
    
    // get current date/time
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *currentTime = [dateFormatter stringFromDate:today];

    return currentTime;
    //NSLog(@"User's current time in their preference format:%@",currentTime);
    /*
    NSDate* sourceDate = [NSDate date];
    
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    
    NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
     */
}

-(NSDate*) returnLocalTimeNSDate {
    
    // get current date/time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // display in 12HR/24HR (i.e. 11:25PM or 23:25) format according to User Settings
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    
    NSDate *today = [NSDate date];
    NSLog(@"Time: %@", today);
    return today;
    
    //[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    //NSDate *theTime = [dateFormatter]
    //NSString *currentTime = [dateFormatter stringFromDate:today];
    //NSDate * curTime = [NSDate date];
    //return currentTime;
    //NSLog(@"User's current time in their preference format:%@",currentTime);
    /*
     NSDate* sourceDate = [NSDate date];
     
     NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
     NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
     
     NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:sourceDate];
     NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate];
     NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
     
     NSDate* destinationDate = [[NSDate alloc] initWithTimeInterval:interval sinceDate:sourceDate];
     */
}
/*
-(void) sendCreateTableSQL:(NSString*)stmt {
    // Assign the database information.
    // Not sure this is needed here.
    databaseName = @"myrecord.sqlite";
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    // Make sure the database exists
    bool checkdatabase = [self checkAndCreateDatabase];
    if (!checkdatabase) {
        NSLog(@"Copied over the database");
    }
    
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"myrecord.sqlite"];
    
    NSError *error = [dbManager doQuery:stmt];
    
    NSLog(@"Error when trying to create table: %@", error);
    
    // Run SQL
    
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = [stmt UTF8String];
        //sqlite3_stmt *compiledStatement;
        // Create the table
        if (sqlite3_exec(database, sqlStatement, NULL, NULL, NULL) != SQLITE_OK) {
            NSLog(@"Failed to create table.");
        }
    } else {
        NSLog(@"Failed to open/create database.");
    }
    
    
}
    
}
*/
/*
-(void) addRowToTable:(NSString *)stmt {
    
    dbManager = [[SQLiteManager alloc] initWithDatabaseNamed:@"myrecord.sqlite"];
    
    NSError *error = [dbManager doQuery:stmt];
    
    NSLog(@"Error when trying to add row: %@", error);
    // Run SQL
    
    
    sqlite3 *database;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
        const char *sqlStatement = [stmt UTF8String];
        // Create the table
        if (sqlite3_exec(database, sqlStatement, NULL, NULL, NULL) != SQLITE_OK) {
            NSLog(@"Failed to add row.");
        }
    } else {
        NSLog(@"Failed to open/create database.");
    }
     
    
}

-(void) saveExerciseData:(ExerciseObject*)exercise {

    // Create Table if it doesn't exist.
    
	[self sendCreateTableSQL:[NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS X%d (id INTEGER, setnumber INTEGER, day INTEGER, month INTEGER, year INTEGER, WO_Reps INTEGER, WO_Weight FLOAT)", [exercise returnID]]];
    
    NSLog(@"SQL Statement: INSERT INTO X%d VALUES (%d, %d, %d, %d, %d, %d, %f)", [exercise returnID], [exercise returnCurrentSet], 1, [[self returnLocalDay] intValue], [[self returnLocalMonth] intValue], [[self returnLocalYear] intValue], [exercise returnReps], [exercise returnWeight]);
    
    // Add set data to exercise table
    [self addRowToTable:[NSString stringWithFormat:@"INSERT INTO X%d VALUES (%d, %d, %d, %d, %d, %d, %f)", [exercise returnID], [exercise returnCurrentSet], 1, [[self returnLocalDay] intValue], [[self returnLocalMonth] intValue], [[self returnLocalYear] intValue], [exercise returnReps], [exercise returnWeight]]];
    
}
*/




-(void) verify:(NSString*)database
{
	//databaseName = @"strengthtrainer.sqlite";
	
    databaseName = database;
    
	//Get the path to the documents directory and append the database name
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	//NSLog(@"DATABASE PATH: %@", databasePath);
    
	if ([self checkAndCreateDatabase]) {
		NSLog(@"TRUE - database exists");
        //DB already exists
		//Check to see if correct version
		/*
         int versionNumber = [self checkDatabaseVersion];
         if (versionNumber == DB_VERSION) {
         NSLog(@"Updated Database");
         //Updated databes, no need to do any more
         } else {
         //need to rewrite database
         NSLog(@"ReWrite Database");
         [self rewriteDatabase];
         } */
	}	
}

-(void) rewriteDatabase
{
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
	// Remove the old database first
	[fileManager removeItemAtPath:databasePath error:nil];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];		
}

-(BOOL) checkAndCreateDatabase {
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
	
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
	
	// If the database already exists then return without doing anything
	if(success) return TRUE;
	
	// If not then proceed to copy the database from the application to the users filesystem
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
	
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
	
	return FALSE;	
}


@end
