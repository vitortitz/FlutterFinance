// ignore_for_file: prefer_const_constructors

import 'package:confetti/confetti.dart';
import 'package:firebase/models/user_transaction.dart';
import 'package:firebase/screens/new_transaction/components/money_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final UserTransaction newTransaction;

  const NewTransaction({Key? key, required this.newTransaction})
      : super(key: key);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  int _currentStep = 0;
  DateTime? date, daterange;
  final description = TextEditingController();
  final confettiController = ConfettiController(duration: Duration(seconds: 2));
  String getDateAsText() {
    if (date == null) {
      return 'Selecione uma Data';
    } else {
      return DateFormat('dd/MM/yyyy').format(date!);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        SizedBox(
            height: size.height,
            width: double.infinity,
            child: stepMenu(context)),
      ],
    )));
  }

  List<Step> getSteps() => [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 0,
          title: Text('Categoria'),
          content: dropDownMenu(context),
        ),
        Step(
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 1,
            title: Text('Descrição'),
            content: Column(
              children: [
                TextFormField(
                  controller: description,
                  decoration: InputDecoration(labelText: 'Descrição'),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)))),
                    onPressed: () => pickDate(context),
                    child: Text(getDateAsText()))
              ],
            )),
        Step(
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            isActive: _currentStep >= 2,
            title: Text('Valor'),
            content: MoneyScreen(
              newTransaction: widget.newTransaction,
            )),
      ];

  Widget stepMenu(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Stepper(
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: _currentStep,
          onStepContinue: () {
            confettiController.play();
            widget.newTransaction.date = date;
            widget.newTransaction.description = description.text;
            widget.newTransaction.category = selectedItem;
            FocusManager.instance.primaryFocus?.unfocus();
            final isLastStep = _currentStep == getSteps().length - 1;
            if (isLastStep) {
            } else if (_currentStep == 1) {
              if (date != null || description.text != '') {
                setState(() {
                  _currentStep += 1;
                });
              }
            } else if (_currentStep == 0) {
              if (selectedItem != null) {
                setState(() {
                  _currentStep += 1;
                });
              }
            } else {
              setState(() {
                _currentStep += 1;
              });
            }
          },
          onStepTapped: (step) => setState(() {
                if (step < _currentStep) {
                  _currentStep = step;
                }
                if (_currentStep == 0 && selectedItem != null) {
                  _currentStep = step;
                } else if ((date != null) && (description.text != "")) {
                  _currentStep = step;
                }
              }),
          onStepCancel: _currentStep == 0
              ? null
              : () => setState(
                    (() => _currentStep -= 1),
                  ),
          controlsBuilder: (context, ControlsDetails controls) {
            final isLastStep = _currentStep == getSteps().length - 1;
            return Container(
              margin: EdgeInsets.only(top: 10),
              child: Column(children: [
                if (isLastStep)
                  Text('Favor conferir o caixa para poder confirmar!!!',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.red)),
                Row(
                  children: [
                    if (_currentStep != 0)
                      Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)))),
                              onPressed: controls.onStepCancel,
                              child: Text('Voltar'))),
                    SizedBox(width: 12),
                    if (!isLastStep)
                      Expanded(
                          child: ElevatedButton(
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)))),
                              onPressed: controls.onStepContinue,
                              child: Text('Próximo'))),
                  ],
                ),
              ]),
            );
          }),
    );
  }

  pickDate(BuildContext context) async {
    final today = DateTime.now();
    final _transactionDate = await showDatePicker(
      context: context,
      initialDate: date ?? today,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 5),
    );

    if (_transactionDate == null) return;

    setState(() => date = _transactionDate);
  }

  List<String> itemsIncome = [
    'Presente',
    'Mesada',
    'Salário',
  ];
  List<String> itemsWaste = ['Brinquedo', 'Jogos', 'Comida'];

  List typeList() {
    if (widget.newTransaction.type == 'Gasto') {
      return itemsWaste;
    } else {
      return itemsIncome;
    }
  }

  String? selectedItem;
  Widget dropDownMenu(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 240,
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(width: 3, color: Colors.blue)),
          ),
          value: selectedItem,
          items: typeList()
              .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Center(
                    child: Text(
                      item,
                      style: TextStyle(fontSize: 20),
                    ),
                  )))
              .toList(),
          onChanged: (item) => setState(() => selectedItem = item),
        ),
      ),
    );
  }
}
