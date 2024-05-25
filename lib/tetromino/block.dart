import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

enum Material { marvel, rock, stone }

enum TileStyle { tile_0000, tile_0001, tile_0002, tile_0003, tile_0006, tile_0011, tile_0013, tile_0016, tile_0021 }

(Material, TileStyle) randomBlockSprite() {
  return (Material.values.random(), TileStyle.values.random());
}

const double size = 3;
final fixture = FixtureDef(
  PolygonShape()
    ..set([
      Vector2(-(size / 2), (size / 2)),
      Vector2((size / 2), -(size / 2)),
      Vector2(-(size / 2), -(size / 2)),
      Vector2((size / 2), (size / 2)),
    ]),
  restitution: 0,
  density: 10,
  friction: 1,
);

final fixtureFoundation = FixtureDef(
  PolygonShape()
    ..set([
      Vector2(-(size / 2), (size / 2)),
      Vector2((size / 2), -(size / 2)),
      Vector2(-(size / 2), -(size / 2)),
      Vector2((size / 2), (size / 2)),
    ]),
  restitution: 0,
  density: 1000000,
  friction: 1,
);

class TetrominoBlock extends BodyComponent with TapCallbacks {
  final (Material, TileStyle)? blockSprite;
  final bool isFoundation;

  final Vector2? initialPosition;

  TetrominoBlock({this.initialPosition, this.blockSprite, this.isFoundation = false})
      : assert((!isFoundation && blockSprite != null) || (isFoundation && blockSprite == null)),
        super(renderBody: false);

  @override
  Future<void> onLoad() async {
    fixtureDefs = [isFoundation ? fixtureFoundation : fixture];
    bodyDef = BodyDef(
      angularDamping: 0.8,
      position: initialPosition ?? Vector2.zero(),
      type: BodyType.dynamic,
    );
    add(SpriteComponent(
        sprite: await Sprite.load(
            isFoundation ? 'blocks/sand/tile_0025.png' : 'blocks/${blockSprite!.$1.name}/${blockSprite!.$2.name}.png'),
        anchor: Anchor.center,
        size: Vector2.all(size)));
    super.onLoad();
  }

  @override
  void onTapDown(_) {
    applyWind(25);
    affectFriction(0);
  }

  void multiplyGravity(double multiplier) {
    if (!isFoundation) {
      body.gravityScale = Vector2.all(multiplier);
    }
  }

  void affectFriction(double newFriction) {
    if (!isFoundation) {
      body.fixtures.first.friction = newFriction;
    }
  }

  /// positive speed will move the block to the right, negative to the left
  void applyWind(double windSpeed) {
    if (!isFoundation) {
      body.linearVelocity = Vector2(windSpeed, 0);
    }
  }
}
