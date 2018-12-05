import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:decorated_flutter/framework.dart';

void main() {
  test('dimens测试, 对应的dimen要对应的上', () {
    expect(kSpaceZero, 0.0);
    expect(kSpaceTiny, 1.0);
    expect(kSpaceSmall, 4.0);
    expect(kSpaceNormal, 8.0);
    expect(kSpaceLittleBig, 12.0);
    expect(kSpaceBig, 16.0);
    expect(kSpaceLarge, 24.0);
    expect(kSpaceHuge, 32.0);
    expect(kSpaceGiant, 64.0);

    expect(
      SPACE_ZERO,
      const SizedBox(width: kSpaceZero, height: kSpaceZero),
    );
    expect(
      SPACE_TINY,
      const SizedBox(width: kSpaceTiny, height: kSpaceTiny),
    );
    expect(
      SPACE_SMALL,
      const SizedBox(width: kSpaceSmall, height: kSpaceSmall),
    );
    expect(
      SPACE_NORMAL,
      const SizedBox(width: kSpaceNormal, height: kSpaceNormal),
    );
    expect(
      SPACE_LITTLE_BIG,
      const SizedBox(width: kSpaceLittleBig, height: kSpaceLittleBig),
    );
    expect(
      SPACE_BIG,
      const SizedBox(width: kSpaceBig, height: kSpaceBig),
    );
    expect(
      SPACE_LARGE,
      const SizedBox(width: kSpaceLarge, height: kSpaceLarge),
    );
    expect(
      SPACE_HUGE,
      const SizedBox(width: kSpaceHuge, height: kSpaceHuge),
    );
    expect(
      SPACE_GIANT,
      const SizedBox(width: kSpaceGiant, height: kSpaceGiant),
    );

    expect(kDividerTiny, const Divider(height: kSpaceTiny));
    expect(kDividerSmall, const Divider(height: kSpaceSmall));

    expect(kTextNormal, 16.0);
    expect(kTextBig, 18.0);

    expect(kElevationZero, 0.0);
    expect(kElevationTiny, 1.0);
    expect(kElevationSmall, 2.0);
    expect(kElevationNormal, 4.0);
    expect(kElevationBig, 8.0);
    expect(kElevationHuge, 16.0);
    expect(kElevationGiant, 32.0);
  });
}
