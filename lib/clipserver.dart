import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';

import 'package:flutter/services.dart';


class ClipServer extends StatefulWidget {
  @override
  _ClipServerState createState() => _ClipServerState();
}


class _ClipServerState extends State<ClipServer> {

  TextEditingController textEditingController = new TextEditingController();


  String statusText = "";
  String buttonText = "Start Server";

  final info = NetworkInfo();

  startServer() async {
    String portString = textEditingController.text;

    int port = portString.isEmpty ? 3000 : int.parse(portString);
    textEditingController.text = port.toString();

    var server = await HttpServer.bind(InternetAddress.anyIPv4, port);

    ClipboardData? data = await Clipboard.getData('text/plain');
    var wifiIP = await info.getWifiIP();
    var clipData = data?.text.toString();

    var htmlData = getHtmlTemplate(clipData!);
    
    setState(() {
      statusText = "Server running on IP : "+ wifiIP.toString() +":"+server.port.toString();
      buttonText = "Server running";
    });

    await for (var request in server) {
      request.response
        ..headers.contentType = ContentType("text", "html", charset: "utf-8")
        ..write(htmlData)
        ..close();
    }

  }


  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Padding(padding: EdgeInsets.only(top: 20)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                Text("Port: "),
                Flexible(
                  child: SizedBox(
                    width: 100,
                    child: TextField(
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                                          FilteringTextInputFormatter.digitsOnly
                                        ]
                    ),
                  ),
                ),

                    
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff33691E)
                  ),
                  onPressed: (){
                    startServer();
                  },
                  child: Text(buttonText),
                ),
              ],
            ),

            Padding(padding: EdgeInsets.only(top: 20)),

            Text(statusText)
          ],
        ),
      );
  }


  String getHtmlTemplate(String clipboardData){

    String htmlContent = """
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">

    <title>Clipboard Server</title>

    <link rel="canonical" href="https://getbootstrap.com/docs/4.1/examples/sticky-footer/">
    <!-- Custom styles for this template -->
    <link href="https://getbootstrap.com/docs/4.1/examples/sticky-footer/sticky-footer.css" rel="stylesheet">
  </head>

  <body>

    <!-- Begin page content -->
    <main role="main" class="container">
      <h1 class="mt-5">Your clipboard data</h1>
      <br>
      <p class="lead">${clipboardData}</p>
    
    </main>

    <footer class="footer">
      <div class="container">
        <span class="text-muted"><a href="https://play.google.com/store/apps/dev?id=7070697855061278897">PlayStore</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <span class="text-muted"><a href="https://youtube.com/c/stackbuffer">YouTube</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <span class="text-muted"><a href="https://github.com/stackbuffer">GitHub</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <span class="text-muted"><a href="https://reddit.com/u/stackbuffer">Reddit</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
        <span class="text-muted"><a href="https://instagram.com/stackbuffer">Instagram</a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</span>
      </div>
    </footer>
  </body>
</html>
""";

    return htmlContent;
  }
}