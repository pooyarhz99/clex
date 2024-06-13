#include <Foundation/Foundation.h>
#include <stdio.h>

/*
Table of Contents:
- Object-oriented Programming Demo
- Protocols Demo
*/

@class CMyClass; // Forward Declared Class

void demo_classes(void);

int main(void) {
	// when you are in the run loop of an application, there's a default autorelease pool created for you
	// however, when you're running your own `main`, you need to create an autorelease pool manually at the top of your main, and drain it periodically
	// your code must be in between there
	
	/*
	Note: LLVM provides an @autoreleasepool feature
		@autoreleasepool {
			// your code
		}
	*/
	
	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

	// Write all your Objective-C code here...

	NSLog(@"Welcome To Objective-C");

	demo_classes(); // Replace this with the demo you'd like to run
	
	[pool drain];
	return 0;
}






// Object-oreinted Programming Demo

@interface CMyClass : NSObject
@property NSString *name;

- (void) instanceMethod;
+ (void) classMethod;    // Also called static method (cannot access instance variables)
@end

@implementation CMyClass
	- (void) instanceMethod {
		printf("Instance method is called.\n");
	}

	+ (void) classMethod {
		printf("Class method is called.\n");
	}
@end


@interface CMethods : NSObject
- (void) Method_Without_Param;
- (void) Method_With_One_Param:(int) a;
- (void) Method_With_Two_Params:(int) a :(int) b;
- (void) Method_With_Three_Params: (int) a :(int) b :(int) c;
- (void) Named_Args:(int) a OtherParam:(int) b;
@end

@implementation CMethods
- (void) Method_Without_Param {
	printf("Method called with no parameters.\n");
}
- (void) Method_With_One_Param: (int) a {
	printf("Method called with %d.\n", a);
}
- (void) Method_With_Two_Params: (int) a : (int) b {
	printf("Method called with %d and %d.\n", a, b);
}
- (void) Method_With_Three_Params: (int) a : (int) b : (int) c {
	printf("Method called with %d, %d and %d.\n", a, b, c);
}
- (void) Named_Args:(int) a OtherParam:(int) b {
	printf("Method called with Param1=%d and Param2=.%d\n", a, b);
}
@end


void demo_classes() {
	CMyClass *object1 = [[CMyClass alloc] init];
	[object1 instanceMethod];
	[CMyClass classMethod];

	printf("\n");

	CMethods *object2 = [[CMethods alloc] init];
	[object2 Method_Without_Param];
	[object2 Method_With_One_Param: 3];
	[object2 Method_With_Two_Params: 3:5];
	[object2 Method_With_Three_Params: 3:5:9];
	[object2 Named_Args:8 OtherParam:11];

	// The receiver object can be nil.

	// If the receiver object is nil, then the call is ignored (where in C++ it
	// throw a pointer violation exception).

	// So you don't need to check against nil references.
}






// Protocols Demo

// A protocol is an abstract class.

// The difference between C++ and Objective-C is that in Objective-C, the
// functions are not required to be implemented. You can have forced an optional
// methods, but this is merely a hint to the compiler and not a requirement for
// compilation.

@protocol PMyProtocol
- (void) someMethod;
@end

@interface CMyProtocol : NSObject<PMyProtocol>
@end

@implementation CMyProtocol
- (void) someMethod {
	printf("CMyProtocol implementation of someMethod.\n");
}
@end

/*
The equivalent C++ code would be:

class PMyProtocol {
	virtual void someMethod() = 0;
};

class CMyProtocol : public PMyProtocol {
	void someMethod() { }
};
*/

void protocols_demo() {
}
