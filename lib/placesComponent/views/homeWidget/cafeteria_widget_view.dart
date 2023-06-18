import 'package:campus_flutter/base/helpers/cardWithPadding.dart';
import 'package:campus_flutter/base/helpers/delayedLoadingIndicator.dart';
import 'package:campus_flutter/base/helpers/horizontalSlider.dart';
import 'package:campus_flutter/homeComponent/widgetComponent/views/widget_frame_view.dart';
import 'package:campus_flutter/placesComponent/model/cafeterias/cafeteria_menu.dart';
import 'package:campus_flutter/placesComponent/model/cafeterias/dish.dart';
import 'package:campus_flutter/placesComponent/viewModels/cafeteria_widget_viewmodel.dart';
import 'package:campus_flutter/providers_get_it.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CafeteriaWidgetView extends ConsumerStatefulWidget {
  const CafeteriaWidgetView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CafeteriaWidgetViewState();
}

class _CafeteriaWidgetViewState extends ConsumerState<CafeteriaWidgetView> {

  @override
  void initState() {
    ref.read(cafeteriaWidgetViewModel).getClosestCafeteria();
    //Provider.of<CafeteriaWidgetViewModel>(context, listen: false).getClosestCafeteria();
    super.initState();
  }



  // TODO: make nice
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: ref.watch(cafeteriaWidgetViewModel).cafeteriaMenu,
        //stream: Provider.of<CafeteriaWidgetViewModel>(context).cafeteriaMenu,
        builder: (context, snapshot) {
          return WidgetFrameView(
            //title: Provider.of<CafeteriaWidgetViewModel>(context).cafeteria.value?.name ?? "Cafeteria",
            title: ref.watch(cafeteriaWidgetViewModel).cafeteria.value?.name ?? "Cafeteria",
          child: _dynamicContent(snapshot)
          );
        }
    );
  }
  
  Widget _dynamicContent(AsyncSnapshot<CafeteriaMenu?> snapshot) {
    if (snapshot.hasData) {
      //final dishes = Provider.of<CafeteriaWidgetViewModel>(context).getTodayDishes();
      final dishes = ref.watch(cafeteriaWidgetViewModel).getTodayDishes();
      return HorizontalSlider<(Dish, String)>(data: dishes, height: 160, child: (dish) {
        return _dishCard(dish);
      });
    } else if (snapshot.hasError) {
      return const Text("Error");
    } else {
      return const Card(
          child: SizedBox(
              height: 150,
              child: DelayedLoadingIndicator(name: "Mealplan")));
    }
  }

  Widget _dishCard((Dish, String) dish) {
    return CardWithPadding(
        height: 150,
        margin: const EdgeInsets.symmetric(vertical: 5.0),
        child: SizedBox(width: 150, child:
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child:
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                    Text(dish.$2, style: Theme.of(context).textTheme.titleLarge),
                    const Spacer(),
                    IconButton(
                        onPressed: () => _dishInfoAlert(dish.$1, context),
                        icon: Icon(Icons.info_outline, color: Theme.of(context).primaryColor),
                        padding: EdgeInsets.zero,
                        alignment: Alignment.centerRight,
                        highlightColor: Colors.transparent,
                    )
                  ],
                )),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Expanded(flex: 3, child: Text(dish.$1.name, maxLines: 3, overflow: TextOverflow.ellipsis,)),
            Expanded(child: Text(CafeteriaWidgetViewModel.formatPrice(dish.$1), maxLines: 1,))
          ],
        )
    ));
  }

  _dishInfoAlert(Dish dish, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(dish.name),
            content: Text(dish.prices.toString()),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Okay"))
            ],
          );
        }
    );
    /*
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text("Test"),
            content: Text("Test"),
            actions: [
              Text("Got it")
            ],
          );
        }
    );*/
  }
}