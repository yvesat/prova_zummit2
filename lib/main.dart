import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:prova_zummit/pages/valor_emprestimo_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // runApp(const MyApp());
  runApp(
    ProviderScope(
      child: MaterialApp(
        theme: FlexThemeData.light(scheme: FlexScheme.amber),
        // darkTheme: FlexThemeData.dark(scheme: FlexScheme.amber),
        debugShowCheckedModeBanner: false,
        home: const ValorEmprestimoPage(),
      ),
    ),
  );
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: FlexThemeData.light(scheme: FlexScheme.amber),
//       // darkTheme: FlexThemeData.dark(scheme: FlexScheme.amber),
//       debugShowCheckedModeBanner: false,
//       home: const ValorEmprestimoPage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Center(child: Text('Empresta Bem Melhor')),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             // Campo(
//             //   icon: FontAwesomeIcons.sackDollar,
//             //   label: "Valor do Empréstimo",
//             //   child: Column(
//             //     children: [
//             //       TextField(
//             //         controller: _edtValorEmprestimo,
//             //         keyboardType: TextInputType.number,
//             //         onSubmitted: (valor) {
//             //           setState(() {
//             //             valorEditado = NumberFormat.simpleCurrency(locale: 'PT-br', decimalDigits: 2).format(double.parse(valor));
//             //           });
//             //         },
//             //       ),
//             //       Text(valorEditado),
//             //     ],
//             //   ),
//             // ),
//             // Campo(
//             //   icon: FontAwesomeIcons.building,
//             //   label: "Instituição",
//             //   child: Text(""),
//             // ),
//             // Campo(
//             //   icon: FontAwesomeIcons.briefcase,
//             //   label: "Convênio",
//             //   child: Text(""),
//             // ),
//             // Campo(
//             //   icon: FontAwesomeIcons.calculator,
//             //   label: "Parcelas",
//             //   child: ListView.builder(
//             //     shrinkWrap: true,
//             //     itemCount: parcelas.length,
//             //     itemBuilder: (context, index) => ListTile(
//             //       title: Center(child: Text(parcelas[index].toString())),
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
// }
