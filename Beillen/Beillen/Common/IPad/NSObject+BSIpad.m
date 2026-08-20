//
//  NSObject+BSIpad.m
//  Beillen
//
//  Created by jy w on 2024/3/6.
//  Copyright © 2024 Beillen.All rights reserved.
//

#import "NSObject+BSIpad.h"
#import "BSIPadScreenTool.h"
@implementation NSObject (BSIpad)
-(CGFloat)screenWidth:(CGSize)size{
    return [self screenSize:size].width;
}

-(CGFloat)screenHeight:(CGSize)size{
    return [self screenSize:size].height;
}

-(CGSize)screenSize:(CGSize)size{
    if (size.width > 0 && size.height > 0) {
        return size;
    }
    if(isIpad){
        size = [BSIPadScreenTool shareInstance].screenSize;
        if (size.width > 0 && size.height > 0) {
            return size;
        }
    }
    return [UIScreen mainScreen].bounds.size;
}

-(CGFloat)screenMaxWidth:(CGFloat)width max:(CGFloat)max margin:(CGFloat)margin
{
    NSLog(@"screenMaxWidth-0-width: %f, max: %f, margin: %f",width,max,margin);
    if(width == 0){
        width = [self screenWidth:CGSizeZero];
    }
    width = width > (max + margin) ? max : (width - margin);
    NSLog(@"screenMaxWidth-1-width: %f",width);
    return width;
}

- (CGFloat)screenFillWidth:(CGSize)size max:(CGFloat)max{
    if(size.width == 0){
        size = [self screenSize:CGSizeZero];
    }
    if (size.width >= size.height) {
        if(size.width > max){
            return max;
        }else{
            return size.width;
        }
    }
    return size.width;
}

#pragma mark - notification
-(void)addRefreshIpadScreenSizeNotification{
    if(isIpad){
        kPrintSelf
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleScreenResize:) name:kBSRefreshScreenSizeNotification object:nil];
    }
}

-(void)removeRefreshIpadScreenSizeNotification{
    if(isIpad){
        kPrintSelf
        [[NSNotificationCenter defaultCenter]removeObserver:self];
    }
}

-(void)handleScreenResize:(NSNotification *)notice{
    if([self respondsToSelector:@selector(refreshIpadScreenSizeAction:)]){
        CGSize size = [notice.object CGSizeValue];
        NSLog(@"handleScreenResize-width: %f , height: %f", size.width,size.height);
        [self refreshIpadScreenSizeAction:size];
    }
}
@end
