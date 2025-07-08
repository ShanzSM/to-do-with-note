import 'package:flutter/material.dart';

class NoteCategoryCard extends StatefulWidget {
  final String noteTitle;
  final String noteContent;
  final Future Function() removeNote;
  final Future Function() editNote;
  const NoteCategoryCard({
    super.key,
    required this.noteTitle,
    required this.noteContent,
    required this.removeNote,
    required this.editNote,
  });

  @override
  State<NoteCategoryCard> createState() => _NoteCategoryCardState();
}

class _NoteCategoryCardState extends State<NoteCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        splashColor: Colors.white24,
        highlightColor: Colors.white10,
        onTap: () => widget.editNote(),
        child: Card(
          color: Color(0xFF2A2A2A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () => widget.editNote(),
                      icon: Icon(Icons.edit_outlined, color: Colors.white54),
                      padding: EdgeInsets.only(right: 2, left: 8),
                      constraints: BoxConstraints(),
                    ),
                    IconButton(
                      onPressed: () => widget.removeNote(),
                      icon: Icon(Icons.delete_outline, color: Colors.white54),
                      padding: EdgeInsets.only(right: 2, left: 2),
                      constraints: BoxConstraints(),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.noteTitle,
                          style: TextStyle(color: Colors.white, fontSize: 18),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  widget.noteContent,
                  style: TextStyle(color: Colors.white54, fontSize: 16),
                  maxLines: 6,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
