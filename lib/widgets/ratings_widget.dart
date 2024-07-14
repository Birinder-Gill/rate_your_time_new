import 'package:flutter/material.dart';

class RatingStars extends StatefulWidget {
  final double size;
  final int total;
  final double rating;
  final bool readOnly;

  const RatingStars(
      {Key? key,
      this.size = 50,
      this.total = 5,
      this.rating = 0,
      this.readOnly = true})
      : super(key: key);

  @override
  _RatingStarsState createState() => _RatingStarsState();
}

class _RatingStarsState extends State<RatingStars> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < widget.total; i++)
          _SingleRatingStar(
              size: widget.size,
              readOnly: widget.readOnly,
              rating: widget.rating - i)
      ],
    );
  }
}

class _SingleRatingStar extends StatelessWidget {
  final double size;
  final double rating;
  final bool readOnly;

  const _SingleRatingStar({Key? key, required this.size, this.rating = 0, this.readOnly = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      rating <= 0
          ? Icons.star_border
          : rating < 1
              ? Icons.star_half
              : Icons.star_rate,
      color: Theme.of(context).colorScheme.secondary,
      size: size,
    );
  }
}
