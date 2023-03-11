import 'package:flutter/material.dart';
import 'package:smart_lock_security/themes/app_color.dart';
import 'package:smart_lock_security/widget/widget/stateless_widget/sized_box_widget.dart';

class HomePageFeatureActionWidget extends StatefulWidget {
  final bool actionState;
  final Widget icon;
  final String title;
  final Function actionFuntion;
  final Color? colorAction;
  const HomePageFeatureActionWidget(
      {super.key,
      required this.actionState,
      required this.actionFuntion,
      required this.icon,
      required this.title,
      this.colorAction});

  @override
  State<HomePageFeatureActionWidget> createState() =>
      _HomePageFeatureActionWidgetState();
}

class _HomePageFeatureActionWidgetState
    extends State<HomePageFeatureActionWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: InkWell(
        onTap: () => widget.actionFuntion(),
        child: Container(
          height: 135,
          width: 135,
          decoration: BoxDecoration(
            color: widget.actionState
                ? (widget.colorAction ?? Colors.lightGreen)
                : AppColor.grey,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: AppColor.lightGrey2,
                offset: Offset(0.0, 2.0),
                blurRadius: 20.0,
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.icon,
              const SizedBox10H(),
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
