## 0.49.0
- [🚀] [break change] 更换`toast`实现, `ToastPosition`参数去除;
- [🚀] `IterableX`增加`tripled`, `doubledWithPrev`, `doubledWithNext`;
- [🚀] 使用`shared_preference`代替`hive`, 增强通用性;
- [🚀] 删除一些过时的扩展(sdk中有代替同名扩展);
- [🚀] 增加`jsonList`扩展;

## 0.48.5
- [🚀] 增加`SizeX`的一些了扩展方法;
- [🚀] `DecoratedWidget`增加`canDispose`;
- [🚀] 增加对字符串比大小的接口;
- [🚀] `ImageView`增加`headers`;
- [🚀] `cacheable`增加`clearCache`接口;
- [🚀] 提升`uuid`依赖;
- [🚀] 增加`dividerColor`扩展;
- [🚀] `DecoratedWrap`增加`width`和`height`;
- [🚀] `Iterable<num>`增加`avg`扩展;
- [🚀] `AnimatedScaleButton`改名为`SpringContainer`;
- [🚀] `ImageProvider`支持`NetworkImage`;
- [🚀] `Countdown`归零判断优化;
- [🚀] 优化`SpringContainer`悬浮样式;
- [✨] 增加全局路由启动器`RouteLauncher`, 用以解决使用gNavigator全局启动时无法进行拦截的问题;

## 0.48.4
- [🚀] `retry`允许捕获任何类型的异常;
- [🚀] `onRetry`增加返回bool类型, 允许指定是否需要继续重试;
- [🚀] `ModalLoading`的颜色调整;

## 0.48.3
- [🐛] 还原`DecoratedStack`对单child的优化(误);
- [🐛] 还原DecoratedFlex的children只有一个的时候的场景(误);
- [🚀] 增加`flutter_view.x.dart`, 一些对`FlutterView`的扩展;
- [🚀] `ErrorPlaceholder`增加显示错误详情的按钮;
- [🚀] 增加`FutureCallback`;
- [🚀] `first`方法在`dispose`之后不应该被发射数据;
- [🚀] `EdgeFade`支持双边渐变;
- [🚀] 优化`DecoratedFlex`子控件的添加方式;
- [🚀] 优化反序列化时的报错日志;
- [🚀] `Extensible`允许任何类型的key;
- [🚀] 增加`nextOf`, `previousOf`, `nextOfIndex`, `previousOfIndex`;
- [🚀] 调整默认的`toast`行为;
- [🚀] 增加`image_provider.x.dart`;
------------------------------------------------------------------------------------------
- [⛔️] 标记`LifecycleBLoCMixin`过时, 不应该再使用;

## 0.48.2
- [🐛] 修正`StringX::substringAfterLast`逻辑;
- [🚀] 补完`DecoratedApp`的参数;
- [🚀] 增加重试机制`retry`/`waitFor`;
- [🚀] 补完`runDecoratedApp`参数;
- [🚀] 增加日志的面板打开功能, `L.openPanel`;
- [💄] ~~调整toast样式~~;
- [🚀] 优化`runDecoratedApp`;
- [🚀] `List<T>`增加`replaceItems`和`replaceItem`;
- [🚀] 优化`ValueNotifier::toStream`的实现;
- [🚀] `BLoCProvider`增加`canDispose`, 代替`autoDispose`;
- [🚀] 优化`TransparentRoute`;
- [🚀] 提供一个简化实现的`SingleTickerProviderBLoCMixin`;
- [🚀] 优化`DecoratedFlex`的`children`只有一个的时候的场景;
- [🚀] 优化`DecoratedStack`的`children`只有一个的时候的场景;

## 0.48.1
- [🚀] ScrollControllerX增加animateBy;
- [🚀] 使用Flutter3.10提供的MediaQuery优化;
- [🚀] `DecoratedFlex`增加`childrenFlex`参数, 方便控制子元素的flex;
- [🚀] 增加`resetSelectable`函数, 方便过滤时直接传入;
- [🚀] `DecoratedFlex`增加`textAlign`, `softWrap`, `maxLines`, `overflow`, 直接控制子widget的文本样式;
- [🚀] `Countdown`的`onZero`只执行一次;
- [🚀] BLoC IO增加`isDisposed`, 方便检查是否已经被销毁;
- [🚀] `List`增加`replaceEquals`;
- [🚀] `DecoratedRoute`增加`foregroundBuilder`;
- [🚀] `SelectableListX`增加`selectAtIndex`;
- [🚀] 增加`getFirst`和`getFirstOrNull`函数;
- [🚀] 补充`skipError`参数;
------------------------------------------------------------------------------------------
- [⛔️] `childrenFlex`可以覆盖`forceItemSameExtent`的功能, 标记`forceItemSameExtent`为过时;

