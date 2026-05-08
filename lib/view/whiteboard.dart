import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../provider/whiteboardcontroller.dart';
import '../whiteboard/flutter_painter.dart';

class Whiteboard extends StatefulWidget {
  const Whiteboard({super.key});

  @override
  State<Whiteboard> createState() => _WhiteboardState();
}

class _WhiteboardState extends State<Whiteboard> {
  final Whiteboardcontroller controller = Get.find<Whiteboardcontroller>();
  final ScrollController _pagesScrollController = ScrollController();

  bool showShapesPanel = false;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    controller.controller.transformationController.addListener(_handleZoomChange);
  }

  void _handleZoomChange() {
    final matrix = controller.controller.transformationController.value;
    final scale = matrix.getMaxScaleOnAxis();
    if (mounted && (scale - _zoomLevel).abs() > 0.01) {
      setState(() {
        _zoomLevel = scale;
      });
    }
  }

  @override
  void dispose() {
    controller.controller.transformationController.removeListener(_handleZoomChange);
    _pagesScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isPresenter =
          controller.websocket.myDetails?.fields?.presenter == true;

      return Scaffold(
        body: Stack(
          children: [
            Positioned.fill(
              child: Center(
                child: ValueListenableBuilder<PainterControllerValue>(
                  valueListenable: controller.controller,
                  builder: (context, value, child) {
                    return AspectRatio(
                      aspectRatio: (controller.controller.virtualCanvasSize?.width ?? 4) /
                          (controller.controller.virtualCanvasSize?.height ?? 3),
                      child: child!,
                    );
                  },
                  child: FlutterPainter(
                    controller: controller.controller,
                    onDrawableCreated: controller.onDrawableCreated,
                    onDrawableDeleted: controller.onDrawableDeleted,
                  ),
                ),
              ),
            ),
            if (showShapesPanel)
              Positioned(
                bottom: 84,
                left: 0,
                right: 0,
                child: Center(
                  child: _ShapesPanel(
                    onSelect: (factory) {
                      setState(() => showShapesPanel = false);
                      controller.selectToolShape(factory);
                    },
                  ),
                ),
              ),
              Positioned(
                bottom: 14,
                left: 12,
                right: 12,
                child: Row(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("${(_zoomLevel * 100).round()}%",
                            style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.zoom_in, size: 20),
                              onPressed: controller.zoomIn,
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.zoom_out, size: 20),
                              onPressed: controller.zoomOut,
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (isPresenter)
                    Column(
                      children: [
                        const SizedBox(width: 4),
                        Flexible(
                          child: _Toolbar(
                            controller: controller,
                            onToggleShapes: () =>
                                setState(() => showShapesPanel = !showShapesPanel),
                            onOpenMore: () => _openMoreMenu(context),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _SquareButton(
                          icon: Icons.draw,
                          onPressed: controller.selectToolHighlighter,
                        ),
                        const SizedBox(width: 10),
                        _SquareButton(
                          icon: Icons.help_outline,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      if (isPresenter)
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF7A00),
                            foregroundColor: Colors.white,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 12,
                            ),
                          ),
                          onPressed: controller.addNewPage,
                          child: const Text("+ New Page"),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Obx(() {
                          final pages = controller.pages;
                          final selected = controller.currentPage.value;
                          return Scrollbar(
                            controller: _pagesScrollController,
                            thumbVisibility: true,
                            thickness: 3,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: SingleChildScrollView(
                                controller: _pagesScrollController,
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    for (final p in pages)
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: selected == p
                                                ? Colors.white
                                                : const Color(0xFFFF7A00),
                                            backgroundColor: selected == p
                                                ? const Color(0xFFFF7A00)
                                                : Colors.white,
                                            side: const BorderSide(
                                              color: Color(0xFFFF7A00),
                                            ),
                                            shape: const StadiumBorder(),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 10,
                                            ),
                                          ),
                                          onPressed: () =>
                                              controller.selectPage(p),
                                          child: Text("page:$p"),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  void _openMoreMenu(BuildContext context) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.undo),
                title: const Text("Undo"),
                onTap: () => Navigator.pop(context, "undo"),
              ),
              ListTile(
                leading: const Icon(Icons.redo),
                title: const Text("Redo"),
                onTap: () => Navigator.pop(context, "redo"),
              ),
              ListTile(
                leading: const Icon(Icons.palette_outlined),
                title: const Text("Pen settings"),
                onTap: () => Navigator.pop(context, "penSettings"),
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline),
                title: const Text("Clear page"),
                onTap: () => Navigator.pop(context, "clear"),
              ),
            ],
          ),
        );
      },
    );

    switch (result) {
      case "undo":
        controller.undo();
        break;
      case "redo":
        controller.redo();
        break;
      case "penSettings":
        if (mounted) _openPenSettings(context);
        break;
      case "clear":
        controller.controller.clearDrawables(newAction: true);
        break;
    }
  }

  void _openPenSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final colors = <Color>[
          Colors.black,
          Colors.grey,
          const Color(0xFFD291FF),
          const Color(0xFFB44CFF),
          const Color(0xFF2E5BFF),
          const Color(0xFF39A0FF),
          const Color(0xFFFFB15A),
          const Color(0xFFFF6A00),
          const Color(0xFF0AA06E),
          const Color(0xFF4CD964),
          const Color(0xFFFF7A7A),
          const Color(0xFFFF0000),
        ];

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (final c in colors)
                      _ColorDot(
                        color: c,
                        selected:
                            controller.controller.freeStyleColor == c,
                        onTap: () {
                          controller.controller.freeStyleColor = c;
                          controller.selectToolPen();
                          setState(() {});
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: controller.controller.freeStyleStrokeWidth,
                        min: 2,
                        max: 30,
                        onChanged: (v) {
                          controller.controller.freeStyleStrokeWidth = v;
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    _SizeChip(
                      label: "S",
                      selected: controller.controller.freeStyleStrokeWidth <= 6,
                      onTap: () =>
                          controller.controller.freeStyleStrokeWidth = 4,
                    ),
                    const SizedBox(width: 8),
                    _SizeChip(
                      label: "M",
                      selected: controller.controller.freeStyleStrokeWidth > 6 &&
                          controller.controller.freeStyleStrokeWidth <= 12,
                      onTap: () =>
                          controller.controller.freeStyleStrokeWidth = 8,
                    ),
                    const SizedBox(width: 8),
                    _SizeChip(
                      label: "L",
                      selected: controller.controller.freeStyleStrokeWidth > 12 &&
                          controller.controller.freeStyleStrokeWidth <= 20,
                      onTap: () =>
                          controller.controller.freeStyleStrokeWidth = 16,
                    ),
                    const SizedBox(width: 8),
                    _SizeChip(
                      label: "XL",
                      selected: controller.controller.freeStyleStrokeWidth > 20,
                      onTap: () =>
                          controller.controller.freeStyleStrokeWidth = 24,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Toolbar extends StatefulWidget {
  final Whiteboardcontroller controller;
  final VoidCallback onToggleShapes;
  final VoidCallback onOpenMore;

  const _Toolbar({
    required this.controller,
    required this.onToggleShapes,
    required this.onOpenMore,
  });

  @override
  State<_Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<_Toolbar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Listen to controller changes to update tool selection state
    widget.controller.controller.addListener(_rebuild);
    widget.controller.textFocusNode.addListener(_rebuild);
  }

  @override
  void dispose() {
    widget.controller.controller.removeListener(_rebuild);
    widget.controller.textFocusNode.removeListener(_rebuild);
    _scrollController.dispose();
    super.dispose();
  }

  void _rebuild() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        child: Scrollbar(
          controller: _scrollController,
          thumbVisibility: true,
          thickness: 3,
          radius: const Radius.circular(10),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6), // Space for scrollbar
            child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                final selectedTool = widget.controller.selectedTool.value;
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ToolButton(
                      icon: Icons.near_me_outlined,
                      selected: selectedTool == "select",
                      onPressed: widget.controller.selectToolSelect,
                    ),
                    _ToolButton(
                      icon: Icons.pan_tool_alt_outlined,
                      selected: selectedTool == "hand",
                      onPressed: widget.controller.selectToolHand,
                    ),
                    _ToolButton(
                      icon: Icons.edit_outlined,
                      selected: selectedTool == "pen",
                      onPressed: widget.controller.selectToolPen,
                    ),
                    _ToolButton(
                      icon: Icons.brush_outlined,
                      selected: selectedTool == "highlighter",
                      onPressed: widget.controller.selectToolHighlighter,
                    ),
                    _ToolButton(
                      icon: Icons.auto_fix_off_outlined,
                      selected: selectedTool == "eraser",
                      onPressed: widget.controller.selectToolEraser,
                    ),
                    _ToolButton(
                      icon: Icons.arrow_outward,
                      selected: selectedTool == "arrow",
                      onPressed: () =>
                          widget.controller.selectToolShape(ArrowFactory()),
                    ),
                    _ToolButton(
                      icon: Icons.text_fields,
                      selected: selectedTool == "text",
                      onPressed: widget.controller.addText,
                    ),
                    _ToolButton(
                      icon: Icons.edit_note_outlined,
                      selected: false,
                      onPressed: () => widget.controller.addSticker(context),
                    ),
                    _ToolButton(
                      icon: Icons.crop_square,
                      selected: selectedTool == "rectangle",
                      onPressed: () =>
                          widget.controller.selectToolShape(RectangleFactory()),
                    ),
                    _ToolButton(
                      icon: Icons.keyboard_arrow_up,
                      selected: false,
                      onPressed: widget.onToggleShapes,
                    ),
                    _ToolButton(
                      icon: Icons.more_vert,
                      selected: false,
                      onPressed: widget.onOpenMore,
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onPressed;

  const _ToolButton({
    required this.icon,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onPressed,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF2E6BFF) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 22,
            color: selected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SquareButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onPressed,
        child: SizedBox(
          width: 52,
          height: 52,
          child: Icon(icon, color: Colors.black87),
        ),
      ),
    );
  }
}

class _ShapesPanel extends StatelessWidget {
  final ValueChanged<ShapeFactory?> onSelect;

  const _ShapesPanel({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final items = <MapEntry<IconData, ShapeFactory?>>[
      MapEntry(Icons.linear_scale_sharp, LineFactory()),
      MapEntry(Icons.arrow_forward, ArrowFactory()),
      MapEntry(Icons.arrow_back, DoubleArrowFactory()),
      MapEntry(Icons.rectangle_outlined, RectangleFactory()),
      MapEntry(Icons.circle_outlined, OvalFactory()),
      MapEntry(Icons.change_history, TriangleFactory()),
      MapEntry(Icons.diamond_outlined, RhombusFactory()),
      MapEntry(Icons.filter_none, TrapezoidFactory()),
      MapEntry(Icons.hexagon_outlined, HexagonFactory()),
      MapEntry(Icons.cloud_outlined, CloudFactory()),
      MapEntry(Icons.star_outline, StarFactory()),
      MapEntry(Icons.check_box_outline_blank, XBoxFactory()),
      MapEntry(Icons.check_box_outlined, CheckBoxFactory()),
      const MapEntry(Icons.close, null),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final item in items)
              InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onSelect(item.value),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Icon(item.key, color: Colors.black87),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selected ? const Color(0xFF2E6BFF) : Colors.black12,
            width: selected ? 2 : 1,
          ),
        ),
      ),
    );
  }
}

class _SizeChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SizeChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        width: 44,
        height: 34,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF2E6BFF) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
