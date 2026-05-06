import 'package:climtech/ui/select_location/view_models/locations_saves_viewmodel.dart';
import 'package:climtech/ui/select_location/view_models/select_location_viewmodel.dart';
import 'package:climtech/ui/select_location/widgets/components.dart';
import 'package:climtech/ui/select_location/widgets/search_widget.dart';
import 'package:climtech/utils/estilos_pradroes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SelectLocationScreen extends StatefulWidget {
  const SelectLocationScreen({super.key});

  @override
  State<SelectLocationScreen> createState() => _SelectLocationScreenState();
}

class _SelectLocationScreenState extends State<SelectLocationScreen> {
  @override
  void deactivate() {
    Provider.of<SelectLocationViewmodel>(context, listen: false).reset();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final slProv = Provider.of<SelectLocationViewmodel>(context);
    final scProv = Provider.of<LocationsSavesViewmodel>(context);
    final tema = Theme.of(context).colorScheme;

    return Padding(
      padding: margem(),
      child: Column(
        // ← sem SingleChildScrollView na raiz
        children: [
          SizedBox(height: 5.h),

          LocationSearchWidget(),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              margin: EdgeInsets.only(top: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: tema.onSecondary,
              ),
              child: slProv.selectedState == null
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Salvos', style: estiloTexto(15)),
                        Expanded(
                          child: scProv.locaisSalvos.isEmpty
                              ? Center(
                                  child: Text(
                                    'Nenhum local salvo!',
                                    style: estiloTexto(15),
                                  ),
                                )
                              : ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  itemCount: scProv.locaisSalvos.length,
                                  itemBuilder: (context, index) {
                                    return cardSalvos(
                                      tema,
                                      scProv.locaisSalvos[index],
                                      scProv,
                                      index,
                                      slProv,
                                      context,
                                    );
                                  },
                                ),
                        ),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Resultados', style: estiloTexto(15)),
                        Expanded(
                          // ← mesma coisa aqui
                          child: ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: slProv.citySuggestions.length,
                            itemBuilder: (context, index) {
                              return cardResultados(
                                tema,
                                slProv.citySuggestions[index],
                                slProv,
                                scProv,
                                context,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ),

          SizedBox(height: 2.h),
        ],
      ),
    );
  }
}
