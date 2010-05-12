//
//  UploadModel.h
//  Teambox Mac
//
//  Created by Alejandro JL on 12/05/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>

@class CommentModel;

@interface UploadModel :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * asset_file_name;
@property (nonatomic, retain) NSString * asset_content_type;
@property (nonatomic, retain) NSString * description_;
@property (nonatomic, retain) NSNumber * asset_file_size;
@property (nonatomic, retain) NSNumber * user_id;
@property (nonatomic, retain) NSNumber * project_id;
@property (nonatomic, retain) CommentModel * Comment;

@end