## 0.48.0
- [🐛] setText修正
- [🚀] 增加countWhere
- [🚀] DecoratedStack适配SafeAreaConfig
- [🚀] 更新依赖
- [🚀] 优化isLoading的赋值
- [🚀] Stream<List<Selectable>>增加selectedCount
- [🚀] 调整fallback方法的签名(可能有break change)
- [🚀] 增加LifecycleBLoCMixin

## 0.47.2
- [🚀] safeArea区分作用于内部还是外部
- [🚀] 优化setText的便捷性
- [🚀] select允许传入null

## 0.47.1+1
- [🚀] 增加absorbPointer
- [🚀] 调整打印日志

## 0.47.1
- [🚀] 优化日志
- [🚀] 增加suppressError
- [🚀] 增加onErrorTapped和onEmptyTapped

## 0.47.0
- [🚀] [break change] 调整runDecoratedApp为callback形式

## 0.46.15+1
- [🚀] 调整sdk范围

## 0.46.15
- [🚀] 增加onSecondaryTapDown
- [🚀] DecoratedFlex默认NoSplash.splashFactory
- [🚀] 适配Flutter3.10

## 0.46.14+4
- [🚀] 增加localNavigatorConfig
- [🚀] 增加onSecondaryTap

## 0.46.14+3
- [整理] 去除package_info

## 0.46.14+2
- [整理] 集中管理deprecated
- [🚀] 增加DecoratedDialogRoute
- [🚀] 错误toast背景色调整

## 0.46.14+1
- [🐛] _resetValue为null时, 删除对应key

## 0.46.14
- [🚀] 增加popUntilAny
- [🚀] toast增加backgroundColor
- [🚀] handleError默认toast红色背景

## 0.46.13
- [🚀] 增加PersistSelectable
- [🐛] profile和release模式不检查debugNeedsPaint

## 0.46.12
- [🚀] 增加AnimatedVisibility.reactive
- [🚀] AnimatedVisibility增加placeholder

## 0.46.11
- [🚀] 优化capture方法
- [🚀] 调整RepaintBoundary的顺序
- [🚀] getTmpFile增加后缀

## 0.46.10
- [🚀] 增加onGenerateInitialRoutes
- [🚀] 增加onUnknownRoute
- [🚀] 增加pushRoute/replaceRoute/pushRemoveUntil

## 0.46.9+1
- [🚀] release模式不打印网络日志

## 0.46.9
- [🚀] valueFor支持列表获取
- [🚀] 增加lastWhereOrNull, firstWhereOrNull
- [🚀] 优化AnimatedVisibility
- [🚀] 增加对HttpException的处理
- [功能] 增加maxHeight和maxWidth

## 0.46.8
- [🚀] 优化AutoCloseKeyboard的效果
- [🚀] DecoratedList.sliver不应该设置decorated
- [🚀] 提升依赖 dio: 5.1.0 -> 5.1.1 flutter_svg: 2.0.2 -> 2.0.5
- [🚀] 简化是否是手机号的判断, 只判断是否为11位
- [功能] 增加ImageViewProvider
- [功能] 增加DashedLine

## 0.46.7
- [🚀] DecoratedText增加isSelectable
- [🚀] enhance: DecoratedFlex使用InkWell实现波纹
- [🚀] enhance: Subscriber增加padding, margin
- [🐛] fix: 修正StreamOutput的数据转发问题

## 0.46.5
- [重构] 去除mxlogger

## 0.46.4
- [🚀] PersistConfig增加debounceTime(可以用于在频繁写入的场景, 减少写入频率)
- [🚀] 优化回调签名, 增加变量名
- [🚀] 增加withFileLogger开关

## 0.46.3
- [🚀] DecoratedFlex增加reverse参数
- [🚀] DecoratedList增加reverse参数

## 0.46.2
- [🚀] 增加setText扩展
- [🚀] 新的日志系统(兼顾控制台打印和文件系统日志)
- [🚀] 增加通用接口 ILogger

## 0.46.1
- [🚀] DecoratedApp增加dispose回调
- [🚀] runDecoratedApp的回调前签名优化

## 0.46.0
- [依赖][BREAK CHANGE] 提升Dio依赖到5.x
- [🚀] 扩大requireDate适用范围

## 0.45.1+4
- [🚀] 优化requireDate的适用范围

## 0.45.1+3
- [🚀] showDateDialog增加minimumDate
- [🚀] 优化showDateDialog在web端的判断

