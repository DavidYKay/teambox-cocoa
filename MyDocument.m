//
//  MyDocument.m
//  Teambox-Engine
//
//  Created by Alejandro JL on 26/03/10.
//  Copyright __MyCompanyName__ 2010 . All rights reserved.
//

#import "MyDocument.h"
#import "ProjectModel.h"
#import "Project_UserModel.h"
#import "UserModel.h"

@implementation MyDocument

- (id)init 
{
    self = [super init];
    if (self != nil) {
        engine = [[TeamboxEngine alloc] initWithDelegate:self];
    }
    return self;
}

- (NSString *)windowNibName 
{
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)windowController 
{
    [super windowControllerDidLoadNib:windowController];
	[engine getProjects];
    // user interface preparation code
}

- (void)postComment {
}


- (void)activitiesReceivedAll:(NSArray *)activities {

}

- (void)activitiesReceivedAllNew:(NSArray *)activities {

}


- (void)activitiesReceivedAllMore:(NSArray *)activities {

}

- (void)projectsReceived:(NSArray *)activities {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	// Edit the entity name as appropriate.
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project" inManagedObjectContext:managedObjectContext];
	[fetchRequest setEntity:entity];
	
	// Edit the sort key as appropriate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"project_id" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	
	[fetchRequest setSortDescriptors:sortDescriptors];
	
	// Edit the section name key path and cache name if appropriate.
	// nil for section name key path means "no sections".
	NSError *error = nil;
	NSArray *projectsArray = [managedObjectContext  executeFetchRequest:fetchRequest error:&error];
	for (int i=0;i<[projectsArray count];i++){
		ProjectModel* aProject = [projectsArray objectAtIndex:i];
		NSString* sLog=[NSString stringWithFormat:@"Project  :%@   Id:%i",aProject.name ,aProject.project_id];
		NSLog(sLog);
		sLog = [NSString stringWithFormat:@"permalink:%@   archived:%i",aProject.permalink ,aProject.archived];
		NSLog(sLog);
		NSArray* projects_usersArray = [[NSArray alloc] initWithArray:[aProject.Project_User allObjects]];
		for (int j=0;j<[projects_usersArray count];j++)
		{
			Project_UserModel* pum=[projects_usersArray objectAtIndex:i];
			
			sLog = [NSString stringWithFormat:@"User %i:%@   archived:%i",pum.User.username ,pum.User.person_id];
			NSLog(sLog);
		}
		NSLog(@"------------------------------------------------------");
	}
}

- (void)activitiesReceivedNothing:(NSString *)type {

}

@end
