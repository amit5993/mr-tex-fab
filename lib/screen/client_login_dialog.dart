import 'package:flutter/material.dart';
import '../utils/color.dart';
import '../utils/widget.dart';
import '../model/app_initial_response.dart';

class ClientLoginDialog extends StatefulWidget {
  final ExtraClient client;
  final Function(String token) onLoginSuccess;

  const ClientLoginDialog({
    Key? key,
    required this.client,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  _ClientLoginDialogState createState() => _ClientLoginDialogState();
}

class _ClientLoginDialogState extends State<ClientLoginDialog> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5.0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Login to ${widget.client.clientName}',
              style: heading2(colorBlack),
              textAlign: TextAlign.center,
            ),
            verticalViewBig(),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            verticalView(),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            verticalView(),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: colorRed),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: bodyText2(colorText)),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorApp,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: _isLoading ? null : _handleLogin,
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: colorWhite,
                            strokeWidth: 2,
                          ),
                        )
                      : Text('Login', style: bodyText2(colorWhite)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogin() async {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() {
        _errorMessage = 'Please enter username and password';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Here you would typically call your login API
      // For now, we'll simulate a successful login after a delay
      await Future.delayed(const Duration(seconds: 1));
      
      // Assuming login was successful, pass back a token
      // In a real implementation, you would get this token from your API response
      widget.onLoginSuccess('sample_token_for_${widget.client.clientId}');
      
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}