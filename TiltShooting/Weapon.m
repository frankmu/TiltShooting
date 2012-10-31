//
//  Weapon.m
//  TiltShooting
//
//  Created by yan zhuang on 12-10-20.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Weapon.h"


@implementation Weapon

@synthesize image;
@synthesize ammo;
@synthesize currentAmmo;
@synthesize clipAmmo;
@synthesize currentClipAmmo;
@synthesize aim;
@synthesize radius;

-(id)initWithType:(int)type{

    //init the properties based on type
    
    switch (type) {
        case 1://handgun
            NSLog(@"init weapon type 1 info");
            image=@"handgun.png";
            ammo=9999;
        
            clipAmmo=7;
            aim=@"aimcross.png";
            radius=0;
            break;
            
        case 2://ak104
            NSLog(@"init weapon type 2 info");
            image=@"ak104.png";
            ammo=1000;
            clipAmmo=30;
            aim=@"aimcross.png";
            radius=15;
            break;
        default:
            break;
    }
    currentAmmo=ammo;
    currentClipAmmo=currentAmmo;
    return self;
}
@end
