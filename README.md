TiltShooting
============
Change List (Oct 30, 2012):

Please read and change the view to fit the new interface, now the project can't run :)

Target:
1. Target now has  status, which is a enum TARGET_STATU.
2. Target has blood, mana and bonus.
3. Now Bomb is a type of target and will decrease time by x sec
4. Now Enemy is a type of target and the user can win 1 bonus, 10 score when the target disappeared.
Model Interface:
1. Add score, time, bonus to support score system. Bonus is used to represent the value of a target. Many places use bonus to compute their value, and we can treat bonus as a currency. Currently, weapon uses bonus to increase their mana so that we can use its skill. The compute of score is separate from bonus so that we can support different score system, for example, if the user hit 10 targets in a given time then the score will be doubled. Time is used to increase the speed of the game.
Shoot (both normal and special shoot) now support multiple shoot in a very short time. 
2. [important!!!!] No bomb list or enemy list anymore, now we only have target list. The reason is that the type of target is not limit to enemy and bomb, I have designed several target types and will post it later.
3. Please user setCurrentWeapon to change the weapon. You can get the previous or next weapon by using the [NSMutableArray indexOfObject] function to get the position of the currentWeapon and then use it to get the next weapon or previous weapon if it exists.
4. Add weaponList 
5. The model will flush the time every second.
CoreEventListener:
1. Time, score event.
2. WeaponManeChange event.
3. Add prepareToDisappear event.
4. No win or lose event, now we only have game finish event. The reason is that we only use time to indicate the terminate condition. And enemy will always be created if the user still has time. And the user can earn time or lose time by hitting different targets, it all depends on the behavior of the target.
Weapon:
1. new WeaponBase class, support speed, damage, price* (not used), bulletRemain, bulletCapacity , mana, skillMana (radius is not a property since the shoot performance for  each weapon is quiet different and some weapons may not need radius like screen bomb).
2. Add Desert Edge weapon.
Next:
1. Optimize event notify mechanism: send all events after a running step.
2. Add more target type and weapon.
3 Complete Box2D function