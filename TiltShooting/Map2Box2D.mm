//
//  Map2Box2D.mm
//  TiltShooting
//
//  Created by yirui zhang on 9/30/12.
//
//

#import "Map2Box2D.h"
#import "Box2D.h"

#define BOX2D_WORLD_MAX_SIZE (100.0f)
#define DEFAULT_FLUSH_INTERVAL (1/60.0f)
#define DEFAULT_VELOCITY_INTERATION 8
#define DEFAULT_POSITION_INTERATION 3

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
    //b2World world(gravity);
    // init. static walls
    [self createWalls];
    NSLog(@"Box2D world init. complete.");
}

- (void) destoryWorld {
    if (world != NULL) {
        delete world;
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
    shape.SetAsBox([self c2b:20.0f], [self c2b:20.0f]);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    body->CreateFixture(&fixtureDef);
    target->box2dAux = body;
    NSLog(@"attach [%f, %f] to [%f, %f]", target.x, target.y,
          bodyDef.position.x, bodyDef.position.y);
}

- (void) deleteTarget: (Target *)target {
    world->DestroyBody((b2Body *)target->box2dAux);
    target->box2dAux = NULL;
}

- (void) step {
    world->Step(self.interval, self.velocityIterations, self.positionIterations);
    world->ClearForces();
}

- (Target *) locateTargetByX:(float)x y:(float)y {
    Target *ret = nil;
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(x, y);
    b2Body *body = world->CreateBody(&bodyDef);
    // now all bomb and enemy have the same size, which is 40 * 40
    b2PolygonShape shape;
    shape.SetAsBox(1.0f, 1.0f);
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &shape;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.3f;
    body->CreateFixture(&fixtureDef);

    if(world->GetContactCount()<2)
        return ret;
    for(b2Contact *contactlist=world->GetContactList();contactlist;contactlist=contactlist->GetNext())
    {
        if(!contactlist->IsTouching())
            continue;
        b2Fixture *fixtureA=contactlist->GetFixtureA();
        b2Fixture *fixtureB=contactlist->GetFixtureB();
        if(fixtureA->GetBody()==body)
        {
            b2Body *targetBody=fixtureB->GetBody();
            ret=(__bridge Target *)targetBody->GetUserData();
            break;
        }
        if(fixtureB->GetBody()==body)
        {
            b2Body *targetBody=fixtureA->GetBody();
            ret=(__bridge Target *)targetBody->GetUserData();
            break;
        }
    }
    //NSLog(@"shooting [%f, %f]", shootPos.x, shootPos.y);
    /*
    b2Transform transform;
    transform.SetIdentity();
    for (b2Body *b = world->GetBodyList(); b; b = b->GetNext()) {
        if (b->GetType() != b2_dynamicBody) {
            continue;
        }
        
        Target *t = (__bridge Target *)b->GetUserData();
        NSLog(@"testing target [%f, %f]", t.x, t.y);
        for (b2Fixture *f = b->GetFixtureList(); f; f = f->GetNext()) {
            s = f->GetShape();
            if (s->TestPoint(transform, shootPos)) {
                ret = (__bridge Target *)f->GetUserData();
                break;
            }// test point
        }// for each fixture
        if (ret != nil) {
            break;
        }
    }// for each body
     */
    return ret;
}

- (float) c2b: (float)fval {
    return fval / self.scale;
}

@end
