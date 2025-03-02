# 基于BLoC的通用框架

## BLoC的各种元素
### 什么是`IO`？
`IO`即`Input/Output`，Input/Output是相对于BLoC来说的，Input即向BLoC输入数据，Output即从BLoC输出数据。
一个BLoC中所有的属性都是IO，负责接收来自widget层的数据（供后续操作读取数据）或者向widget层输出数据。widget层**只对数据做读取操作**，即widget对数据是*READONLY*的。
当widget需要对数据发起修改操作时，需要通过`BLoCProvider.of(BuildContext)`/`context.of<SomeBLoC>()`来获取当前widget所依附的BLoC实例，然后调用BLoC的对应方法来操作数据。

### BaseIO
`BaseIO`是所有IO类型的祖宗类，存放了所有IO类型需要的公共属性和方法。

#### 构造器概览
```dart
BaseIO({
  /// 初始值, 传递给内部的[_subject]
  T seedValue,

  /// IO代表的语义
  String semantics,

  /// 是否同步发射数据, 传递给内部的[_subject]
  bool sync = true,

  /// 是否使用BehaviorSubject, 如果使用, 那么IO内部的[_subject]会保存最近一次的值
  bool isBehavior = true,
})  : _semantics = semantics,
      _seedValue = seedValue,
      latest = seedValue,
      _subject = isBehavior
          ? seedValue != null
              ? BehaviorSubject<T>.seeded(seedValue, sync: sync)
              : BehaviorSubject<T>(sync: sync)
          : PublishSubject<T>(sync: sync) {
    _subject.listen((data) {
      latest = data;
      L.d('[DECORATED_FLUTTER] 当前${semantics ??= data.runtimeType.toString()} latest: $latest'
          '\n+++++++++++++++++++++++++++END+++++++++++++++++++++++++++++');
    });
  }
```
`BehaviorSubject`是`rxdart`的一个类，作为一个中转站，当有数据add到`BehaviorSubject`时，会转发给`BehaviorSubject`的订阅者。作用有些类似iOS里的`NotificationCenter`，Android中同RxJava中的`BehaviorSubject`。

### Input
`Input`表示只从widget接收数据，不对widget输出数据的业务单元。常见的使用场景为接收来自`TextFormField`的值。

### Output
`Output`表示只对widget输出数据，不从widget接收数据的业务单元。常见的使用场景为页面初始数据的加载，比如进入一个列表页，BLoC中的一个Output负责加载列表数据，widget层中的一个ListView绑定这个Output，进入页面前调用Output进行数据的加载，加载完成后刷新ListView。<br/>
整个过程Output不会从widget接收数据，只会对widget输出数据。

### IO
语义上，IO是既可以输入数据又可以输出数据的业务单元；实现上，`IO`即`class IO<T> extends BaseIO<T> with InputMixin, OutputMixin<T, dynamic>`。<br/>
常见的使用场景为勾选框，由于Flutter的哲学是widget本身不保存状态，所以像CheckBox这种widget的勾选状态是需要开发者自行维护的，CheckBox本身只负责通知开发者状态即将变化，当CheckBox的onChanged回调出发后，并不会真正的看到CheckBox被勾选，需要开发者自行更新CheckBox的`checked`的值之后才能看到被勾选。所以在这种场景下，数据流动就变成了`CheckBox(onChanged)`->`BLoC(更新状态值)`->`CheckBox(监听新的状态值)`。

### 衍生IO
#### ListIO
`ListIO`是只接收列表类型的IO，在普通IO的基础上增加了如下方法：
```dart
/// 按条件过滤, 并发射过滤后的数据
List<T> filterItem(bool test(T element));

/// 追加, 并发射
T append(T element, {bool fromHead = false});

/// 追加一个list, 并发射
List<T> appendAll(List<T> elements, {bool fromHead = false});

/// 对list的item做变换之后重新组成list
Stream<List<S>> flatMap<S>(S mapper(T value));

/// 替换指定index的元素, 并发射
T replace(int index, T element);

/// 替换最后一个的元素, 并发射
T replaceLast(T element);

/// 替换第一个的元素, 并发射
T replaceFirst(T element);

/// 删除最后一个的元素, 并发射
T removeLast();

/// 删除一个的元素, 并发射
T remove(T element);

/// 删除第一个的元素, 并发射
T removeFirst();

/// 删除指定索引的元素, 并发射
T removeAt(int index);
```

#### BoolIO
`BoolIO`是只接收布尔值的IO，增加了如下方法：
```dart
/// 翻转状态值
bool toggle();
```

#### PageIO
`PageIO`在ListIO基础之上进一步封装了分页操作，在`PageIO`会自动维护当前页数，开发者只需要调用`nextPage`方法即可请求下一页数据，如果如要刷新数据，不能再调用IO提供的`update`方法，而是需要使用PageIO中提供的`refresh`方法。


