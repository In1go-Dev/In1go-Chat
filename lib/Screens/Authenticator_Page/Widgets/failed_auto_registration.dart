import 'package:flutter/material.dart';

class FailedAutoRegistrationStep extends StatefulWidget {
  const FailedAutoRegistrationStep({super.key, required this.errorMessage, required this.changeState});

  final String errorMessage;
  final VoidCallback changeState;

  @override
  State<FailedAutoRegistrationStep> createState() => _FailedAutoRegistrationStepState();
}

class _FailedAutoRegistrationStepState extends State<FailedAutoRegistrationStep> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Align(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(bottom: 50),
              child: Card(
                //color: Colors.red[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 25, bottom: 40, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Container(
                        padding: const EdgeInsets.only(bottom: 10, left: 0),
                        child: const Icon(
                          Icons.error,
                          fill: 0,
                          color: Colors.red,
                          size: 50
                        )
                      ),

                      const Padding(
                        padding: EdgeInsets.only(bottom: 5),
                        child: Text('Oops!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))
                      ),
                      
                      const Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(
                          'Request Failed',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500
                          )
                        )
                      ),
                      
                      networkConnectionError()

                    ]
                  )
                )
              )
            )
          ),
          
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(bottom: 5),
              width: double.infinity,
              child: (Theme.of(context).useMaterial3) ?
              FilledButton(
                onPressed: widget.changeState,
                child: const Text('Login')
              ) : 
              ElevatedButton(
                onPressed: widget.changeState,
                child: const Text('Login')
              )
            )
          )
        ]
      )
    );
  }

  //Widget Displays for Exception Messages according to the error message parameters

  Widget networkConnectionError() {
    switch (widget.errorMessage) {
      case "Invalid Account Information":
        return Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 5),
              child: const Text(
                "Your account information is invalid. Please make sure it satisfies the following verification requirements",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15)
              )
            ),
            
            const Text(
               "\n - Email Address doesn't start in special characters and has a domain"
               "\n - Names don't start in special characters",
              textAlign: TextAlign.center,
            )
          ]
        );
      case "Incomplete Account Information":
        return const Text(
          'Your account information is incomplete. Please ensure you provided your email address as well as your full name...',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15)
        );
      default:
        return Text(
          widget.errorMessage,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 15)
        );
    }
  }
}