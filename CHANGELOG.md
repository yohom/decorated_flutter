## [0.1.5]
- chore: 提升dio版本
- feature: async_list_view增加endWithDivider参数, 配置列表结尾是否有divider
- bugfix: withDefaultTabController的assert的bug
- feature: decorated_route增加withDefaultTabController和tabLength参数
- enhancement: BLoC标记为@immutable
- [break change] chore: trigger -> fetch

## [0.1.4]
- enhancement: 升级依赖
- bugfix: DecoratedFlex的onPressed问题

## [0.1.3]

- bugfix: async_list_view的bug处理
- enhancement: dio升级2.0.2
- enhancement: [break change] 去除cached_network_image; 错误处理方法优化
- enhancement: StreamListView默认ScrollController
- enhancement: [break change] showMessage方法的exitTo参数换成String类型的路由参数, 替换Deprecated的Type参数

## [0.1.2]

- enhancement: 增加Value类, 把一些简单的StatefulWidget转换回StatelessWidget;
- enhancement: [break change] DecoratedFlex的onTap和onLongPressed重命名为onPressed和onLongPressed, 并且传入BuildContext参数.
- feature: DecoratedFlex增加expanded参数, 控制是否Expanding
- feature: DecoratedFlex增加visible参数, 控制是否显示
- feature: async_list_view增加incremental和distinct参数, 分别控制是否增长列表和列表元素是否唯一
