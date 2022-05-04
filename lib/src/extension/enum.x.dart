import '../utils/utils.export.dart';

extension EnumX on Enum {
  bool operator >(Enum other) {
    return index > other.index;
  }

  bool operator >=(Enum other) {
    return index >= other.index;
  }

  bool operator <(Enum other) {
    return index < other.index;
  }

  bool operator <=(Enum other) {
    return index <= other.index;
  }
}

extension ConstellationX on Constellation {
  String get name {
    return const [
      '摩羯座',
      '水瓶座',
      '双鱼座',
      '白羊座',
      '金牛座',
      '双子座',
      '巨蟹座',
      '狮子座',
      '处女座',
      '天秤座',
      '天蝎座',
      '射手座',
      '未知',
    ][index];
  }
}

extension GenderX on Gender {
  String get name {
    switch (this) {
      case Gender.male:
        return '男';
      case Gender.female:
        return '女';
      case Gender.unknown:
        return '未知';
    }
  }
}
