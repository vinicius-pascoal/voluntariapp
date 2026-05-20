import 'package:flutter/material.dart';

class ScripturamArca extends StatelessWidget{
  const ScripturamArca({
    super.key,
    this.label,
    this.placeholder = "Escreva aqui.",
    this.content,
    this.height = 24
  });


  final String? label;
  final String? placeholder;
  final String? content;
  final int? height;

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if(label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
        SizedBox(height: 6),
        Container(decoration: 
          BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          height: 80,
          child: TextFormField(
            expands: true,
            maxLines: null,
            minLines: null,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 24, horizontal: 12),
              hintText: content,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Color(0xFFD9D9D9)),
              ),
            ),
          ),
        ),
        
      ],
    );
  }
}
