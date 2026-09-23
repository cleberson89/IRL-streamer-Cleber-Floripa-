import 'dart:async';

/// Controlador de stream simplificado.
/// Nesta versão o streaming real será adicionado depois.
/// Por enquanto permite testar a interface e o build.
class StreamController {
  bool _isStreaming = false;

  bool get isStreaming => _isStreaming;

  Future<bool> start({
    required String rtmpUrl,
    required String streamKey,
  }) async {
    if (rtmpUrl.isEmpty) return false;
    
    // Simulação de conexão
    await Future.delayed(const Duration(seconds: 1));
    _isStreaming = true;
    return true;
  }

  Future<void> stop() async {
    _isStreaming = false;
  }

  void dispose() {
    _isStreaming = false;
  }
}
