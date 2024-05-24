import 'dart:io';

import 'package:flutter/material.dart';

class ForyourPage extends StatefulWidget {
  const ForyourPage({super.key});

  @override
  State<ForyourPage> createState() => _ForyourPageState();
}

List<String> selectForyour = ["FYA", "FYE", "FYC", "FYI"];

class _ForyourPageState extends State<ForyourPage> {
  String current = selectForyour[3];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color.fromRGBO(147, 229, 241, 1),
      title: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black),
              color: const Color.fromRGBO(24, 167, 188, 1),
            ),
            child: const Icon(Icons.question_mark,color: Colors.white,),
          ),
          const Text(
            '  FOR YOUR',
            style: TextStyle(fontSize: 25),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .3,    
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12),color: Colors.white), 
        child: Column(
          children: [
            SizedBox(      
              height: 50,
              child: ListTile(
                title: const Text(
                  'Approval (FYA)',
                  style: TextStyle(fontFamily: 'pg', fontSize: 18),
                ),
                leading: Radio(
                  value: selectForyour[0],
                  groupValue: current, 
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if(states.contains(MaterialState.selected)){
                      return const Color.fromRGBO(24, 167, 188, 1);
                    }
                    return Colors.black;
                  }),                     
                  onChanged: (value) {
                    setState(() {
                      current = value.toString();
                    });
                  },
                ),
              ),
            ),
            SizedBox(    
              height: 50,
              child: ListTile(
                title: const Text(
                  'Execution (FYE)',
                  style: TextStyle(fontFamily: 'pg', fontSize: 18),
                ),
                leading: Radio(
                  value: selectForyour[1],
                  groupValue: current,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if(states.contains(MaterialState.selected)){
                      return const Color.fromRGBO(24, 167, 188, 1);
                    }
                    return Colors.black;
                  }), 
                  onChanged: (value) {
                    setState(() {
                      current = value.toString();
                    });
                  },
                ),
              ),
            ),
            SizedBox(    
              height: 50,
              child: ListTile(
                title: const Text(
                  'Comment (FYC)',
                  style: TextStyle(fontFamily: 'pg', fontSize: 18),
                ),
                leading: Radio(
                  value: selectForyour[2],
                  groupValue: current,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if(states.contains(MaterialState.selected)){
                      return const Color.fromRGBO(24, 167, 188, 1);
                    }
                    return Colors.black;
                  }), 
                  onChanged: (value) {
                    setState(() {
                      current = value.toString();
                    });
                  },
                ),
              ),
            ),
            SizedBox(     
              height: 50,
              child: ListTile(
                title: const Text(
                  'Information (FYI)',
                  style: TextStyle(fontFamily: 'pg', fontSize: 18),
                ),
                leading: Radio(
                  value: selectForyour[3],
                  groupValue: current,
                  fillColor: MaterialStateProperty.resolveWith((states) {
                    if(states.contains(MaterialState.selected)){
                      return const Color.fromRGBO(24, 167, 188, 1);
                    }
                    return Colors.black;
                  }), 
                  onChanged: (value) {
                    setState(() {
                      current = value.toString();
                    });
                  },
                ),
              ),
            )
          ],
        ),
      ),
      actions: [        
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: const Color.fromRGBO(24, 167, 188, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.only(left: 10)),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: const Color.fromRGBO(24, 167, 188, 1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
