//
//  TeamboxActivitiesParser.h
//  Teambox
//
//  Created by Alejandro Julián López on 26/02/10.
//  Copyright 2010 Teambox. All rights reserved.
//

#import "TeamboxEngineHeaders.h"
#import "TeamboxParser.h"
#import "ProjectModel.h"

@interface TeamboxActivitiesParser : TeamboxParser {
	ProjectModel* selectedProject;
}

@end
