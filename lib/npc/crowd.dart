import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:symtower/main.dart';

enum CrowdState { walkingLeft, walkingRight, hit }

const double crowdSize = 8;

class Crowd extends SpriteAnimationGroupComponent<CrowdState> with HasGameReference<SymTower> {
  Crowd() : super(size: Vector2.all(crowdSize), current: CrowdState.walkingRight);

  @override
  Future<void> onLoad() async {
    _setUpSpawn();
    _setUpHitBoxes();
    await _setUpAnimations();
  }

  Future<void> _setUpAnimations() async {
    final SpriteSheet spriteSheet = SpriteSheet(image: await Flame.images.load('crowd/james.png'), srcSize: Vector2.all(32.0));

    final walkingAnimationRight = spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 6, to: 12);
    final walkingAnimationLeft = spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 18, to: 24);
    final hitAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.2, from: 0, to: 1);
    debugMode = true;
    animations = {
      CrowdState.walkingRight: walkingAnimationRight,
      CrowdState.walkingLeft: walkingAnimationLeft,
      CrowdState.hit: hitAnimation,
    };
  }

  void _setUpSpawn() {
    position = game.camera.visibleWorldRect.bottomLeft.toVector2()..add(Vector2(-crowdSize, -crowdSize));
  }

  _setUpHitBoxes() {}

  @override
  void update(double dt) async {
    position.x += dt * 8;
    super.update(dt);
  }
}
