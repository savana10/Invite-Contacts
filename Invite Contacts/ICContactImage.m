//
//  ICContactImage.m
//  Invite Contacts
//
//  Created by Savana on 22/08/2014.
//  Copyright (c) 2014 Savana. All rights reserved.
//

#import "ICContactImage.h"

@implementation ICContactImage
+ (UIImage *)imageForContact:(ICContact *)contact WithBG:(UIColor *) color;
{
    UIView *view=[self viewForString:contact WithBG:color];
    view.layer.cornerRadius= view.frame.size.height/2;
    view.clipsToBounds=true;
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, [[UIScreen mainScreen] scale]);
    //[view drawViewHierarchyInRect:view.frame afterScreenUpdates:TRUE];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor clearColor] set];
    CGContextSetRGBFillColor(context, 0,0,0, 0);
    CGContextFillRect(context, (CGRect){CGPointZero,view.frame.size});
    
    [view.layer renderInContext:context];
    
    
    UIImage *viewImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}
+ (UIView *)viewForString:(ICContact  *)contact WithBG:(UIColor *) color
{
    UIView *v=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    UILabel *l=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [l setFont:[UIFont fontWithName:@"Avenir Light" size:20.0f]];
    [l setTextAlignment:NSTextAlignmentCenter];
    [l setTextColor:[UIColor whiteColor]];
   
    NSString *tc=@"";
    
    if (contact.firstName!= nil) {
        tc=[NSString stringWithFormat:@"%c",[contact.firstName characterAtIndex:0]];
    }
    if (contact.lastName != nil) {
        tc=[tc stringByAppendingString:[NSString stringWithFormat:@"%c",[contact.lastName characterAtIndex:0]]];
    }
    
    [l setText:tc];
    [v setBackgroundColor:color];
    [v addSubview:l];
    v.layer.cornerRadius=v.frame.size.height/2;
    
    [v setClipsToBounds:true];
    
    return v;
}

@end
