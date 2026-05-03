import 'package:climtech/ui/select_location/widgets/search_widget.dart';
import 'package:climtech/utils/estilos_pradroes.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margem(),
      child: Column(
        children: [
          SizedBox(height: 5.h),

          LocationSearchWidget(),
        ],
      ),
    );
  }
}
