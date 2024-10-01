import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StatusBox extends StatefulWidget {
  final String profileImageUrl;
  final String name;
  final DateTime dateTime;
  final String statusText;
  final int likeCount; // Total like count
  final List<StatusAction> actions;
  final String? dateFormatPattern;
  final DateFormat? dateFormatter;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const StatusBox({
    Key? key,
    required this.profileImageUrl,
    required this.name,
    required this.dateTime,
    required this.statusText,
    required this.likeCount,
    this.actions = const [],
    this.dateFormatPattern,
    this.dateFormatter,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);


  @override
  _StatusBoxState createState() => _StatusBoxState();
}

class _StatusBoxState extends State<StatusBox> {
  late List<IconData> _reactionIcons;
  final GlobalKey _optionsKey =
      GlobalKey(); // Key to access the position of the options icon

  @override
  void initState() {
    super.initState();
    _reactionIcons = [Icons.thumb_up_alt_outlined]; // Default like icon
  }

  void _showIconSelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: Row(
              mainAxisSize: MainAxisSize.min, // Ensure it takes minimum height
              children: [
                IconButton(
                  icon: Icon(Icons.thumb_up_alt_outlined),
                  onPressed: () =>
                      _addReactionIcon(Icons.thumb_up_alt_outlined),
                ),
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () => _addReactionIcon(Icons.favorite),
                ),
                IconButton(
                  icon: Icon(Icons.star),
                  onPressed: () => _addReactionIcon(Icons.star),
                ),
                IconButton(
                  icon: Icon(Icons.celebration),
                  onPressed: () => _addReactionIcon(Icons.celebration),
                ),
                IconButton(
                  icon: Icon(Icons.sentiment_very_satisfied),
                  onPressed: () =>
                      _addReactionIcon(Icons.sentiment_very_satisfied),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _addReactionIcon(IconData newIcon) {
    // Check if the icon already exists
    if (!_reactionIcons.contains(newIcon)) {
      setState(() {
        _reactionIcons
            .add(newIcon); // Add new icon to the list if it doesn't exist
      });
    }
    Navigator.of(context).pop(); // Close the dialog
  }

  void _showOptionsMenu() {
    final RenderBox renderBox =
        _optionsKey.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + renderBox.size.height, // Position just below the icon
        MediaQuery.of(context).size.width - offset.dx,
        0,
      ),
      items: [
        PopupMenuItem(
          child: Text('Edit'),
          value: 'edit',
        ),
        PopupMenuItem(
          child: Text('Delete'),
          value: 'delete',
        ),
      ],
    ).then((value) {
      if (value == 'edit' && widget.onEdit != null) {
        widget.onEdit!();
      } else if (value == 'delete' && widget.onDelete != null) {
        widget.onDelete!();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24.0,
                  backgroundImage: NetworkImage(widget.profileImageUrl),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0,
                            ),
                          ),
                          const SizedBox(width: 8.0),
                          GestureDetector(
                            key: _optionsKey, // Assign key to the icon
                            onTap: _showOptionsMenu, // Calls the updated method
                            child: const Icon(Icons.more_vert, size: 20.0),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        _formatDateTime(widget.dateTime),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              widget.statusText,
              style: const TextStyle(fontSize: 14.0),
            ),
            const SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onLongPress: _showIconSelectionDialog,
                  child: Row(
                    children: [
                      ..._reactionIcons.map((icon) => Padding(
                            padding: const EdgeInsets.only(right: 4.0),
                            child: Icon(icon, size: 20.0),
                          )),
                      const SizedBox(width: 4.0),
                      Text(
                        '${widget.likeCount}', // Display the count only
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14.0),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                ...widget.actions.map((action) => _buildIconButton(action)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(StatusAction action) {
    return InkWell(
      onTap: action.onTap,
      child: Row(
        children: [
          Icon(action.icon, size: 20.0, color: action.iconColor),
          const SizedBox(width: 4.0),
          Text(
            action.label,
            style: const TextStyle(color: Colors.grey, fontSize: 14.0),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    if (widget.dateFormatter != null) {
      return widget.dateFormatter!.format(dateTime);
    } else if (widget.dateFormatPattern != null) {
      return DateFormat(widget.dateFormatPattern).format(dateTime);
    } else {
      return DateFormat('dd/MM/yyyy, HH:mm').format(dateTime);
    }
  }
}

/// A class that defines an action button for the [StatusBox].
class StatusAction {
  StatusAction({
    required this.icon,
    required this.label,
    this.onTap,
    this.iconColor = Colors.grey,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color iconColor;
}
