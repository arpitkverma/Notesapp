import 'package:flutter/material.dart';
import 'package:notesapp/screens/notes_list_screen.dart';
import 'package:notesapp/utils/validators.dart';
import 'package:provider/provider.dart';

import '../providers/authentication_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.isSignUp = false});

  final bool isSignUp;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _cPwdCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPwd = false;
  bool _showCnfPwd = false;
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _pwdCtrl.dispose();
    _cPwdCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!mounted) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final auth = context.read<AuthenticationProvider>();
    final err = widget.isSignUp
        ? await auth.register(_emailCtrl.text.trim(), _pwdCtrl.text.trim())
        : await auth.login(_emailCtrl.text.trim(), _pwdCtrl.text.trim());
    if (!mounted) return;
    if (err == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const NotesListScreen()),
      );
    } else {
      setState(() {
        _error = err;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 100),
                  Icon(
                    Icons.event_note_sharp,
                    size: 120,
                    color: Colors.deepPurple,
                  ),
            
                  Text(
                    widget.isSignUp ? 'Sign Up' : 'Sign In',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 50),
            
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      return Validators.validateEmail(value);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pwdCtrl,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _showPwd = !_showPwd),
                        icon: Icon(
                          _showPwd
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                    obscureText: _showPwd,
            
                    validator: (value) {
                      return Validators.validatePassword(value);
                    },
                  ),
                  if (widget.isSignUp) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cPwdCtrl,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        suffixIcon: IconButton(
                          onPressed: () => setState(() => _showCnfPwd = !_showCnfPwd),
                          icon: Icon(
                            _showCnfPwd
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        return Validators.validateConfirmPassword(
                          value,
                          _pwdCtrl.text,
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _submit,
                      child: _loading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              widget.isSignUp ? 'Register' : 'Login',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(isSignUp: !widget.isSignUp),
                        ),
                      );
                    },
                    child: Text(
                      widget.isSignUp
                          ? "Already have an account? Sign in"
                          : "Don't have an account? Sign up",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
