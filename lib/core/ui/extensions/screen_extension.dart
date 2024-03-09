import 'package:flutter_screenutil/flutter_screenutil.dart';

extension SizeExtension on num {
  double get w => ScreenUtil().setWidth(this);

  double get h => ScreenUtil().setHeight(this);

  double get r => ScreenUtil().radius(this);

  double get dg => ScreenUtil().diagonal(this);

  double get dm => ScreenUtil().diameter(this);

  double get sp => ScreenUtil().setSp(this);
}
