import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'package:fast_fourier_transform/src/fourier_bloc/fourier_transform_bloc.dart';

class Charts extends StatelessWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signal = ModalRoute.of(context)!.settings.arguments;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: BlocBuilder<FourierTransformBloc, FourierTransformState>(
            builder: (context, state) {
              if (state is LoadedTranform) {
                return SfCartesianChart(
                  borderWidth: 1.0,
                  backgroundColor: const Color.fromRGBO(23, 23, 23, 1.0),
                  legend: Legend(
                    isVisible: true,
                    isResponsive: true,
                    textStyle:
                        const TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  title: ChartTitle(
                      text: signal.toString(),
                      textStyle: const TextStyle(color: Colors.white)),
                  series: [
                    ScatterSeries<FourierChart, double>(
                      name: 'Real',
                      color: Colors.deepPurple,
                      dataSource: getChartDataRe(),
                      xValueMapper: (FourierChart x, _) => x.index,
                      yValueMapper: (FourierChart x, _) => x.value,
                      markerSettings: const MarkerSettings(
                        height: 20,
                        width: 20,
                      ),
                    ),
                    ScatterSeries<FourierChart, double>(
                      name: 'Imaginary',
                      color: Colors.amber,
                      dataSource: getChartDataIm(),
                      xValueMapper: (FourierChart x, _) => x.index,
                      yValueMapper: (FourierChart x, _) => x.value,
                      markerSettings: const MarkerSettings(
                        height: 20,
                        width: 20,
                      ),
                    )
                  ],
                );
              } else {
                return const CircularProgressIndicator();
              }
            },
          ),
        ),
      ),
    );
  }

  List<FourierChart> getChartDataRe() {
    final List<FourierChart> chart = [];
    double i = 0;
    for (var item in FourierTransformBloc.fTT) {
      chart.add(FourierChart(i, item.real));
      i++;
    }
    return chart;
  }

  List<FourierChart> getChartDataIm() {
    final List<FourierChart> chart = [];
    double i = 0;
    for (var item in FourierTransformBloc.fTT) {
      chart.add(FourierChart(i, item.imaginary));
      i++;
    }
    return chart;
  }
}

class FourierChart {
  final double index, value;
  FourierChart(this.index, this.value);
}
