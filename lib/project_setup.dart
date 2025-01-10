import 'package:flutter/material.dart';

class LastLoadScreen extends StatelessWidget {
  const LastLoadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// For responsiveness, let’s check current screen width.
    final width = MediaQuery.of(context).size.width;
    final bool isSmallScreen = width < 800; // You can adjust this breakpoint.

    return Scaffold(
      body: SafeArea(
        child: isSmallScreen
            ? _buildSingleColumn(context)
            : _buildTwoColumns(context),
      ),
    );
  }

  /// Single-column layout for small screens (e.g., phones)
  Widget _buildSingleColumn(BuildContext context) {
    return Column(
      children: [
        /// Main content (the circle icon, finishing up text, status text, button)
        Expanded(
          child: _buildMainContent(context, isCenterAligned: true),
        ),

        /// Right-side illustration area (the vertical black panel with the 3D character)
        Container(
          height: 300,
          color: Colors.black87,
          width: double.infinity,
          child: _buildIllustration(context),
        ),
      ],
    );
  }

  /// Two-column layout for larger screens
  Widget _buildTwoColumns(BuildContext context) {
    return Row(
      children: [
        /// Left side: main content
        Expanded(
          flex: 3,
          child: _buildMainContent(context),
        ),

        /// Right side: black panel with illustration
        Container(
          width: 300,
          color: Colors.black87,
          child: _buildIllustration(context),
        ),
      ],
    );
  }

  /// The main content: large icon, text, button
  Widget _buildMainContent(BuildContext context,
      {bool isCenterAligned = false}) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Simulated “circular loading” icon
            // In a real app, you might use a custom loading widget or image
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.orange,
              ),
              child: Center(
                child: Icon(
                  Icons.timelapse, // Example icon
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),

            /// “Finishing up...” text
            const Text(
              'Finishing up...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            /// Sub-text (e.g. "adsf")
            const SizedBox(height: 4),
            const Text(
              'adsf', // Just an example, replace with your own text
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 32),

            /// Status: “Your Firebase project is ready”
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text(
                  'Your Firebase project is ready',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// “Continue” button
            ElevatedButton(
              onPressed: () {
                // TODO: Insert your logic here (navigation, etc.)
              },
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  /// The black right panel with the 3D character or placeholder
  Widget _buildIllustration(BuildContext context) {
    // Placeholder for the figure on the right:
    // In a real app, you'd use an Image.asset or Image.network for the 3D character.
    // The shapes behind her can also be an image or a custom painter.

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Example 3D character placeholder
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '3D Character Here',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
