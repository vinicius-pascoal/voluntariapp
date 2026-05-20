import 'package:flutter/material.dart';
import 'scripturam_arca.dart';

class DiesNativitates extends StatelessWidget{
  const DiesNativitates({
    super.key,

  });
  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Data de Nascimento",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Row(
          children: [
            Expanded(child: 
              ScripturamArca(content: '20',),
            ),
            SizedBox(width: 8,),
            Expanded(child: 
              ScripturamArca(content: '06',),
            ),
            SizedBox(width: 8,),
            Expanded(child: 
              ScripturamArca(content: '26',),
            ),
          ],
        ),
      ]
    );
  }
}