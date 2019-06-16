## [0.4.0]
- feature: 增加Delayed, Toggleable的widget; 
- enhancement: [break change] runtime_scaffold使用泛型来获取bloc
- feature: 增加DisposeBag
- enhancement: barrierDismissible可配置
- enhancement: loading默认可以通过返回键退出
- enhancement: BLoCProvider提供dispose回调; feature: 增加async mixin, 简化StreamBuilder的写法

## [0.3.2]
- enhancement: decorated_flex增加divider参数; decorated_screen的init参数bug; image_view的assetImage默认不使用fit; 废弃shadowed_box
- feature: 增加decorated_screen; decorated_flex增加forceItemSameExtent
- enhancement: deprecate `ioList`; 增加topBottomBorder和leftRightBorder
- enhancement: OutputMixin的listen方法返回StreamSubscription
- enhancement: 所有的类add方法都返回处理过后的值.

## [0.3.1]
- feature: 增加BoolIO
- enhancement: 增加appendAll方法;
- 增加flatMap方法; 
- 去除StreamListView中increment相关代码; 
- DecoratedFlex增加scrollable参数; 
- 增加clearFocus方法

## [0.3.0]
- enhancement: [break change] _ItemBuilder的第二参数换成index, data移动到第三个参数
- enhancement: ListMixin增加一些方法
- chore: 提升dart版本到2.2.2
- enhancement: 完善AdvancedNetworkImage的参数

## [0.2.0]
- enhancement: [break change] bloc_io中的Output系列, 加上一个update时的参数泛型
- bugfix: SnapList的padding参数增加默认值
- enhancement: ImageView增加异步获取IconData的构造器
- enhancement: ImageView增加异步获取图片地址的构造器
- enhancement: ImageView如果图片地址全都为null, 那就不显示
- feature: ImageView增加icon构造器
- bugfix: io中add数据前, 先判断内部subject是否已经被close.
- enhancement: 使用flushbar代替原生的snackbar
- feature: ImageView增加networkSvg构造器
- feature: 增加Blur的widget

## [0.1.10]
- enhancement: 优化打印日志内容
- enhancement: decorated_route增加onConnectivityChanged参数
- enhancement: 增加一些透明颜色的shortcut
- feature: 增加enumName
- feature: 增加区分运行模式的类
- enhancement: BaseIO中该私有的成员私有化
- enhancement: ShowUpTransition增加safe area的选项

## [0.1.9]
- enhancement: 增强preferred_async_builder的错误日志打印
- enhancement: 整理Codec
- enhancement: 更新BLoCProvider的实现
- feature: Codec增加base64相关, 并且获取byte的时候一律使用utf8.encode而不是直接codeUnits
- feature: 增加信息摘要的方法
- enhancement: isNotEmpty -> != null
- feature: 增加ImageView封装Image和Svg的widget.

## [0.1.8]
- feature: io增加addStream方法
- feature: 增加codec类

## [0.1.7]
- feature: 增加loadingPlaceholder 自定义loading的widget
- feature: preferred_async_view增加loadingPlaceholder参数
- feature: cover_card初步, shadowed_box默认参数调整
- feature: 增加alias.dart
- feature: 增加animation
- enhancement: 增加insertFromHead参数
- enhancement: 增加startWithDivider参数

## [0.1.6]
- enhancement: reverse和divider配合
- enhancement: async_list_view.widget的itemBuilder增加lastData参数
- enhancement: 优化StreamListView的incremental相关功能
- feature: 增加notification_badge
- enhancement: decorated_flex的expanded -> crossExpanded, 语义准确一点

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
