part of '../pole_tile.dart';

class _PoleImage extends StatelessWidget {
  const _PoleImage({required this.pole});

  final Pole pole;

  @override
  Widget build(BuildContext context) {
    final imagePath =
        imgPoleSrc
            .firstWhere(
              (e) => e.number == pole.number,
              orElse:
                  () => PoleImage(
                    number: 'unknown',
                    assetPath: 'assets/poles/pole.png',
                  ),
            )
            .assetPath;

    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Image.asset(
            imagePath,
            height: MediaQuery.of(context).size.height * 0.2,
            fit: BoxFit.cover,
            errorBuilder:
                (context, error, stackTrace) => Container(
                  color: Colors.grey.shade300,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.height * 0.2,
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 40,
                    color: Colors.black38,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
