import 'package:bigbluebuttonsdk/utils/beautyFilters.dart';
import 'package:flutter/material.dart';


class BeautyFilterWidget extends StatefulWidget {
  const BeautyFilterWidget({super.key,});

  @override
  State<StatefulWidget> createState() => _BeautyFilterWidgetState();
}

class _BeautyFilterWidgetState extends State<BeautyFilterWidget> {
  late final BeautyFilters _beautyFilters;

  @override
  void initState() {
    super.initState();

    // _beautyFilters = AppBloc.beautyFiltersBloc.filters.copyWith();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              return Row(
                children: [
                  // Lottie.asset(
                  //   Assets.lotties.beautyFiltersLottie,
                  //   width: constraints.maxWidth * 0.2,
                  //   fit: BoxFit.contain,
                  //   frameRate: FrameRate.max,
                  //   repeat: true,
                  // ),
                  SizedBox(width: 24),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: constraints.maxWidth * 0.06,
                        // fontFamily: FontFamily.pixelify,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Beauty',
                          style: TextStyle(
                            color: Color(0xFFEFB7E9),
                          ),
                        ),
                        TextSpan(
                          text: '\t\tFilters',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          _buildSliderButton(
            "Strings.smooth.i18n",
            _beautyFilters.smoothValue,
                (value) {
              setState(() {
                _beautyFilters.smoothValue = value;
              });
            },
          ),
          _buildSliderButton(
            "Strings.white.i18n",
            _beautyFilters.whiteValue,
                (value) {
              setState(() {
                _beautyFilters.whiteValue = value;
              });
            },
          ),
          _buildSliderButton(
            "Strings.thinFace.i18n",
            _beautyFilters.thinFaceValue * 10,
                (value) {
              setState(() {
                _beautyFilters.thinFaceValue = value / 10;
              });
            },
          ),
          _buildSliderButton(
            "Strings.bigEyes.i18n",
            _beautyFilters.bigEyeValue * 5,
                (value) {
              setState(() {
                _beautyFilters.bigEyeValue = value / 5;
              });
            },
          ),
          _buildSliderButton(
            "Strings.lipstick.i18n",
            _beautyFilters.lipstickValue,
                (value) {
              setState(() {
                _beautyFilters.lipstickValue = value;
              });
            },
          ),
          _buildSliderButton(
            "Strings.blusher.i18n",
            _beautyFilters.blusherValue,
                (value) {
              setState(() {
                _beautyFilters.blusherValue = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSliderButton(
      String label,
      double value,
      Function(double) onChanged,
      ) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontSize: 11,
          ),
        ),
        Slider(
          value: value,
          activeColor: Theme.of(context).colorScheme.primary,
          onChanged: (val) {
            onChanged(val);
            _update();
          },
        ),
      ],
    );
  }

  void _update() {
    // AppBloc.beautyFiltersBloc.add(
    //   UpdateFiltersValueEvent(filters: _beautyFilters),
    // );
  }
}