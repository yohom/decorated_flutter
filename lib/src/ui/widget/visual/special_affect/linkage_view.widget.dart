import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef GetHearWidget<M extends BaseItem> = Widget Function(
  BuildContext context,
  M item,
);
typedef GetGeneralItem<M extends BaseItem> = Widget Function(
  BuildContext context,
  int index,
  M item,
);
typedef GetGroupItem<M extends BaseItem> = Widget Function(
  BuildContext context,
  int index,
  M item,
);
typedef OnGroupItemTap<M extends BaseItem> = void Function(
  BuildContext context,
  int index,
  M item,
);

class BaseItem {
  bool isHeader;
  String? header;
  bool? isSelect;
  String? title;
  dynamic info;
  int? index;

  BaseItem({
    required this.isHeader,
    this.header,
    this.isSelect,
    this.info,
    this.title,
    this.index,
  });
}

class LinkageView<T extends BaseItem> extends StatefulWidget {
  final double itemHeadHeight;
  final double itemHeight;
  final double itemGroupHeight;

  final List<T> items;
  final GetGroupItem itemBuilder;
  final GetGeneralItem groupItemBuilder;
  final GetHearWidget headerBuilder;
  final OnGroupItemTap onGroupItemTap;
  final int flexLeft;
  final int flexRight;
  final int duration;
  final bool isNeedStick;
  final Curve curve;
  final List<T> groups = <T>[];

  LinkageView({
    Key? key,
    required this.items,
    required this.itemBuilder,
    required this.groupItemBuilder,
    required this.headerBuilder,
    required this.onGroupItemTap,
    this.isNeedStick = true,
    this.curve = Curves.linear,
    this.itemHeadHeight = 30,
    this.itemHeight = 50,
    this.itemGroupHeight = 50,
    required this.duration,
    this.flexLeft = 1,
    this.flexRight = 3,
  }) : super(key: key) {
    for (var i = 0; i < items.length; i++) {
      items[i]
        ..index = i
        ..isSelect = false;
      if (items[i].isHeader) {
        groups.add(items[i]);
      }
    }
  }

  @override
  _LinkageViewState createState() => _LinkageViewState();
}

