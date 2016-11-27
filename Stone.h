//
//  Stone.h
//  goscore-rust
//
//  Created by Caleb Jones on 11/27/16.
//  Copyright © 2016 Caleb Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stone : NSObject
-(instancetype)initWithValue:(char)value;
-(bool)isPresent;
-(bool)isDead;
@end
