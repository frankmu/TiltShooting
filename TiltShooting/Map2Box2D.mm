//
//  Map2Box2D.mm
//  TiltShooting
//
//  Created by yirui zhang on 9/30/12.
//
//

#import "Map2Box2D.h"
#import "Box2D.h"
#import "Model.h"

#define BOX2D_WORLD_MAX_SIZE (20.0f)
#define DEFAULT_FLUSH_INTERVAL (1/60.0f)
#define DEFAULT_VELOCITY_INTERATION 8
#define DEFAULT_POSITION_INTERATION 3
#define DEFAULT_TIMEPLUS_SPEED 5
#define DEFAULT_TIMEMIUS_SPEED 3

@interface Map2Box2D() {
    b2World *world;
}

@property float width, height;
@property float scale;
@property float interval;
@property int32 velocityIterations;
@property int32 positionIterations;
@end

@implementation Map2Box2D

@synthesize width = _width, height = _height;
@synthesize interval = _interval;
@synthesize velocityIterations = _velocityIterations;
@synthesize positionIterations = _positionIterations;

- (id) init {
    if (self = [super init]) {
        // init. conf. parameters
        self.interval = DEFAULT_FLUSH_INTERVAL;
        self.velocityIterations = DEFAULT_VELOCITY_INTERATION;
        self.positionIterations = DEFAULT_POSITION_INTERATION;
    }
    return self;
}

- (void) dealloc { 
    if (world != NULL) {
        delete world;
    }
}

- (void) createWalls {
    // create walls
    b2BodyDef bodyDef;
    bodyDef.position.Set(0.0f, 0.0f);
    bodyDef.type = b2_staticBody;
    bodyDef.active = true;
    bodyDef.allowSleep = false;
    b2Body *body = world->CreateBody(&bodyDef);
    b2Vec2 vs[4];
    vs[0].Set(0.0f, 0.0f);
    vs[1].Set(self.width, 0.0f);
    vs[2].Set(self.width, self.height);
    vs[3].Set(0.0f, self.height);
    b2ChainShape chain;
    chain.CreateLoop(vs, 4);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &chain;
    fixtureDef.density = 0.0f;
    body->CreateFixture(&fixtureDef);
}

- (void) createWorldWithWidth:(float)width height:(float)height {
    float whRate = width / height;
    // init. width && height
    self.width = BOX2D_WORLD_MAX_SIZE;
    self.height = BOX2D_WORLD_MAX_SIZE / whRate;
    self.scale = width / self.width;
    // create box2d world
    b2Vec2 gravity(0.0f, 0.0f);
    world = new b2World(gravity);
    world->SetContinuousPhysics(true);
    // init. static walls
    [self createWalls];
}

- (void) destoryWorld {
    if (world != NULL) {
        delete world;
        world = NULL;
    }
}

- (void) attachTarget: (Target *)target {
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set([self c2b:target.x], [self c2b:target.y]);
    bodyDef.userData = (__bridge void *)target;
    b2Body *body = world->CreateBody(&bodyDef);
    // now all bomb and enemy have the same size, which is 40 * 40
    b2PolygonShape shape;
    shape.SetAsBox([self c2b:target.width/2], [self c2b:target.height/2]);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 10.0f;
    fixtureDef.friction = 10.0f;
    fixtureDef.restitution= 0.8f;
    body->CreateFixture(&fixtureDef);
    target->box2dAux = body;
   float x,y;
    switch ([Model targetType:target]) {
        case TYPE_ENEMY:
            x=rand()%5;
            x=x/10.0;
            x+=1;
            y=rand()%5;
            y=y/10;
            y+=1;
            break;
        case TYPE_TIME_MINUS:
            x=rand()%5;
            x=x/10.0;
            x+=DEFAULT_TIMEMIUS_SPEED;
            y=rand()%5;
            y=y/10;
            y+=DEFAULT_TIMEMIUS_SPEED;
            break;
        case TYPE_TIME_PLUS:
            x=rand()%5;
            x=x/10.0;
            x+=DEFAULT_TIMEPLUS_SPEED;
            y=rand()%5;
            y=y/10;
            y+=DEFAULT_TIMEPLUS_SPEED;
            break;
        default:
            x=0;
            y=0;
            break;
    }
    int level=[[Model instance] currentLevel];
    x+=0.2*level;
    y+=0.2*level;
    if(rand()%2==0)
        x=-x;
    if(rand()%2==0)
        y=-y;
    [self setMove:target :x :y];
    NSLog(@"attach [%f, %f] to [%f, %f]", target.x, target.y, bodyDef.position.x, bodyDef.position.y);
}

