import 'package:supabase_flutter/supabase_flutter.dart';

class Supa {
  static const url = 'https://mewhplctlpxazoqtdoxt.supabase.co';
  static const key = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1ld2hwbGN0bHB4YXpvcXRkb3h0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE4MTQ4NzgsImV4cCI6MjA3NzM5MDg3OH0.39ilTDL5Q00WVjmNdIXm3sDlQQZwHsjqrVcaWSveF2U';
  static final client = Supabase.instance.client;

  static init() => Supabase.initialize(url: url, anonKey: key);



}