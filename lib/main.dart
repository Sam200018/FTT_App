import 'package:fast_fourier_transform/src/charts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fast_fourier_transform/src/fourier_bloc/fourier_transform_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final TextEditingController _a = TextEditingController(),
      _b = TextEditingController(),
      _pow2 = TextEditingController();
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FourierTransformBloc(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fast Fourier Transform',
        routes: {'/charts': (_) => const Charts()},
        home: Scaffold(
          backgroundColor: const Color.fromRGBO(23, 23, 23, 1.0),
          appBar: AppBar(
            title: const Text(
              'Fast Fourier Transform',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromRGBO(32, 33, 36, 1.0),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InputNumberA(
                      a: _a,
                    ),
                    InputNumberB(
                      b: _b,
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 100.0),
                  child: InputPow(
                    pow: _pow2,
                  ),
                ),
                const SizedBox(height: 60.0),
                ButtonToFFT(
                    signal: "f(x)= A * Cos(BX)", a: _a, b: _b, pow2: _pow2),
                const SizedBox(height: 20.0),
                ButtonToFFT(
                    signal: "f(x)= A * Sen(BX)", a: _a, b: _b, pow2: _pow2),
                const SizedBox(height: 20.0),
                const ButtonFile(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InputNumberA extends StatefulWidget {
  final TextEditingController a;

  const InputNumberA({Key? key, required this.a}) : super(key: key);

  @override
  State<InputNumberA> createState() => _InputNumberAState();
}

class _InputNumberAState extends State<InputNumberA> {
  late TextEditingController a;
  @override
  void initState() {
    a = widget.a;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'A=',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 50.0,
          child: TextField(
            decoration: const InputDecoration(
                counterStyle: TextStyle(color: Colors.white)),
            autofocus: false,
            maxLength: 3,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40.0,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                a.text = value;
              });
            },
          ),
        )
      ],
    );
  }
}

class InputNumberB extends StatefulWidget {
  final TextEditingController b;

  const InputNumberB({Key? key, required this.b}) : super(key: key);

  @override
  State<InputNumberB> createState() => _InputNumberBState();
}

class _InputNumberBState extends State<InputNumberB> {
  late TextEditingController b;
  @override
  void initState() {
    b = widget.b;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          'B=',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 50.0,
          child: TextField(
            decoration: const InputDecoration(
                counterStyle: TextStyle(color: Colors.white)),
            autofocus: false,
            maxLength: 3,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 40.0,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                b.text = value;
              });
            },
          ),
        )
      ],
    );
  }
}

class InputPow extends StatefulWidget {
  final TextEditingController pow;

  const InputPow({Key? key, required this.pow}) : super(key: key);

  @override
  State<InputPow> createState() => _InputPowState();
}

class _InputPowState extends State<InputPow> {
  late TextEditingController pw2;

  @override
  void initState() {
    pw2 = widget.pow;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          '2^',
          style: TextStyle(
            fontSize: 40,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 50.0,
          child: TextField(
            decoration: const InputDecoration(
                counterStyle: TextStyle(color: Colors.white)),
            autofocus: false,
            maxLength: 3,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 30.0,
            ),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                pw2.text = value;
              });
            },
          ),
        ),
      ],
    );
  }
}

class ButtonToFFT extends StatelessWidget {
  final String signal;
  final TextEditingController a, b, pow2;

  const ButtonToFFT(
      {Key? key,
      required this.signal,
      required this.a,
      required this.b,
      required this.pow2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.cyan),
      onPressed: () {
        if (signal == "f(x)= A * Sen(BX)") {
          BlocProvider.of<FourierTransformBloc>(context).add(TransformSen(
              int.parse(a.text), int.parse(b.text), int.parse(pow2.text)));
        } else if (signal == "f(x)= A * Cos(BX)") {
          BlocProvider.of<FourierTransformBloc>(context).add(TransformCos(
              int.parse(a.text), int.parse(b.text), int.parse(pow2.text)));
        }

        Navigator.pushNamed(context, '/charts', arguments: signal);
      },
      child: Text(
        signal,
        style: const TextStyle(color: Colors.white, fontSize: 40.0),
      ),
    );
  }
}

class ButtonFile extends StatelessWidget {
  const ButtonFile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(backgroundColor: Colors.cyan),
      onPressed: () {
        BlocProvider.of<FourierTransformBloc>(context).add(TransformFromFile());
        Navigator.pushNamed(context, '/charts', arguments: '1024 Samples');
      },
      child: const Text(
        'Load File',
        style: TextStyle(color: Colors.white, fontSize: 40.0),
      ),
    );
  }
}