- (void) deleteTarget: (Target *)target {
    b2Body *body = (b2Body *)target->box2dAux;
    if (body == NULL) return;
    world->DestroyBody(body);
    target->box2dAux = NULL;
}

- (void) step {
    if (world->IsLocked()) return;
    world->Step(self.interval, self.velocityIterations, self.positionIterations);
    
//    NSLog(@"start_________");
//    int count=0;
//    
    for (b2Body *b = world->GetBodyList(); b; b = b->GetNext())
    {
        Target* t = (__bridge Target*)b->GetUserData();
        b2Vec2 p =  b->GetPosition();
        t.x = [self b2c:p.x];
        t.y = [self b2c:p.y];
    }
//    NSLog(@"++++++++ %d",count);
//     
//    NSLog(@"end________");
    
}

- (void) setMove:(Target *)target :(float)x :(float)y{
    b2Body *body=(b2Body *)target->box2dAux;
    b2Vec2 direction;
	direction.Set(x,y);
	body->SetLinearVelocity(direction);
    target->box2dAux=body;
}

-(void)separateTarget:(Target *)target{
    float x=target.x;
    float y=target.y;
    b2Body *body=(b2Body *)target->box2dAux;
    world->DestroyBody(body);
    id<ModelFullInterface> m = [[Model class] instance];
    Enemy *enemy=(Enemy *)target;
    [m deleteTarget:enemy];
    int num=rand()%3+4	;
    for(int i=0;i<num;i++)
    {
        double temp=tan((i*(360/num)+180.0/num)/180*3.141);
        Enemy *enemy = [[Enemy alloc] initWithX: x Y: y hp:10];
        [self attachTarget:enemy];
        [self setMove:enemy :5.0 :(5.0*temp)];
        [m deleteTarget:enemy];
    }
    
}


- (Target *) locateTargetByX:(float)x y:(float)y {
    float tx = [self c2b:x-1];
    float ty = [self c2b:y-1];
    float tx1=[self c2b:x+1];
    float ty1=[self c2b:y+1];
    class MyQueryCallback : public b2QueryCallback
    
    {
        
    public:
        MyQueryCallback(){retBody = NULL;}
        b2Body* retBody;
        bool ReportFixture(b2Fixture* fixture)
        
        {
            
            b2Body* body = fixture->GetBody();
            retBody = body;
            // Return true to continue the query.
            return true;
            
        }
        
    };
    MyQueryCallback callback;
    
    b2AABB aabb;
    
    aabb.lowerBound.Set(tx, ty);
    
    aabb.upperBound.Set(tx1, ty1);
    
    world->QueryAABB(&callback, aabb);
    
    Target* t = NULL;
    if (callback.retBody != NULL) {
         t = (__bridge Target*)(callback.retBody->GetUserData());
    }
    
    NSLog(@"[%f, %f] %@", x, y, t);
    return t;
}
- (NSMutableArray *)locateRangeTargetX:(float)x y:(float)y :(float)width :(float)height{
    float tx = [self c2b:x-width/2];
    float ty = [self c2b:y-height/2];
    float tx1=[self c2b:x+width/2];
    float ty1=[self c2b:y+height/2];
    class MyQueryCallback : public b2QueryCallback
    {
        
    public:
        MyQueryCallback(){retBody=[NSMutableArray arrayWithCapacity:100];}
        NSMutableArray* retBody;
        bool ReportFixture(b2Fixture* fixture)
        
        {
            
            b2Body* body = fixture->GetBody();
            if (body == NULL) return true;
            Target* t = (__bridge Target*)body->GetUserData();
            if (t == nil) return true;
            [retBody addObject: t];
            // Return true to continue the query.
            return true;
            
        }
        
    };
    MyQueryCallback callback;
    
    b2AABB aabb;
    
    aabb.lowerBound.Set(tx, ty);
    
    aabb.upperBound.Set(tx1, ty1);
    
    world->QueryAABB(&callback, aabb);

    return callback.retBody;

}

- (float) c2b: (float)fval {
    return fval / self.scale;
}

- (float) b2c: (float)fval {
    return fval * self.scale;
}

- (BOOL) isLock {
    return world->IsLocked();
}
@end
