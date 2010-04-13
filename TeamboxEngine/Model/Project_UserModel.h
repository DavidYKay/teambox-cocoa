//
//  Project_UserModel.h
//  Teambox
//
//  Created by Alejandro JL on 13/04/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class ProjectModel;
@class UserModel;

@interface Project_UserModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * created_at;
@property (nonatomic, retain) ProjectModel * Project;
@property (nonatomic, retain) UserModel * User;

@end



