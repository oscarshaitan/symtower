import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

enum CrowdState { walkingLeft, walkingRight, hit }

const double crowdSize = 64;

class CrowdSprite extends SpriteAnimationGroupComponent<CrowdState> {
  CrowdSprite(this._isLeftSpawn) : super(size: Vector2.all(crowdSize), current: CrowdState.walkingRight);
  final bool _isLeftSpawn;

  @override
  Future<void> onLoad() async {
    current = _isLeftSpawn ? CrowdState.walkingRight : CrowdState.walkingLeft;
    await _setUpAnimations();
  }

  hitByBlock() {
    current = CrowdState.hit;
  }

  Future<void> _setUpAnimations() async {
    final SpriteSheet spriteSheet = SpriteSheet(image: await Flame.images.load('crowd/james.png'), srcSize: Vector2.all(32.0));

    final walkingAnimationRight = spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 6, to: 12);
    final walkingAnimationLeft = spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 18, to: 24);
    final hitAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, from: 0, to: 2, loop: true);

    animations = {
      CrowdState.walkingRight: walkingAnimationRight,
      CrowdState.walkingLeft: walkingAnimationLeft,
      CrowdState.hit: hitAnimation,
    };
  }
}
