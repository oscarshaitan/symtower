import 'package:flame/extensions.dart';

enum Material { marvel, rock, stone }

enum TileStyle {
  tile_0000,
  tile_0001,
  tile_0002,
  tile_0003,
  tile_0006,
  tile_0011,
  tile_0013,
  tile_0016,
  tile_0021,
}

({Material material, TileStyle style}) randomBlockSprite() {
  return (
    material: Material.values.random(),
    style: TileStyle.values.random(),
  );
}

const double tileSize = 18;
