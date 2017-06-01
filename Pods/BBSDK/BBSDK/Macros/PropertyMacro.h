//
//  PropertyMacro.h
//  BBSDK
//
//  Created by Dongjw on 17/5/11.
//  Copyright © 2017年 sinyee.babybus. All rights reserved.
//

#ifndef PropertyMacro_h
#define PropertyMacro_h

#define	prop_readonly( type, name )		property (nonatomic, readonly) type name;
#define	prop_dynamic( type, name )		property (nonatomic, strong) type name;
#define	prop_assign( type, name )		property (nonatomic, assign) type name;
#define	prop_strong( type, name )		property (nonatomic, strong) type name;
#define	prop_weak( type, name )			property (nonatomic, weak) type name;
#define	prop_copy( type, name )			property (nonatomic, copy) type name;
#define	prop_unsafe( type, name )		property (nonatomic, unsafe_unretained) type name;

#endif /* PropertyMacro_h */
