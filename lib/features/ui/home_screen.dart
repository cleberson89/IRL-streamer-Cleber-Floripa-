import 'package:flutter/material.dart';
import '../stream/stream_controller.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamController _stream = StreamController();
  bool _isLive = false;
  String _status = 'Pronto';
  String _rtmpUrl = 'rtmp://live.twitch.tv/app';
  String _streamKey = '';

  @override
  void dispose() {
    _stream.dispose();
    super.dispose();
  }

  Future<void> _toggleLive() async {
    if (_isLive) {
      await _stream.stop();
      setState(() {
        _isLive = false;
        _status = 'Parado';
      });
    } else {
      setState(() => _status = 'Conectando...');
      final ok = await _stream.start(
        rtmpUrl: _rtmpUrl,
        streamKey: _streamKey,
      );
      setState(() {
        _isLive = ok;
        _status = ok ? 'AO VIVO' : 'Erro ao conectar';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isLive ? Colors.red : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _isLive ? '● AO VIVO' : '○ OFFLINE',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings, color: Colors.white70),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SettingsScreen(
                            rtmpUrl: _rtmpUrl,
                            streamKey: _streamKey,
                          ),
                        ),
                      );
                      if (result != null) {
                        setState(() {
                          _rtmpUrl = result['url'] ?? _rtmpUrl;
                          _streamKey = result['key'] ?? _streamKey;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white12),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.videocam,
                        size: 64,
                        color: _isLive ? Colors.redAccent : Colors.white24,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _status,
                        style: TextStyle(
                          color: _isLive ? Colors.redAccent : Colors.white54,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _rtmpUrl.isEmpty ? 'Configure a URL nas configurações' : _rtmpUrl,
                        style: const TextStyle(color: Colors.white38, fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _roundButton(Icons.cameraswitch, 'Câmera', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Troca de câmera (em desenvolvimento)')),
                    );
                  }),
                  GestureDetector(
                    onTap: _toggleLive,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isLive ? Colors.grey.shade800 : Colors.redAccent,
                        border: Border.all(color: Colors.white24, width: 3),
                      ),
                      child: Icon(
                        _isLive ? Icons.stop : Icons.fiber_manual_record,
                        color: Colors.white,
                        size: 36,
                      ),
                    ),
                  ),
                  _roundButton(Icons.link, 'URL', () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Overlays interativos (em desenvolvimento)')),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roundButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white10,
            ),
            child: Icon(icon, color: Colors.white70),
          ),
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 12)),
      ],
    );
  }
}
