# decorated_flutter

`decorated_flutter` 是一组面向 Flutter 项目的 UI、布局、图片、路由与常用扩展工具。它的目标是减少重复的 Widget 包裹和样板代码，让页面能在保持原生 Flutter 语义的同时更紧凑地表达布局与交互。

库中仍保留早期的 BLoC / IO 实现以兼容已有项目，但它不再是推荐的架构入口。新项目可以按自己的状态管理方案使用本库的 Widget、扩展与工具，而无需依赖 BLoC。

## 环境要求

- Dart SDK `>=3.0.0 <4.0.0`
- Flutter `>=3.27.0`

Flutter 3.27.0 是最低版本，因为 `DecoratedRow` 与 `DecoratedColumn` 使用 Flutter 内置的 `Flex.spacing` 实现元素间距。

## 安装

在 `pubspec.yaml` 中添加依赖。私有项目可使用本地路径或 Git 依赖：

```yaml
dependencies:
  decorated_flutter:
    path: ../decorated_flutter
```

然后执行：

```sh
flutter pub get
```

业务代码通常从统一入口导入：

```dart
import 'package:decorated_flutter/decorated_flutter.dart';
```

## 核心能力

### 布局与装饰

`DecoratedRow`、`DecoratedColumn`、`DecoratedStack`、`DecoratedText`、`DecoratedList` 与 `DecoratedWrap` 在原生布局能力之上整合了常见的尺寸、边距、装饰、点击、安全区、滚动和弹性配置。

```dart
DecoratedColumn(
  padding: const EdgeInsets.all(16),
  spacing: 12,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const Text('订单信息'),
    DecoratedRow(
      spacing: 8,
      children: const [
        Icon(Icons.schedule),
        Text('今天 19:30'),
      ],
    ),
  ],
)
```

`spacing` 直接传给 Flutter 的 `Flex.spacing`，不会额外插入间隔 Widget。旧的 `itemSpacing` 仍可用，但已标记为弃用，新的代码请使用 `spacing`。

当多个子项需要统一弹性布局时，使用 `childrenFlex`：

```dart
DecoratedRow(
  spacing: 12,
  childrenFlex: FlexConfig.expanded([2, 1]),
  children: const [
    Placeholder(),
    Placeholder(),
  ],
)
```

### 图片与占位

`ImageView` 统一处理 asset、文件、网络图片和 SVG，并提供缓存尺寸、占位、错误展示、裁剪与装饰等常用能力。

```dart
ImageView(
  avatarUrl,
  size: 40,
  cacheSize: 120,
  fit: BoxFit.cover,
  fadeIn: false,
  decoration: const BoxDecoration(shape: BoxShape.circle),
)
```

对于列表头像和缩略图，建议按实际显示尺寸传入 `cacheWidth`、`cacheHeight` 或 `cacheSize`，以减少解码和纹理上传成本。

### 常用页面与交互组件

库提供了可组合的页面辅助能力，包括：

- 页面、路由与弹窗：`DecoratedApp`、`RuntimeScaffold`、`DecoratedRoute`、`TransparentRoute`、`HeroDialogRoute`
- 列表、滚动与 Sliver：`DecoratedList`、`PreferredNestedScrollView`、`SliverStack`、`SliverClip`、`EdgeFade`
- 状态与显隐：`AnimatedVisibility`、`VisibilityBuilder`、`MultiListenableBuilder`、`Subscriber`
- 选择、输入与反馈：`DebouncedTextFormField`、`CircleCheckbox`、`Toggleable`、`GradientButton`、`AutoCloseKeyboard`
- 展示效果：`AutoSizeText`、`ShowMoreText`、`OverflowText`、`Countdown`、`AnimatedInt`、`AnimatedDouble`

请以 `lib/src/ui/ui.export.dart` 的导出内容为准；各组件的构造参数和行为在源码中有对应注释。

### 扩展与工具

`extension.export.dart` 导出了日期、时长、字符串、数字、集合、`BuildContext`、滚动控制器、输入控制器和 Widget 等常用扩展。常见用途包括：

```dart
final title = [name.trim(), '未命名'].fallback()!;
final dateText = createdAt.format('yyyy-MM-dd');
final timeout = 3.seconds;
```

此外还提供 `toast`、`retry`、`RouteLauncher`、坐标转换、编解码和空值处理等工具。新增同类 helper 前，建议先搜索现有扩展与工具出口。

## 使用建议

- 优先使用原生 Flutter 的布局语义；当同时需要布局、装饰或交互配置时，再使用对应的 `Decorated*` 组件减少包裹层级。
- 保持业务状态管理与 UI 组件解耦；本库不要求使用特定状态管理方案。
- 图片列表优先设置缓存尺寸，并避免在同一帧中批量解码大图。
- 测试中请按需导入具体源码，不要直接导入 `package:decorated_flutter/decorated_flutter.dart`，以避免与 `flutter_test` 的符号冲突。

## 兼容的 BLoC 能力

`BLoC`、`LocalBLoC`、`GlobalBLoC`、`BLoCProvider` 与 IO 相关类型仍然保留并从主入口导出，供存量项目逐步维护和迁移。新功能不应为了使用本库而强制采用这套模式；请按项目既有架构选择合适的状态管理方式。

## 开发与验证

```sh
flutter pub get
flutter analyze
flutter test
```

修改面向使用者的行为后，请同步更新 `CHANGELOG.md`。测试文件保持按需导入，以便明确依赖并避免符号冲突。
