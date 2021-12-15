part of 'fourier_transform_bloc.dart';

@immutable
abstract class FourierTransformEvent {}

class TransformSen extends FourierTransformEvent {
  final int a, b, pow2;

  TransformSen(this.a, this.b, this.pow2);
}

class TransformCos extends FourierTransformEvent {
  final int a, b, pow2;

  TransformCos(this.a, this.b, this.pow2);
}

class TransformFromFile extends FourierTransformEvent {
  TransformFromFile();
}