class _LinkageViewState<T extends BaseItem> extends State<LinkageView> {
  bool selected = false;
  int selectIndex = 0;
  bool showTopHeader = false;
  double headerOffset = 0.0;
  late final T headerStr;
  double beforeScroll = 0.0;
  late final ScrollController _scrollController;
  late final ScrollController _groupScrollController;
  late final Size containerSize;
  late final GlobalKey _containerKey;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _groupScrollController = ScrollController();
    _containerKey = GlobalKey();
    headerStr = widget.items.first as T;
    headerStr.isSelect = true;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback(_onBuildCompleted);
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              key: _containerKey,
              padding: EdgeInsets.zero,
              controller: _groupScrollController,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.groups.length,
              itemBuilder: (BuildContext context, int index) {
                return _groupItem(context, index);
              },
            ),
            flex: widget.flexLeft,
          ),
          Expanded(
            child: Stack(children: [
              ListView.builder(
                padding: EdgeInsets.zero,
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                itemCount: widget.items.length,
                itemBuilder: generalItem,
              ),
              Visibility(
                visible: widget.isNeedStick ? showTopHeader : false,
                child: Container(
                  transform: Matrix4.translationValues(0.0, headerOffset, 0.0),
                  width: double.infinity,
                  height: widget.itemHeadHeight,
                  child: widget.headerBuilder(context, headerStr),
                ),
              )
            ]),
            flex: widget.flexRight,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_onScroll);
  }

  void _onBuildCompleted(Duration timestamp) {
    final containerRenderBox =
        _containerKey.currentContext?.findRenderObject() as RenderBox?;
    containerSize = containerRenderBox!.size;
  }

  Widget _groupItem(BuildContext context, int index) {
    T item = widget.groups[index] as T;
    return GestureDetector(
      onTap: () {
        if (mounted) {
          setState(() {});
          widget.onGroupItemTap(context, index, widget.groups[index]);
          selectIndex = index;
          double tempLength = 0.0;
          for (var i = 0; i < widget.groups[index].index!; i++) {
            double currentHeight = widget.items[i].isHeader
                ? widget.itemHeadHeight
                : widget.itemHeight;
            tempLength += currentHeight;
          }
          selected = true;
          _scrollController
              .animateTo(
                tempLength,
                duration: Duration(milliseconds: widget.duration),
                curve: Curves.linear,
              )
              .whenComplete(() => selected = false);
        }
      },
      child: SizedBox(
        child: widget.groupItemBuilder(context, index, item),
        height: widget.itemGroupHeight,
      ),
    );
  }

  Widget generalItem(BuildContext context, int index) {
    T item = widget.items[index] as T;
    if (item.isHeader) {
      return SizedBox(
        child: widget.itemBuilder(context, index, item),
        height: widget.itemHeadHeight,
      );
    } else {
      return SizedBox(
        child: widget.itemBuilder(context, index, item),
        height: widget.itemHeight,
      );
    }
  }

  void resetGroupPosition() {
    int index = 0;
    if (!selected) {
      for (var i = 0; i < widget.groups.length; i++) {
        if (headerStr == widget.groups[i]) {
          index = i;
        }
      }
    } else {
      index = selectIndex;
    }

    double currentLength = widget.itemGroupHeight * (index + 1);
    double offset = 0;

    if (currentLength > containerSize.height / 2 &&
        widget.groups.length * widget.itemGroupHeight > containerSize.height) {
      offset = ((currentLength - containerSize.height / 2) /
              widget.itemGroupHeight.round()) *
          widget.itemGroupHeight;
      if (offset + containerSize.height >
          widget.groups.length * widget.itemGroupHeight) {
        offset = widget.groups.length * widget.itemGroupHeight -
            containerSize.height;
      }
      _groupScrollController.animateTo(offset,
          duration: Duration(milliseconds: widget.duration),
          curve: Curves.linear);
    }

    // if ((currentLength - (widget.itemGroupHeight / 2)) >= containerSize.height / 2 &&
    //     widget.groups.length * widget.itemGroupHeight > containerSize.height) {
    //   // offset = (currentLength - (widget.itemGroupHeight / 2)) - containerSize.height / 2;
    //   if (offset + containerSize.height > widget.groups.length * widget.itemGroupHeight) {
    //     offset = widget.groups.length * widget.itemGroupHeight - containerSize.height;
    //   }

    //   groupScrollController.animateTo(offset, duration: Duration(milliseconds: widget.duration), curve: Curves.ease);
    // }
    if (currentLength <= containerSize.height / 2 &&
        offset < widget.itemGroupHeight) {
      offset = 0;
      _groupScrollController.animateTo(
        offset,
        duration: Duration(milliseconds: widget.duration),
        curve: Curves.linear,
      );
    }
  }

  void _onScroll() {
    double offset2 = _scrollController.offset;
    if (offset2 >= 0) {
      if (mounted) {
        setState(() {
          showTopHeader = true;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          showTopHeader = false;
        });
      }
    }
    //计算滑动了多少距离了
    double pixels = _scrollController.position.pixels;
    // print("pixels is $pixels");
    double tempLength = 0.0;
    int position = 0;
    double offset;
    double currentHeight = 0;

    for (var i = 0; i < widget.items.length; i++) {
      currentHeight =
          widget.items[i].isHeader ? widget.itemHeadHeight : widget.itemHeight;
      tempLength += currentHeight;
      if (widget.items[i].isHeader) {
        headerStr.isSelect = false;
        headerStr = widget.items[i] as T;
        headerStr.isSelect = true;
      }
      //滚动的大小没有超过最大的item index,那么当前地一个item的下标就是index
      if (tempLength >= pixels) {
        position = i;
        break;
      }
    }
    if (widget.items[position + 1].isHeader) {
      //如果下一个是header,又刚刚滚定到临界点,那么group往下一个
      if (tempLength == pixels) {
        headerStr.isSelect = false;
        headerStr = widget.items[position + 1] as T;
        headerStr.isSelect = true;
      }
      if (mounted) {
        setState(() {
          offset = currentHeight - (tempLength - pixels);
          if (offset - (widget.itemHeight - widget.itemHeadHeight) >= 0) {
            headerOffset =
                -(offset - (widget.itemHeight - widget.itemHeadHeight));
          }
        });
      }
    } else {
      if (headerOffset != 0) {
        if (mounted) {
          setState(() {
            headerOffset = 0.0;
          });
        }
      }
    }
    // if (!selected) {
    resetGroupPosition();
    // }
  }
}
