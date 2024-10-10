import 'dart:io';
import 'dart:typed_data'; // Ensure you're importing only this
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resume App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ResumeHomeScreen(),
    );
  }
}

class ResumeHomeScreen extends StatefulWidget {
  @override
  _ResumeHomeScreenState createState() => _ResumeHomeScreenState();
}

class _ResumeHomeScreenState extends State<ResumeHomeScreen> {
  double _zoomLevel = 1.25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Resume PDF Viewer"),
      ),
      body: Column(
        children: [
          Expanded(
            child: PdfPreview(
              build: (format) => _generateResumePdf(format),
              pdfFileName: 'resume.pdf',
              maxPageWidth: 1200 * _zoomLevel, // Use zoom level here
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.zoom_out),
                  onPressed: () {
                    setState(() {
                      if (_zoomLevel > 0.5) _zoomLevel -= 0.1;
                    });
                  },
                ),
                Slider(
                  value: _zoomLevel,
                  min: 0.5,
                  max: 3.0,
                  divisions: 25,
                  label: _zoomLevel.toStringAsFixed(1),
                  onChanged: (value) {
                    setState(() {
                      _zoomLevel = value;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.zoom_in),
                  onPressed: () {
                    setState(() {
                      if (_zoomLevel < 3.0) _zoomLevel += 0.1;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<Uint8List> _generateResumePdf(PdfPageFormat format) async {
    final pdf = pw.Document();

    final profileImage = await imageFromAssetBundle('assets/21b8ec7d-7b88-4fa2-bf2d-11c524abbb8b.png'); // Add your image here
    final phoneIcon = await imageFromAssetBundle('assets/phone.png');
    final emailIcon = await imageFromAssetBundle('assets/email.png');
    final addressIcon = await imageFromAssetBundle('assets/address.png');

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              buildHeaderSection(profileImage),
              pw.SizedBox(height: 20),
              buildAboutMeSection(phoneIcon, emailIcon, addressIcon),
              pw.SizedBox(height: 20),
              buildExperienceSection(),
              pw.SizedBox(height: 20),
              buildSkillsAndEducationSection(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  // Header Section
  pw.Widget buildHeaderSection(pw.ImageProvider profileImage) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          width: 80,
          height: 80,
          decoration: pw.BoxDecoration(
            shape: pw.BoxShape.circle,
            image: pw.DecorationImage(image: profileImage, fit: pw.BoxFit.cover),
          ),
        ),
        pw.SizedBox(width: 16),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Rizul Sharma',
                style: pw.TextStyle(
                  fontSize: 32,
                  fontWeight: pw.FontWeight.bold,
                )),
            pw.Text('Flutter Developer',
                style: pw.TextStyle(
                  fontSize: 16,
                  color: PdfColors.grey,
                )),
          ],
        ),
      ],
    );
  }

  // About Me Section
  pw.Widget buildAboutMeSection(
      pw.ImageProvider phoneIcon,
      pw.ImageProvider emailIcon,
      pw.ImageProvider addressIcon) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('About Me',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text(
              'I am a highly skilled Flutter developer with experience in building responsive apps for Android and iOS.'),
          pw.SizedBox(height: 10),
          pw.Row(children: [
            pw.Image(phoneIcon, width: 12, height: 12), // Phone Icon
            pw.SizedBox(width: 5),
            pw.Text('+91-8178607415'),
          ]),
          pw.SizedBox(height: 5),
          pw.Row(children: [
            pw.Image(emailIcon, width: 12, height: 12), // Email Icon
            pw.SizedBox(width: 5),
            pw.Text('write2rizul@gmail.com'),
          ]),
          pw.SizedBox(height: 5),
          pw.Row(children: [
            pw.Image(addressIcon, width: 12, height: 12), // Address Icon
            pw.SizedBox(width: 5),
            pw.Text('Delhi'),
          ]),
        ],
      ),
    );
  }

  // Experience Section
  pw.Widget buildExperienceSection() {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Experience',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Column(
            children: [
              buildExperienceItem(
                company: 'AppMingle Media',
                location: 'Noida Sector-6, India',
                duration: 'April 2024 - September 2024',
                description:
                'Working on building responsive and dynamic mobile applications using Flutter.',
              ),
              buildExperienceItem(
                company: 'Freelancer',
                location: 'Remote',
                duration: '2022 - 2024',
                description:
                'Handled multiple projects related to mobile app development, backend API integration, and UI/UX design.',
              ),
            ],
          )
        ],
      ),
    );
  }

  pw.Widget buildExperienceItem({
    required String company,
    required String location,
    required String duration,
    required String description,
  }) {
    return pw.Container(
      padding: const pw.EdgeInsets.symmetric(vertical: 8),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('$company, $location',
              style: pw.TextStyle(
                  fontSize: 14, fontWeight: pw.FontWeight.bold)),
          pw.Text(duration,
              style: pw.TextStyle(
                  fontSize: 12, color: PdfColors.grey)),
          pw.SizedBox(height: 5),
          pw.Text(description,
              style: pw.TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // Skills and Section
  pw.Widget buildSkillsAndEducationSection() {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              buildEducationSection(),
              pw.SizedBox(height: 20),
              buildSkillSummarySection(),
            ],
          ),
        ),
      ],
    );
  }

  // Education Section
  pw.Widget buildEducationSection() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Education',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 5),
          pw.Text('- GURU GOBIND SINGH INDRAPRASTHA UNIVERSITY\n BTECH INFORMATION TECHNOLOGY undefined: 9.1\n(2021 - 2025 	New Delhi, India)'),
          pw.Text('- NC JINDAL PUBLIC SCHOOL\nHIGHER SECONDARY SCHOOL SCIENCE STREAM Percentage: 85.0% (2019-2021)'),
          pw.Text('- NC JINDAL PUBLIC SCHOOL\nSECONDARY SCHOOL  Percentage: 82.0% (2019-2021)'),
        ],
      ),
    );
  }

  // Skill Summary Section
  pw.Widget buildSkillSummarySection() {
    return pw.Container(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Skills Summary',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          buildSkillBar('Flutter', 80),
          buildSkillBar('UI/UX Design', 75),
          buildSkillBar('Payment Gateway', 75),
          buildSkillBar('Google Maps', 70),
          buildSkillBar('Firebase', 90),
        ],
      ),
    );
  }

  pw.Widget buildSkillBar(String skill, int percentage) {
    return pw.Row(
      children: [
        pw.Text(skill),
        pw.SizedBox(width: 10),
        pw.Expanded(
          child: pw.LinearProgressIndicator(value: percentage / 100),
        ),
        pw.SizedBox(width: 10),
        pw.Text('$percentage%'),
      ],
    );
  }
}
