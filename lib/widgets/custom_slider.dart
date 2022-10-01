import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_erp/storage/config.dart';
import 'package:school_erp/utils/navigation_helper.dart';
import 'package:school_erp/widgets/photo_viewer.dart';

class CustomSlider extends StatefulWidget {
  const CustomSlider({
    Key? key,
    required this.filesUrl,
  }) : super(key: key);
  final List<String> filesUrl;

  @override
  State<CustomSlider> createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider>
    with SingleTickerProviderStateMixin {
  late final int _numDots;
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _numDots = widget.filesUrl.length;
    _controller = TabController(length: _numDots, vsync: this);
  }

  void _setIndex(int i) {
    setState(() {
      _controller.index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * .4,
      child: Stack(
        children: [
          PageView.builder(
            itemCount: widget.filesUrl.length,
            onPageChanged: _setIndex,
            itemBuilder: (context, i) {
              return InkWell(
                onTap: () {
                  NavigationHelper.push(
                      context: context,
                      page: PhotoViewer(
                        urls: widget.filesUrl,
                        index: i,
                      ));
                },
                child: CachedNetworkImage(
                  imageUrl: Config.baseUrl + widget.filesUrl[i],
                  placeholder: (context, url) =>
                      Center(child: CircularProgressIndicator()),
                ),
              );
            },
          ),
          if (_numDots > 1)
            Align(
              alignment: Alignment.bottomCenter,
              child: TabPageSelector(
                controller: _controller,
              ),
            ),
        ],
      ),
    );
  }
}
