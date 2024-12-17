import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:songer/providers/song_provider.dart';

class VolumeIcon extends StatefulWidget {
  VolumeIcon({this.size = 30,this.color = Colors.white, super.key});

  int size;
  Color color;
  @override
  State<VolumeIcon> createState() => _VolumeIconState();
}

class _VolumeIconState extends State<VolumeIcon> {
  IconData volumeIcon(int volume) {
    if (volume > 60) return Icons.volume_up_rounded;
    if (volume > 30) return Icons.volume_down_rounded;
    return Icons.volume_mute_rounded;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VolumeProvider>(builder: (
      context,
      VolumeProvider volumeProvider,
      child,
    ) {
      int volume = (volumeProvider.value * 100).toInt();
      return InkWell(
        onTap: (){
          volumeProvider.update(volume == 0 ? 0.1 : 0);
        },
        child: Icon(
          volumeIcon(volume),
          size: widget.size.toDouble(),
          color: widget.color,
        ),
      );
    });
  }
}