## 编码规范
- 尽量减少嵌套；
- 尽量让一个Widget长什么样只取决于构造器参数，减少来历不明的变化引起的Widget变化，例如：
  ```dart
  class SomeWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return StreamBuilder(
        stream: /* 某处获取来的stream */
        builder: (context, snapshot) {
          return AWidget(snapshot.data);
        }
      );
    }
  }
  
  class AWidget extends StatelessWidget {
    AWidget(AVM vm, {Key key}): super(key: key);

    @override
    Widget build(BuildContext context) {
      return /* 根据vm参数构造出widget */
    }
  }
  ```
  优于
  ```dart
  class SomeWidget extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return AWidget();
    }
  }

  class AWidget extends StatelessWidget {
    AWidget({Key key}): super(key: key);

    @override
    Widget build(BuildContext context) {
      return StreamBuilder(
        stream: /* 某处获取来的stream */
        builder: (context, snapshot) {
          return /* 根据snapshot构造widget */;
        }
      );
    }
  }
  ```
  第二种写法虽然看着代码更少，但是跟某个stream直接绑定，导致难以复用，而且AWidget长什么样不受AWidget类内部逻辑控制(被`某处获取来的stream`控制)，非常不直观。除非这是一个全局使用的widget，绑定的stream也是全局的事件，那么可以这样使用，否则必须要从构造器中传入参数。
- 优先使用StatelessWidget+BLoC模式实现功能，只有功能比较简单时，可以使用StatefulWidget代替实现；
- StatelessWidget类里应该只有
    1. build方法；
    2. override方法；
    3. 事件处理(私有)方法；
- StatefulWidget不做限制；

## 名称
- 在遵循规范的前提下，不要怕名字太长或者太啰嗦，清晰精确的名称好于莫名其妙的省略；
- 除非是广泛通用的缩写（例如`http`等），否则不允许使用任何形式的缩写，无意义的缩写会让看代码的人困惑；

### 文件名
- 文件名使用下划线风格；
- 页面类以`.screen.dart`结尾；
- 普通widget类以`.widget.dart`结尾；
- dialog类以`.dialog.dart`结尾；
- bloc类以`.bloc.dart`结尾；
- 类扩展(extension)以`.x.dart`结尾；
- mixin以`.mixin.dart`结尾；
- 其他文件目前直接以`.dart`结尾；

### 类名
- 页面类以`Screen`结尾；
- 普通widget类根据业务属性命名即可；

### 方法名
- 方法名使用驼峰命名法；
- BLoC中的action以`perform`开头，比如登录动作方法命名为`performLogin`；

### 变量名
- 变量名使用驼峰命名法；

## Widget结构
- widget树中**无状态变化**的部分，要抽离出单独的widget类，把以构造器参数形式传入需要的数据，并修饰构造器为`const`；

## BLoC结构
- 为了区分action和IO，IO的成员统一放在同文件内名为`_ComponentMixin`的`mixin`中，action方法放在原`BLoC`中，一个典型的例子：
```dart
class LoginBLoC extends LocalBLoC with _ComponentMixin {
  LoginBLoC() : super('登录 BLoC');

  Future<bool> performLogin() async {
    // 获取最新的account和password并执行登录动作
  }
}

mixin _ComponentMixin on LocalBLoC {
  @override
  List<BaseIO> get disposeBag => [
        account,
        password,
      ];

  final account = Input<String>(semantics: '账户');

  final password = Input<String>(semantics: '密码');
}
```

## 文件夹结构
### ui相关文件组织
- `ui`文件夹下分为`screen`文件夹和`widget`文件夹，`screen`文件夹存放所有的单页面，`widget`存放全局共用的控件；
- `screen`下的文件分为主screen文件和其组成部分，当组成部分比较复杂时，可以再单独为其新建文件夹；
- 在一个文件夹下，只允许存在两层关系的ui，如果超过两层的关系，则为较复杂的那部分新建文件夹；

## 一些约定的写法
### `Dialog`的使用
Dialog本身不处理任何业务逻辑，它只负责采集数据，采集完成之后通过`Navigator.pop(data)`回传给宿主widget，并在宿主widget进行业务操作；

### widget
- 优先使用`StatelessWidget`，只有当`StatelessWidget`实在不方便的时候再启用`StatefulWidget`，比如说要mixin一些辅助；
- 优先把IO放在局部BLoC，只有当局部BLoC无法满足需求时，再放到全局BLoC；

## 框架模式
项目的框架模式为`BLoC`(Business Logic Component)，是一种基于流(Stream)的模式。
一"块"UI会搭配一个专属的`BLoC`，`BLoC`中存放着这一块UI所有的状态，以及所有操作数据的接口。

## 全局结构图
*矩形为widget，圆角矩形普通类*
![输入图片说明](https://images.gitee.com/uploads/images/2020/0723/071740_e4186103_944757.png "全局数据流向导图.png")

## 单页面结构图
*矩形为widget，圆角矩形普通类*

![输入图片说明](https://images.gitee.com/uploads/images/2020/0722/085532_07d19a93_944757.png "单页数据流向导图.png")

## 网络请求时序图
以登录为例：

![输入图片说明](https://images.gitee.com/uploads/images/2020/0724/085140_fcc8c24f_944757.png "Screen Shot 2020-07-24 at 08.51.12.png")
