part of 'fourier_transform_bloc.dart';

@immutable
abstract class FourierTransformState {}

class FourierTransformInitial extends FourierTransformState {}

class LoadingTranform extends FourierTransformState {}

class LoadedTranform extends FourierTransformState {}
