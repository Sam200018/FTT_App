import 'dart:io';
import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:complex/complex.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

part 'fourier_transform_event.dart';
part 'fourier_transform_state.dart';

class FourierTransformBloc
    extends Bloc<FourierTransformEvent, FourierTransformState> {
  static List<Complex> fTT = [];

  FourierTransformBloc() : super(FourierTransformInitial()) {
    on<TransformSen>(_onTransformSenToState);
    on<TransformCos>(_onTransformCosToState);
    on<TransformFromFile>(_onTransformFileToState);
  }

  void _onTransformSenToState(
      TransformSen event, Emitter<FourierTransformState> emit) {
    List<Complex> signalDicrete = signalSinD(event.a, event.b, event.pow2);
    // print(signalDicrete);
    emit(LoadingTranform());
    fTT = fft(signalDicrete);
    // print(fTT);
    emit(LoadedTranform());
  }

  void _onTransformCosToState(
      TransformCos event, Emitter<FourierTransformState> emit) {
    List<Complex> signalDicrete = signalCosD(event.a, event.b, event.pow2);
    // print(signalDicrete);
    emit(LoadingTranform());
    fTT = fft(signalDicrete);
    // print(fTT);
    emit(LoadedTranform());
  }

  Future<void> _onTransformFileToState(
      TransformFromFile event, Emitter<FourierTransformState> emit) async {
    try {
      emit(LoadingTranform());
      List<String> transformFile = await getFileLines();
      // List<Complex> trasnformFileSignal = signalFileD(transformFile);
      List<Complex> signalDiscreteFromFile = signalFileD(transformFile);
      fTT = fft(signalDiscreteFromFile);
      emit(LoadedTranform());
    } catch (e) {
      // print(e);
    }
  }

  //ftt
  List<Complex> fft(List<Complex> signal) {
    int n = signal.length;
    List<Complex> espectro = List.filled(n, const Complex(0));
    if (n == 1) {
      return signal;
    }

    List<Complex> even = List.filled(n ~/ 2, const Complex(0));
    for (var i = 0; i < n ~/ 2; i++) {
      even[i] = signal[2 * i];
    }

    List<Complex> evenFFT = fft(even);

    List<Complex> odd = List.filled(n ~/ 2, const Complex(0));
    for (var j = 0; j < n ~/ 2; j++) {
      odd[j] = signal[2 * j + 1];
    }
    List<Complex> oddFFT = fft(odd);

    for (var k = 0; k < n ~/ 2; k++) {
      double kth = -2 * k * pi / n;
      Complex wk = Complex(cos(kth), sin(kth));
      espectro[k] = evenFFT[k] + (wk * oddFFT[k]);
      espectro[k + n ~/ 2] = evenFFT[k] - (wk * oddFFT[k]);
    }

    return espectro;
  }

  //Signal Converter
  List<Complex> signalSinD(int a, int b, int pow2) {
    List<Complex> signalD = [];
    Complex discrete;
    for (var i = 0; i < pow(2, pow2); i++) {
      discrete = Complex(a * sin(b * i));
      signalD.add(discrete);
    }
    return signalD;
  }

  //Signal Converter
  List<Complex> signalCosD(int a, int b, int pow2) {
    List<Complex> signalD = [];
    Complex discrete;
    for (var i = 0; i < pow(2, pow2); i++) {
      discrete = Complex(a * cos(b * i));
      signalD.add(discrete);
    }
    return signalD;
  }

  List<Complex> signalFileD(List<String> signal) {
    List<Complex> signalD = [];
    Complex discrete;
    double pulseS;
    for (var pulse in signal) {
      pulseS = double.parse(pulse);
      discrete = Complex(pulseS);
      signalD.add(discrete);
    }
    return signalD;
  }

  Future<List<String>> getFileLines() async {
    final data = await rootBundle.load('assets/muestras.txt');
    final directory = (await getTemporaryDirectory()).path;
    final file = await writeToFile(data, '$directory/muestras.txt');
    return file.readAsLines();
  }

  Future<File> writeToFile(ByteData data, String path) {
    return File(path).writeAsBytes(data.buffer.asUint8List(
      data.offsetInBytes,
      data.lengthInBytes,
    ));
  }
}
