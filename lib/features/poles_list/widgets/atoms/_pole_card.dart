part of '../pole_tile.dart';

class _PoleCard extends StatelessWidget {
  const _PoleCard({
    required this.pole,
    required this.bloc,
    required this.searchQuery,
  });

  final Pole pole;
  final PolesBloc bloc;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    final repairs = pole.repairs;
    final repairsPrior = repairs.where((r) => r.urgent && !r.completed);
    final repairsUncomplete = repairs.where((r) => !r.completed && !r.urgent);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const RadialGradient(
          colors: [Colors.white, Color(0xFFFAFAFA)],
        ),
        border: Border.all(color: Colors.black12, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PoleHeader(pole: pole),
                    const SizedBox(height: 8),
                    _PoleStatusIndicators(pole: pole),
                    const SizedBox(height: 8),
                    _PoleCheckInfo(pole: pole),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: _PoleImage(pole: pole),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _RepairsListButton(
            polesBloc: bloc,
            pole: pole,
            repairsPrior: repairsPrior,
            repairsUncomplete: repairsUncomplete,
            searchQuery: searchQuery,
          ),
        ],
      ),
    );
  }
}
