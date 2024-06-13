import 'package:covid_tracker/View/Countries_list.dart';
import 'package:covid_tracker/models/world_states_Model.dart';
import 'package:covid_tracker/services/utilities/state_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';

class WORLDSTATESSCREEN extends StatefulWidget {
  const WORLDSTATESSCREEN({super.key});

  @override
  State<WORLDSTATESSCREEN> createState() => _WORLDSTATESSCREENState();
}

class _WORLDSTATESSCREENState extends State<WORLDSTATESSCREEN>
    with TickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(duration: const Duration(seconds: 5), vsync: this)
        ..repeat();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  final colorlist = <Color>[
    const Color(0xff4285F4),
    const Color.fromARGB(255, 255, 213, 0),
    const Color.fromARGB(255, 255, 0, 0),
  ];

  @override
  Widget build(BuildContext context) {
    StatesServices statesServices = StatesServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            FutureBuilder(
                future: statesServices.fecthWorkdStatesRecord(),
                builder: (context, AsyncSnapshot<worldstatesModel> snapshot) {
                  if (!snapshot.hasData) {
                    return Expanded(
                        flex: 1,
                        child: SpinKitFadingCircle(
                          color: Colors.white,
                          size: 50,
                          controller: _controller,
                        ));
                  } else {
                    return Column(
                      children: [
                        PieChart(
                          dataMap: {
                            "total":
                                double.parse(snapshot.data!.cases!.toString()),
                            "recovered": double.parse(
                                snapshot.data!.recovered!.toString()),
                            "denths":
                                double.parse(snapshot.data!.deaths!.toString()),
                          },
                          chartValuesOptions: ChartValuesOptions(
                            showChartValuesInPercentage: true,
                          ),
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          legendOptions: LegendOptions(
                            legendPosition: LegendPosition.left,
                          ),
                          animationDuration: Duration(milliseconds: 1200),
                          chartType: ChartType.ring,
                          colorList: colorlist,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.height * .06),
                          child: Card(
                            child: Column(
                              children: [
                                ReusableRow(
                                    title: "total",
                                    value: snapshot.data!.cases.toString()),
                                ReusableRow(
                                    title: "ACTIVE",
                                    value: snapshot.data!.recovered.toString()),
                                ReusableRow(
                                    title: "DETH",
                                    value: snapshot.data!.deaths.toString()),
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => COUNTRIESLIST(),
                                ));
                          },
                          child: Container(
                            height: 50,
                            decoration: const BoxDecoration(
                                color: Colors.amber,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                              child: Text('track contaries'),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                }),
          ],
        ),
      )),
    );
  }
}

class ReusableRow extends StatelessWidget {
  final String title;
  final String value;

  const ReusableRow({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Divider(),
        ],
      ),
    );
  }
}
