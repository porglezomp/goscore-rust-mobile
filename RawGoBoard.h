//
//  GoBoard.h
//  goscore-rust
//
//  Created by Caleb Jones on 11/27/16.
//  Copyright © 2016 Caleb Jones. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RawGoBoard : NSObject
@property size_t width;
@property size_t height;

- (instancetype)initWithBuffer:(NSArray*)buffer width:(size_t)width height:(size_t)height;
- (instancetype)initWithWidth:(size_t)width height:(size_t)height;
- (instancetype)init;

- (void)guessDeadStones;
- (void)scoreStones;
- (int)scoreSumsWithKomi:(uint)komi blackScore:(uint*)black whiteScore:(uint*)white;

- (char)rawValueAtRow:(uint)row column:(uint)column;
- (void)setRawValueAtRow:(uint)row column:(uint)column value:(char)value;
@end
