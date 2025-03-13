import 'dart:math';

class Coords {
  final double latitude;
  final double longitude;

  const Coords(this.latitude, this.longitude);
}

class CoordConvert {
  static final _xPi = pi * 3000.0 / 180.0;
  static final _a = 6378245.0;
  static final _ee = 0.00669342162296594323;

  static Coords bd09togcj02(Coords coords) {
    final double x = coords.longitude - 0.0065;
    final double y = coords.latitude - 0.006;
    final double z = sqrt(x * x + y * y) - 0.00002 * sin(y * _xPi);
    final double theta = atan2(y, x) - 0.000003 * cos(x * _xPi);
    final double ggLng = z * cos(theta);
    final double ggLat = z * sin(theta);
    return Coords(ggLat, ggLng);
  }

  static Coords bd09towgs84(Coords coords) {
    if (isOutOfChina(coords)) return coords;
    final gcj02Coords = bd09togcj02(coords);
    return gcj02towgs84(gcj02Coords);
  }

  static Coords gcj02tobd09(Coords coords) {
    final double z = sqrt(coords.longitude * coords.longitude +
            coords.latitude * coords.latitude) +
        0.00002 * sin(coords.latitude * _xPi);
    final double theta = atan2(coords.latitude, coords.longitude) +
        0.000003 * cos(coords.longitude * _xPi);
    final double bdLng = z * cos(theta) + 0.0065;
    final double bdLat = z * sin(theta) + 0.006;
    return Coords(bdLat, bdLng);
  }

  static Coords wgs84togcj02(Coords coords) {
    if (isOutOfChina(coords)) return coords;
    double dlat =
        _transformLat(Coords(coords.latitude - 35.0, coords.longitude - 105.0));
    double dlng =
        _transformLng(Coords(coords.latitude - 35.0, coords.longitude - 105.0));
    final double radlat = coords.latitude / 180.0 * pi;
    double magic = sin(radlat);
    magic = 1 - _ee * magic * magic;
    final double sqrtmagic = sqrt(magic);
    dlat = (dlat * 180.0) / ((_a * (1 - _ee)) / (magic * sqrtmagic) * pi);
    dlng = (dlng * 180.0) / (_a / sqrtmagic * cos(radlat) * pi);
    final double mglat = coords.latitude + dlat;
    final double mglng = coords.longitude + dlng;
    return Coords(mglat, mglng);
  }

  static Coords wgs84tobd09(Coords coords) {
    if (isOutOfChina(coords)) return coords;
    final gcj02Coords = wgs84togcj02(coords);
    return gcj02tobd09(gcj02Coords);
  }

  static Coords gcj02towgs84(Coords coords) {
    if (isOutOfChina(coords)) return coords;
    double dlat =
        _transformLat(Coords(coords.latitude - 35.0, coords.longitude - 105.0));
    double dlng =
        _transformLng(Coords(coords.latitude - 35.0, coords.longitude - 105.0));
    final double radlat = coords.latitude / 180.0 * pi;
    double magic = sin(radlat);
    magic = 1 - _ee * magic * magic;
    final double sqrtmagic = sqrt(magic);
    dlat = (dlat * 180.0) / ((_a * (1 - _ee)) / (magic * sqrtmagic) * pi);
    dlng = (dlng * 180.0) / (_a / sqrtmagic * cos(radlat) * pi);
    final double mglat = coords.latitude + dlat;
    final double mglng = coords.longitude + dlng;
    return Coords(coords.latitude * 2 - mglat, coords.longitude * 2 - mglng);
  }

  static double _transformLat(Coords coords) {
    double ret = -100.0 +
        2.0 * coords.longitude +
        3.0 * coords.latitude +
        0.2 * coords.latitude * coords.latitude +
        0.1 * coords.longitude * coords.latitude +
        0.2 * sqrt(coords.longitude.abs());
    ret += (20.0 * sin(6.0 * coords.longitude * pi) +
            20.0 * sin(2.0 * coords.longitude * pi)) *
        2.0 /
        3.0;
    ret += (20.0 * sin(coords.latitude * pi) +
            40.0 * sin(coords.latitude / 3.0 * pi)) *
        2.0 /
        3.0;
    ret += (160.0 * sin(coords.latitude / 12.0 * pi) +
            320 * sin(coords.latitude * pi / 30.0)) *
        2.0 /
        3.0;
    return ret;
  }

  static double _transformLng(Coords coords) {
    double ret = 300.0 +
        coords.longitude +
        2.0 * coords.latitude +
        0.1 * coords.longitude * coords.longitude +
        0.1 * coords.longitude * coords.latitude +
        0.1 * sqrt(coords.longitude.abs());
    ret += (20.0 * sin(6.0 * coords.longitude * pi) +
            20.0 * sin(2.0 * coords.longitude * pi)) *
        2.0 /
        3.0;
    ret += (20.0 * sin(coords.longitude * pi) +
            40.0 * sin(coords.longitude / 3.0 * pi)) *
        2.0 /
        3.0;
    ret += (150.0 * sin(coords.longitude / 12.0 * pi) +
            300.0 * sin(coords.longitude / 30.0 * pi)) *
        2.0 /
        3.0;
    return ret;
  }

  static bool isOutOfChina(Coords coords) => !(coords.longitude > 73.66 &&
      coords.longitude < 135.05 &&
      coords.latitude > 3.86 &&
      coords.latitude < 53.55);
}
