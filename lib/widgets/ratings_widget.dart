import 'package:flutter/material.dart';

class RatingStars extends StatefulWidget {
  final double size;

  const RatingStars({Key key, this.size}) : super(key: key);

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  final color = Colors.orange;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rate,color: color,size: widget.size,),
        Icon(Icons.star_rate,color: color,size: widget.size,),
        Icon(Icons.star_half,color: color,size: widget.size,),
        Icon(Icons.star_border,color: color,size: widget.size,),
        Icon(Icons.star_border,color: color,size: widget.size,),
      ],
    );
  }
}
