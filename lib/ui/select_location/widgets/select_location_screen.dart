import 'package:climtech/ui/select_location/view_models/locations_saves_viewmodel.dart';
import 'package:climtech/ui/select_location/view_models/select_location_viewmodel.dart';
import 'package:climtech/ui/select_location/widgets/components.dart';
import 'package:climtech/ui/select_location/widgets/search_widget.dart';
import 'package:climtech/utils/estilos_pradroes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SelectLocationScreen extends StatelessWidget {
  const SelectLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final slProv = Provider.of<SelectLocationViewmodel>(context);
    final scProv = Provider.of<LocationsSavesViewmodel>(context);

    final tema = Theme.of(context).colorScheme;
    return Padding(
      padding: margem(),
      child: Column(
        children: [
          SizedBox(height: 5.h),

          LocationSearchWidget(),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            margin: EdgeInsets.only(top: 5.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: tema.onSecondary,
            ),
            child: slProv.selectedState == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Salvos', style: estiloTexto(15)),
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: scProv.locaisSalvos.length,
                        itemBuilder: (context, index) {
                          return cardSalvos(tema, scProv.locaisSalvos[index]);
                        },
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Resultados', style: estiloTexto(15)),
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: slProv.citySuggestions.length,
                        itemBuilder: (context, index) {
                          return cardResultados(
                            tema,
                            slProv.citySuggestions[index],
                            slProv,
                            scProv,
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
