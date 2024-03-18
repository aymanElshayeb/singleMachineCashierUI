import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';


class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    String? url = await getPrinterUrl();
    if (url != null) {
      await Printing.directPrintPdf(
          printer: Printer(url: url), onLayout: ((format) async => pdf.save()));
    } else {
      await Printing.layoutPdf(onLayout: ((format) async => pdf.save()));
    }

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }
  static Future<void> printExternalInvoice(Uint8List pdfBytes) async{
        String? url = await getPrinterUrl();
    if (url != null) {
      await Printing.directPrintPdf(
          printer: Printer(url: url), onLayout: ((format) async => pdfBytes));
    } else {
      await Printing.layoutPdf(onLayout: ((format) async => pdfBytes));
    }
  }

  static Future openFile(File file) async {
    final url = file.path;
    await OpenFile.open(url);
  }

  static Future<String?> getPrinterUrl() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('printer_url');
  }

  Future<void> updatePrinterUrl(String newUrl) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('printer_url', newUrl);
  }
}
