import 'package:flutter/foundation.dart'; // Necessário para kIsWeb
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String numero = '0'; // Inicializa com zero
  double primeiroNumero = 0.0;
  String operacao = '';

  void calcular(String tecla) {
    switch (tecla) {
      case '0':
      case '1':
      case '2':
      case '3':
      case '4':
      case '5':
      case '6':
      case '7':
      case '8':
      case '9':
      case ',':
        setState(() {
          if (numero == '0') {
            numero = tecla;
          } else {
            numero += tecla;
          }

          numero = numero.replaceAll(',', '.');

          if (numero.contains('.')) {
          } else {
            int numeroInt = int.parse(numero);
            numero = numeroInt.toString();
          }

          numero = numero.replaceAll('.', ',');
        });
        break;

      case '+':
      case '-':
      case 'X':
      case '/':
        operacao = tecla;
        numero = numero.replaceAll(',', '.');
        primeiroNumero = double.parse(numero);
        numero = '0';
        break;

      case '=':
        double resultado = 0.0;

        if (operacao == '/') {
          if (double.parse(numero) * 1 == 0) {
            print('Erro');
            return;
          }
        }

        if (operacao == '+') {
          resultado = primeiroNumero + double.parse(numero);
        } else if (operacao == '-') {
          resultado = primeiroNumero - double.parse(numero);
        } else if (operacao == 'X') {
          resultado = primeiroNumero * double.parse(numero);
        } else if (operacao == '/') {
          double divisor = double.parse(numero);
          if (divisor == 0.0) {
            resultado = double.nan;
          } else {
            resultado = primeiroNumero / divisor;
          }
        }

        String resultadoString = resultado.toStringAsFixed(10);
        List<String> resultadoPartes = resultadoString.split('.');

        if (int.parse(resultadoPartes[1]) == 0) {
          setState(() {
            numero = int.parse(resultadoPartes[0]).toString();
          });
        } else {
          setState(() {
            numero = resultado.toStringAsFixed(2);
          });
        }
        break;

      case 'AC':
        setState(() {
          numero = '0';
        });
        break;

      case 'del':
        setState(() {
          if (numero.length > 1) {
            numero = numero.substring(0, numero.length - 1);
          } else {
            numero = '0';
          }
        });
        break;

      default:
        numero += tecla;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child:
              kIsWeb
                  ? Container(
                    width: 400, // Largura de celular
                    height: 800, // Altura de celular
                    child: _buildCalculator(),
                  )
                  : _buildCalculator(),
        ),
      ),
    );
  }

  Widget _buildCalculator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              numero,
              style: TextStyle(fontSize: 80, color: Colors.white),
            ),
          ),
          _buildButtonRow(['AC', '', '', 'del'], [true, false, false, true]),
          _buildButtonRow(['7', '8', '9', '/']),
          _buildButtonRow(['4', '5', '6', 'X']),
          _buildButtonRow(['1', '2', '3', '-']),
          _buildButtonRow(['0', ',', '=', '+']),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> texts, [List<bool>? specialAlignment]) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          texts.asMap().entries.map((entry) {
            bool alignLeft = specialAlignment?[entry.key] ?? false;
            return entry.value.isNotEmpty
                ? _buildButton(
                  entry.value,
                  () => calcular(entry.value),
                  alignLeft: alignLeft,
                )
                : SizedBox(width: 70);
          }).toList(),
    );
  }

  Widget _buildButton(
    String text,
    VoidCallback onTap, {
    bool alignLeft = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        height: 80,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color:
              ['+', '-', 'X', '/', '='].contains(text)
                  ? Colors.pink
                  : Color(0xFF5E5858),
          shape: BoxShape.circle,
        ),
        child: Center(
          child:
              text == 'del'
                  ? Icon(Icons.backspace, size: 30, color: Colors.white)
                  : Text(
                    text,
                    style: TextStyle(
                      fontSize: 36,
                      color: text == 'AC' ? Colors.black : Colors.white,
                    ),
                  ),
        ),
      ),
    );
  }
}
