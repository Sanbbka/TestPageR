//
//  Constructor.h
//  PageRank
//
//  Created by Alexander Drovnyashin on 07.03.17.
//  Copyright © 2017 Alexander Drovnyashin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ViewController.h"

@interface Constructor : NSObject

@property (nonatomic, weak) ViewController *vc;

- (void)fillGraph;

@end