## 0.45.1+2
- [整理] 提升依赖 flutter_mxlogger(1.2.4->1.2.4) kiwi(4.0.3->4.1.0) flutter_svg(2.0.0+1->2.0.2)

## 0.45.1+1
- [整理] LateInitCallback签名优化
- [功能] Mapper增加first方法

## 0.45.1
- [行为变更] DecoratedStack增加fill, 用于与center区分
- [样式] 调整showDateDialog取消按钮的样式

## 0.45.0
- ~~由于dio倍废弃, 使用diox替换之.~~

## 0.44.2+1
- 导出intl

## 0.44.2
- 提升flutter_svg依赖到2.0.0

## 0.44.1+2
- 增加md5OfStream

## 0.44.1+1
- 优化ImageView的错误处理

## 0.44.1
- 优化OptionalNumX

## 0.44.0+4
- 使用新的app_minimizer

## 0.44.0+3
- 增加autoCloseKeyboard

## 0.44.0+2
- handleError输出日志到文件

## 0.44.0+1
- html_logger补完

## 0.44.0
- [break change] 调整md5Of的实现

## 0.43.1
- enhance: 区分html的logger和io的logger

## 0.43.0
- enhance: 适配flutter3.7

## 0.13.2
- feat: 增加show_more_text

## 0.13.1
- enhance: 自定义loading时的widget
- enhance: decorated_flex增加material参数, 处理上方没有Material组件的情况
- enhance: PageOutput中的update方法标记为protected

## 0.13.0
- enhance: 提示依赖
- enhance: DecoratedFlex增加heightFactor, widthFactor
- fix: DecoratedColumn scrollable, List换为SingleChildScrollView

## 0.12.14
- ~~enhance: 默认懒加载~~

## 0.12.13
- enhance: 优化loading方法
- enhance: 添加receiveFullData参数

## 0.12.12
- feat: 增加TextEditingControllerX
- enhance: 增加invalidate方法

## 0.12.11
- enhance: PageOutput出现错误时的处理
- enhance: loading默认不可关闭

## 0.12.10
- feat: 增加PageOutput, 处理分页情况

## 0.12.9
- enhance: 增加是否使用局部Navigator参数

## 0.12.8
- feat: 增加dimens

## 0.12.7
- feat: 增加AutoScrollBottomDialog, 底部对话框可以自动适应输入法弹出

## 0.12.6
- enhance: 细化BaseIO初始化

## 0.12.5
- feat: 增加aligned

## 0.12.4
- enhance: BuildContext增加rootNavigator扩展

## 0.12.3
- enhance: 增加CupertinoRoute

## 0.12.2
- enhance: decorated_route一律包含在Material下面

## 0.12.1
- enhance: 提升依赖, BuildContext增加padding扩展

## 0.12.0
- enhance: [breaking change] 去除flushbar

## 0.11.1
- enhance: build_context.x增加pop方法
- enhance: build_context.x增加textTheme
- enhance: build_context.x增加pop方法

## 0.11.0
- enhance: 清理不再需要的代码

## 0.10.5
- enhance: 去掉设置TargetPlatform.macos的场景
- fix: 去除不需要的meta包引入

## 0.10.4
- enhance: 去除logging库

## 0.10.3
- enhance: 加入logging库

## 0.10.2
- enhance: 优化log

## 0.10.1
- chore: 提升依赖
- enhance: 一些helper方法转换为extension

## 0.10.0
- enhance: 适配rxdart 0.23; 清除过时代码

## 0.9.1
- enhance: 优化Toggleable

## 0.9.0
- enhance: 去除connectivity, 保证decorated_flutter的依赖全部是纯dart, 增强兼容性; 提升依赖

## [0.8.0]
- enhance: 增加Gravity枚举
- enhance: decorated_text增加textAlign
- enhance: bloc中应该protected的属性添加@protected
- enhance: [break change] dio升级3.0

## [0.7.0]
- enhance: [break change] DecoratedText的onChange非法传入文本
- enhance: AsyncListView加入header
- enhance: [break change] decorated_screen -> decorated_widget
- enhance: DecoratedText增加maxLines参数
- enhance: 增加公用的textStyle
- enhance: intl -> flutter_localization

## [0.6.1]
- chore: 提升依赖版本
- enhance: 增加toast方法

## [0.6.0]
- feat: 增加GradientButton
- feat: 增加DecoratedText
- enhance: DecoratedFlex增加safe area
- enhance: Codec构造器优化
- enhance: DecoratedText加入onPressed
- enhance: FractionalScreen增加safeArea参数

## [0.5.0]
- enhance: 适配新的依赖

