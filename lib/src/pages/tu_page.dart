import 'package:flutter/material.dart';
import 'package:my_core_package/my_core_package.dart';

import '../models/tu_to_trasf.dart';
import '../widgets/tu_to_trasf_card.dart';
import '../services/get_tu_to_trasf_service.dart';
import '../services/post_tu_batch_service.dart';
import '../services/get_tu_check_service.dart';

class TUPage extends StatefulWidget {
  final String destinazione;

  const TUPage({super.key, required this.destinazione});

  @override
  State<TUPage> createState() => _TUPageState();
}

class _TUPageState extends State<TUPage> {
  final GetTuToTrasfService _service = GetTuToTrasfService();
  final ScrollController _scrollController = ScrollController();

  List<TuToTrasf> _rows = [];
  bool _isLoading = false;
  bool _isPosting = false;
  String _buttonLabel = "Conferma trasferimento";

  String get _cdMg {
    return widget.destinazione.toLowerCase() == "terranova" ? "0000T" : "00001";
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _conferma() async {
    if (_rows.isEmpty || _isPosting) return;

    setState(() {
      _isPosting = true;
      _buttonLabel = "Invio in corso...";
    });

    try {
      final svc = PostTuBatchService();
      final result = await svc.postTuBatch(righe: _rows);

      if (!mounted) return;

      final xTUTesta = result.xTUTesta;
      debugPrint("🔑 xTUTesta estratto: '$xTUTesta'");
      if (xTUTesta != null && xTUTesta.isNotEmpty) {
        setState(() => _buttonLabel = "Generazione TU in corso...");
        await _pollTuCheck(xTUTesta);
      } else {
        AppSnackBar.success(context, 'TU generato!');
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.error(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
          _buttonLabel = "Conferma trasferimento";
        });
      }
    }
  }

  Future<void> _pollTuCheck(String xTUTesta) async {
    final checkSvc = GetTuCheckService();
    final deadline = DateTime.now().add(const Duration(seconds: 30));

    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;

      try {
        final residui = await checkSvc.getTuCheck(xTuTesta: xTUTesta);
        debugPrint("🔄 TuCheck nResidui: $residui");

        if (residui == 0) {
          if (!mounted) return;
          AppSnackBar.success(context, 'TU generato!');
          Navigator.pop(context);
          return;
        }
      } catch (e) {
        debugPrint("⚠️ Errore TuCheck (ignoro): $e");
      }
    }

    // Timeout scaduto
    if (!mounted) return;
    AppSnackBar.warning(
      context,
      'Schedulatore fermo. Impossibile generare il TU. Contattare assistenza.',
    );
    Navigator.pop(context);
  }

  Future<void> _loadData({bool isRefresh = false}) async {
    if (!isRefresh) {
      setState(() => _isLoading = true);
    }

    try {
      final data = await _service.getTuToTrasfByMg(_cdMg);
      setState(() => _rows = data);
    } on ApiException catch (e) {
      if (!mounted) return;
      AppSnackBar.error(context, e.message);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.error(context, 'Errore imprevisto: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Uscita Materiale ${widget.destinazione}"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadData(isRefresh: true),
          child: CustomScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              if (_isLoading && _rows.isEmpty)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_rows.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Text(
                      "Nessun dato da visualizzare",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: _rows.length,
                  itemBuilder: (context, index) {
                    final r = _rows[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: TuToTrasfCard(
                        key: ValueKey(
                            '${r.cd_ar}-${r.cd_arlotto}-${r.quantita}'),
                        tuToTrasf: r,
                      ),
                    );
                  },
                ),

              const SliverToBoxAdapter(child: SizedBox(height: 90)),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: scheme.primary,
              foregroundColor: scheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: (_rows.isNotEmpty && !_isPosting) ? _conferma : null,
            child: _isPosting
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: scheme.onPrimary.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _buttonLabel,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  )
                : const Text(
                    "Conferma trasferimento",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }
}
