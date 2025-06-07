part of '../pole_tile.dart';

class _RepairsListButton extends StatelessWidget {
  const _RepairsListButton({
    required this.pole,
    required this.repairsPrior,
    required this.repairsUncomplete,
    required this.searchQuery,
    required this.polesBloc,
  });

  final Pole pole;
  final Iterable<Repair> repairsPrior;
  final Iterable<Repair> repairsUncomplete;
  final String? searchQuery;
  final PolesBloc polesBloc;

  InlineSpan _highlightOccurrences(String source, String? query) {
    if (query == null || query.isEmpty) return TextSpan(text: source);

    final matches = <TextSpan>[];
    final lowerSource = source.toLowerCase();
    final lowerQuery = query.toLowerCase();

    int start = 0;
    int index;
    while ((index = lowerSource.indexOf(lowerQuery, start)) != -1) {
      if (index > start) {
        matches.add(TextSpan(text: source.substring(start, index)));
      }
      matches.add(
        TextSpan(
          text: source.substring(index, index + query.length),
          style: const TextStyle(
            backgroundColor: Colors.yellow,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
      start = index + query.length;
    }
    if (start < source.length) {
      matches.add(TextSpan(text: source.substring(start)));
    }
    return TextSpan(children: matches);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueGrey[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => BlocProvider(
                        create:
                            (_) => RepairListBlocBloc(
                              GetIt.I<AbstractPoleRepositories>(),
                            )..add(LoadRepairList(pole: pole)),
                        child: RepairListScreen(polesBloc: polesBloc),
                      ),
                ),
              );
            },
            child: const Text(
              "Открыть список ремонтов",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 16),
          if (repairsPrior.isEmpty && repairsUncomplete.isEmpty)
            Center(
              child: Text(
                "Ремонтов нет",
                style: theme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ),
          if (repairsPrior.isNotEmpty) ...[
            const SizedBox(height: 8),
            CustomBoxList(
              title: "Приоритет:",
              repairs:
                  repairsPrior
                      .map(
                        (e) =>
                            _highlightOccurrences(e.description, searchQuery),
                      )
                      .toList(),
              borderColor: const Color.fromARGB(255, 255, 0, 0),
              bgColor: const Color.fromARGB(40, 255, 0, 0),
            ),
          ],
          if (repairsUncomplete.isNotEmpty) ...[
            const SizedBox(height: 10),
            CustomBoxList(
              title: "Не завершенные:",
              repairs:
                  repairsUncomplete
                      .map(
                        (e) =>
                            _highlightOccurrences(e.description, searchQuery),
                      )
                      .toList(),
              borderColor: const Color.fromARGB(255, 0, 94, 255),
              bgColor: const Color.fromARGB(45, 0, 94, 255),
            ),
          ],
        ],
      ),
    );
  }
}
