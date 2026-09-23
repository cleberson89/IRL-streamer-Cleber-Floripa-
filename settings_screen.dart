import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final String rtmpUrl;
  final String streamKey;

  const SettingsScreen({
    super.key,
    required this.rtmpUrl,
    required this.streamKey,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _urlController;
  late TextEditingController _keyController;
  String _protocol = 'rtmp';

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.rtmpUrl);
    _keyController = TextEditingController(text: widget.streamKey);
    _protocol = widget.rtmpUrl.toLowerCase().startsWith('srt') ? 'srt' : 'rtmp';
  }

  @override
  void dispose() {
    _urlController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        title: const Text('Configurações'),
        backgroundColor: Colors.transparent,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, {
                'url': _urlController.text.trim(),
                'key': _keyController.text.trim(),
              });
            },
            child: const Text('Salvar', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Protocolo', style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'srt', label: Text('SRT')),
              ButtonSegment(value: 'rtmp', label: Text('RTMP')),
            ],
            selected: {_protocol},
            onSelectionChanged: (s) {
              setState(() {
                _protocol = s.first;
                if (_protocol == 'srt' && !_urlController.text.startsWith('srt')) {
                  _urlController.text = 'srt://';
                } else if (_protocol == 'rtmp' && !_urlController.text.startsWith('rtmp')) {
                  _urlController.text = 'rtmp://live.twitch.tv/app';
                }
              });
            },
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _urlController,
            decoration: InputDecoration(
              labelText: _protocol == 'srt' ? 'URL SRT' : 'URL RTMP',
              hintText: _protocol == 'srt'
                  ? 'srt://servidor:port?streamid=...'
                  : 'rtmp://live.twitch.tv/app',
              border: const OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _keyController,
            decoration: const InputDecoration(
              labelText: 'Stream Key',
              border: OutlineInputBorder(),
            ),
            style: const TextStyle(color: Colors.white),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _protocol == 'srt'
                  ? 'SRT é mais estável para IRL (rede ruim).\nEx: srt://seu-servidor:9000?streamid=#!::r=live,m=publish'
                  : 'RTMP é mais simples.\nTwitch: rtmp://live.twitch.tv/app\nYouTube: rtmp://a.rtmp.youtube.com/live2',
              style: const TextStyle(color: Colors.white70, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
