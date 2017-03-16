//
//  Graph.h
//  PageRank
//
//  Created by Alexander Drovnyashin on 07.03.17.
//  Copyright © 2017 Alexander Drovnyashin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GraphObj : NSObject

@property NSString *link;
@property NSMutableSet <NSString *> *relations;
@property (nonatomic, assign) double rankPage;
@property BOOL downlFlag;

- (instancetype)initWithLink:(NSString *)link;
- (void)addRelation:(GraphObj *)graph;

@end
