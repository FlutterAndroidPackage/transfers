import 'package:flutter/material.dart';
import 'package:my_core_package/my_core_package.dart';

import '../models/te_item.dart';
import '../widgets/te_item_card.dart';
import '../services/get_te_service.dart';
import '../services/post_te_genera_service.dart';
import '../services/get_te_check_service.dart';

class TEPage extends StatefulWidget {
  final String destinazione;
  final Future<String> Function() getAccessToken;
  final String Function() getBaseUrl;
  final void Function()? onUnauthorized;
  final Future<bool> Function()? tryRefreshToken;

  const TEPage({
    super.key,
    required this.destinazione,
    required this.getAccessToken,
    required this.getBaseUrl,
    this.onUnauthorized,
    this.tryRefreshToken,
  });

  @override
  State<TEPage> createState() => _TEPageState();
}

class _TEPageState extends State<TEPage> {
  late final GetTeService _service;
  late final PostTeGeneraService _postService;
  late final GetTeCheckService _checkService;
  final ScrollController _scrollController = ScrollController();

  List<TeItem> _rows = [];
  bool _isLoading = false;
  bool _isPosting = false;
  String _buttonLabel = "Conferma rientro";

  String get _cdMg {
    return widget.destinazione.toLowerCase() == "terranova" ? "00001" : "0000T";
  }

  @override
  void initState() {
    super.initState();
    final client = CoreHttpClient(
      getAccessToken: widget.getAccessToken,
      getBaseUrl: widget.getBaseUrl,
      onUnauthorized: widget.onUnauthorized,
      tryRefreshToken: widget.tryRefreshToken,
    );
    _service = GetTeService(client);
    _postService = PostTeGeneraService(client);
    _checkService = GetTeCheckService(client);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadData({bool isRefresh = false}) async {
    if (!isRefresh) {
      setState(() => _isLoading = true);
    }

    try {
      final data = await _service.getTE(_cdMg);
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

  Future<void> _conferma() async {
    if (_rows.isEmpty || _isPosting) return;

    setState(() {
      _isPosting = true;
      _buttonLabel = "Invio in corso...";
    });

    final total = _rows.length;

    try {
      for (int i = 0; i < total; i++) {
        final item = _rows[i];
        if (!mounted) return;

        // POST teGenera per questo documento
        setState(() => _buttonLabel = "Generazione TE in corso...");
        final idLog = await _postService.postTeGenera(
          cdMg: _cdMg,
          idDotes: item.idDotes,
        );

        if (!mounted) return;

        // Polling TEcheck per questo documento
        setState(() => _buttonLabel = "Generazione TE in corso...");
        final ok = await _pollTeCheck(idLog);

        if (!mounted) return;

        if (!ok) {
          AppSnackBar.warning(
            context,
            'Schedulatore fermo. Impossibile generare il TE. Contattare assistenza.',
          );
          Navigator.pop(context);
          return;
        }
      }

      if (!mounted) return;
      AppSnackBar.success(context, 'TE generato!');
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      AppSnackBar.error(context, e.toString());
    } finally {
      if (mounted) {
        setState(() {
          _isPosting = false;
          _buttonLabel = "Conferma rientro";
        });
      }
    }
  }

  /// Polling su TEcheck ogni 500ms per max 30s.
  /// Ritorna true se generat == 0 (elaborazione completata), false se timeout.
  Future<bool> _pollTeCheck(int idLog) async {
    final deadline = DateTime.now().add(const Duration(seconds: 30));

    while (DateTime.now().isBefore(deadline)) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return false;

      try {
        final generat = await _checkService.getTeCheck(idXlogEvadiDocument: idLog);
        debugPrint("🔄 TEcheck generat: $generat (id=$idLog)");
        if (generat == 0) return true;
      } catch (e) {
        debugPrint("⚠️ Errore TEcheck (ignoro): $e");
      }
    }

    return false; // timeout
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text("Rientro Materiale ${widget.destinazione}"),
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
                      "Nessun rientro da confermare",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                SliverList.builder(
                  itemCount: _rows.length,
                  itemBuilder: (context, index) {
                    final item = _rows[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: TeItemCard(
                        key: ValueKey(item.idDotes),
                        item: item,
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
                    "Conferma rientro",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
          ),
        ),
      ),
    );
  }
}
