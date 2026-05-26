import 'package:flutter/material.dart';

class ImagoProfili extends StatelessWidget {
  const ImagoProfili({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(20),
            // TODO: Colocar cor do figma
            border: Border.all(color: Colors.orange, width: 3),
            /*
            TODO: Colocar imagem
            image: DecorationImage(
              image: NetworkImage(),
              fit: BoxFit.cover,
            ),
            */
          ),
          child: const Icon(Icons.account_box, size:50, color: Colors.orange,)
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () {
              // TODO: Adicionar função para selecionar imagem
            },
            child: Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}