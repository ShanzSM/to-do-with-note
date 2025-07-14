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
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Responsive sizing based on device width
            final double deviceWidth = MediaQuery.of(context).size.width;
            final double deviceHeight = MediaQuery.of(context).size.height;
            final double cardPadding = deviceWidth * 0.04; // Responsive padding
            final double titleFontSize =
                deviceWidth * 0.045; // Responsive title font size
            final double contentFontSize =
                deviceWidth * 0.024; // Responsive content font size
            final double iconSize = deviceWidth * 0.06;

            return Card(
              color: const Color(0xFF2A2A2A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(deviceWidth * 0.06),
              ),
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: () => widget.editNote(),
                          icon: Icon(
                            Icons.edit_outlined,
                            color: Colors.white54,
                            size: iconSize,
                          ),
                          padding: EdgeInsets.only(
                            right: deviceWidth * 0.01,
                            left: deviceWidth * 0.02,
                          ),
                          constraints: const BoxConstraints(),
                        ),
                        IconButton(
                          onPressed: () => widget.removeNote(),
                          icon: Icon(
                            Icons.delete_outline,
                            color: Colors.white54,
                            size: iconSize,
                          ),
                          padding: EdgeInsets.only(
                            right: deviceWidth * 0.01,
                            left: deviceWidth * 0.01,
                          ),
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(deviceWidth * 0.02),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.noteTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: titleFontSize,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: deviceHeight * 0.012),
                    Text(
                      widget.noteContent,
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: contentFontSize,
                      ),
                      maxLines: 6,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