## [0.4.0]
- feat: 增加Delayed, Toggleable的widget; 
- enhance: [break change] runtime_scaffold使用泛型来获取bloc
- feat: 增加DisposeBag
- enhance: barrierDismissible可配置
- enhance: loading默认可以通过返回键退出
- enhance: BLoCProvider提供dispose回调; feat: 增加async mixin, 简化StreamBuilder的写法

## [0.3.2]
- enhance: decorated_flex增加divider参数; decorated_screen的init参数bug; image_view的assetImage默认不使用fit; 废弃shadowed_box
- feat: 增加decorated_screen; decorated_flex增加forceItemSameExtent
- enhance: deprecate `ioList`; 增加topBottomBorder和leftRightBorder
- enhance: OutputMixin的listen方法返回StreamSubscription
- enhance: 所有的类add方法都返回处理过后的值.

## [0.3.1]
- feat: 增加BoolIO
- enhance: 增加appendAll方法;
- 增加flatMap方法; 
- 去除StreamListView中increment相关代码; 
- DecoratedFlex增加scrollable参数; 
- 增加clearFocus方法

## [0.3.0]
- enhance: [break change] _ItemBuilder的第二参数换成index, data移动到第三个参数
- enhance: ListMixin增加一些方法
- chore: 提升dart版本到2.2.2
- enhance: 完善AdvancedNetworkImage的参数

## [0.2.0]
- enhance: [break change] bloc_io中的Output系列, 加上一个update时的参数泛型
- fix: SnapList的padding参数增加默认值
- enhance: ImageView增加异步获取IconData的构造器
- enhance: ImageView增加异步获取图片地址的构造器
- enhance: ImageView如果图片地址全都为null, 那就不显示
- feat: ImageView增加icon构造器
- fix: io中add数据前, 先判断内部subject是否已经被close.
- enhance: 使用flushbar代替原生的snackbar
- feat: ImageView增加networkSvg构造器
- feat: 增加Blur的widget

## [0.1.10]
- enhance: 优化打印日志内容
- enhance: decorated_route增加onConnectivityChanged参数
- enhance: 增加一些透明颜色的shortcut
- feat: 增加enumName
- feat: 增加区分运行模式的类
- enhance: BaseIO中该私有的成员私有化
- enhance: ShowUpTransition增加safe area的选项

## [0.1.9]
- enhance: 增强preferred_async_builder的错误日志打印
- enhance: 整理Codec
- enhance: 更新BLoCProvider的实现
- feat: Codec增加base64相关, 并且获取byte的时候一律使用utf8.encode而不是直接codeUnits
- feat: 增加信息摘要的方法
- enhance: isNotEmpty -> != null
- feat: 增加ImageView封装Image和Svg的widget.

## [0.1.8]
- feat: io增加addStream方法
- feat: 增加codec类

## [0.1.7]
- feat: 增加loadingPlaceholder 自定义loading的widget
- feat: preferred_async_view增加loadingPlaceholder参数
- feat: cover_card初步, shadowed_box默认参数调整
- feat: 增加alias.dart
- feat: 增加animation
- enhance: 增加insertFromHead参数
- enhance: 增加startWithDivider参数

## [0.1.6]
- enhance: reverse和divider配合
- enhance: async_list_view.widget的itemBuilder增加lastData参数
- enhance: 优化StreamListView的incremental相关功能
- feat: 增加notification_badge
- enhance: decorated_flex的expanded -> crossExpanded, 语义准确一点

## [0.1.5]
- chore: 提升dio版本
- feat: async_list_view增加endWithDivider参数, 配置列表结尾是否有divider
- fix: withDefaultTabController的assert的bug
- feat: decorated_route增加withDefaultTabController和tabLength参数
- enhance: BLoC标记为@immutable
- [break change] chore: trigger -> fetch

## [0.1.4]
- enhance: 升级依赖
- fix: DecoratedFlex的onPressed问题

## [0.1.3]
- fix: async_list_view的bug处理
- enhance: dio升级2.0.2
- enhance: [break change] 去除cached_network_image; 错误处理方法优化
- enhance: StreamListView默认ScrollController
- enhance: [break change] showMessage方法的exitTo参数换成String类型的路由参数, 替换Deprecated的Type参数

## [0.1.2]
- enhance: 增加Value类, 把一些简单的StatefulWidget转换回StatelessWidget;
- enhance: [break change] DecoratedFlex的onTap和onLongPressed重命名为onPressed和onLongPressed, 并且传入BuildContext参数.
- feat: DecoratedFlex增加expanded参数, 控制是否Expanding
- feat: DecoratedFlex增加visible参数, 控制是否显示
- feat: async_list_view增加incremental和distinct参数, 分别控制是否增长列表和列表元素是否唯一
