import 'package:decorated_flutter/decorated_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<CityPickerResult?> showCityPickerDialog(
  BuildContext context, {
  List<CityRegion>? data,
  CityPickerResult? initialValue,
  String? initialProvinceCode,
  String? initialCityCode,
  String? initialAreaCode,
  Widget? title,
  String? cancelText,
  String? confirmText,
  double itemExtent = 36,
}) async {
  final regions = data ?? await CityPickerData.load();
  if (regions.isEmpty) return null;

  if (!context.mounted) return null;
  return showModalBottomSheet<CityPickerResult>(
    context: context,
    builder: (context) => _CityPickerDialog(
      data: regions,
      initialValue: initialValue,
      initialProvinceCode: initialProvinceCode,
      initialCityCode: initialCityCode,
      initialAreaCode: initialAreaCode,
      title: title,
      cancelText: cancelText,
      confirmText: confirmText,
      itemExtent: itemExtent,
    ),
  );
}

class _CityPickerDialog extends StatefulWidget {
  const _CityPickerDialog({
    required this.data,
    this.initialValue,
    this.initialProvinceCode,
    this.initialCityCode,
    this.initialAreaCode,
    this.title,
    this.cancelText,
    this.confirmText,
    required this.itemExtent,
  });

  final List<CityRegion> data;
  final CityPickerResult? initialValue;
  final String? initialProvinceCode;
  final String? initialCityCode;
  final String? initialAreaCode;
  final Widget? title;
  final String? cancelText;
  final String? confirmText;
  final double itemExtent;

  @override
  State<_CityPickerDialog> createState() => _CityPickerDialogState();
}

class _CityPickerDialogState extends State<_CityPickerDialog> {
  late int _provinceIndex;
  late int _cityIndex;
  late int _areaIndex;
  late FixedExtentScrollController _provinceController;
  late FixedExtentScrollController _cityController;
  late FixedExtentScrollController _areaController;

  List<CityRegion> get _provinces => widget.data;

  List<CityRegion> get _cities => _provinces[_provinceIndex].children;

  List<CityRegion> get _areas => _cities[_cityIndex].children;

  CityPickerResult get _result {
    return CityPickerResult(
      province: _provinces[_provinceIndex],
      city: _cities[_cityIndex],
      area: _areas[_areaIndex],
    );
  }

  @override
  void initState() {
    super.initState();
    _initIndexes();
    _provinceController = FixedExtentScrollController(
      initialItem: _provinceIndex,
    );
    _cityController = FixedExtentScrollController(initialItem: _cityIndex);
    _areaController = FixedExtentScrollController(initialItem: _areaIndex);
  }

  @override
  void dispose() {
    _provinceController.dispose();
    _cityController.dispose();
    _areaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedColumn(
      height: 288 + context.padding.bottom,
      safeArea: SafeAreaConfig.bottom(),
      color: context.backgroundColor,
      children: [
        DecoratedRow(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            TextButton(
              onPressed: () => context.rootNavigator.pop(),
              child: Text(
                widget.cancelText ?? '取消',
                style: const TextStyle(color: Colors.red),
              ),
            ),
            if (widget.title != null) widget.title!,
            TextButton(
              onPressed: () => context.rootNavigator.pop(_result),
              child: Text(widget.confirmText ?? '确定'),
            ),
          ],
        ),
        kDivider1,
        Expanded(
          child: DecoratedRow(
            children: [
              _buildPicker(
                controller: _provinceController,
                data: _provinces,
                onSelectedItemChanged: _handleProvinceChanged,
              ),
              _buildPicker(
                controller: _cityController,
                data: _cities,
                onSelectedItemChanged: _handleCityChanged,
              ),
              _buildPicker(
                controller: _areaController,
                data: _areas,
                onSelectedItemChanged: (value) {
                  setState(() => _areaIndex = value);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _initIndexes() {
    final initialValue = widget.initialValue;
    _provinceIndex = _indexOf(
      widget.data,
      widget.initialProvinceCode ?? initialValue?.province.code,
    );
    _cityIndex = _indexOf(
      widget.data[_provinceIndex].children,
      widget.initialCityCode ?? initialValue?.city.code,
    );
    _areaIndex = _indexOf(
      widget.data[_provinceIndex].children[_cityIndex].children,
      widget.initialAreaCode ?? initialValue?.area.code,
    );
  }

  int _indexOf(List<CityRegion> data, String? code) {
    if (code == null) return 0;
    final index = data.indexWhere((item) => item.code == code);
    return index < 0 ? 0 : index;
  }

  Widget _buildPicker({
    required FixedExtentScrollController controller,
    required List<CityRegion> data,
    required ValueChanged<int> onSelectedItemChanged,
  }) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: controller,
        itemExtent: widget.itemExtent,
        onSelectedItemChanged: onSelectedItemChanged,
        children: [
          for (final item in data)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodyMedium,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleProvinceChanged(int value) {
    setState(() {
      _provinceIndex = value;
      _cityIndex = 0;
      _areaIndex = 0;
      _cityController.jumpToItem(0);
      _areaController.jumpToItem(0);
    });
  }

  void _handleCityChanged(int value) {
    setState(() {
      _cityIndex = value;
      _areaIndex = 0;
      _areaController.jumpToItem(0);
    });
  }
}
