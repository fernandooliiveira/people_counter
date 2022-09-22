import 'dart:convert';

import 'package:counter/ui/home_page.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:freerasp/talsec_app.dart';
import 'package:freerasp/utils/hash_converter.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();

    var bytes = utf8.encode("******");
    var hash256 = sha256.convert(bytes);
    String base64Hash = hashConverter
        .fromSha256toBase64(hash256.toString());

    TalsecConfig config = TalsecConfig(
      // For Android
      androidConfig: AndroidConfig(
        expectedPackageName: 'br.com.app.fernando.counter',
        expectedSigningCertificateHash: base64Hash,
        supportedAlternativeStores: ["com.sec.android.app.samsungapps"],
      ),
      // Common email for Alerts and Reports
      watcherMail: 'fernandoliveira909@gmail.com',
    );

    TalsecCallback callback = TalsecCallback(
      // For Android
      androidCallback: AndroidCallback(
        onRootDetected: () => print('root'),
        onEmulatorDetected: () => print('emulator'),
        onHookDetected: () => print('hook'),
        onTamperDetected: () => print('tamper'),
        onDeviceBindingDetected: () => print('device binding'),
        onUntrustedInstallationDetected: () => print('untrusted install'),
      ),
      // For iOS
      iosCallback: IOSCallback(
        onSignatureDetected: () => print('signature'),
        onRuntimeManipulationDetected: () => print('runtime manipulation'),
        onJailbreakDetected: () => print('jailbreak'),
        onPasscodeDetected: () => print('passcode'),
        onSimulatorDetected: () => print('simulator'),
        onMissingSecureEnclaveDetected: () => print('secure enclave'),
        onDeviceChangeDetected: () => print('device change'),
        onDeviceIdDetected: () => print('device ID'),
        onUnofficialStoreDetected: () => print('unofficial store'),
      ),
      onDebuggerDetected: () => print('debugger'),
    );

    TalsecApp app = TalsecApp(
      config: config,
      callback: callback,
    );
    app.start();
  }


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
