import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const firstColor = Color(0xff021639);
const secondColor = Color(0xff979FAD);

final defaultShadow = BoxShadow(
  offset: const Offset(5, 5),
  blurRadius: 10,
  color: const Color(0xffe9e9e9).withOpacity(0.56),
);

double defaultMargin1 = 30.0;
double defaultMargin2 = 20.0;

TextStyle poppinsTextStyle = GoogleFonts.poppins();

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w800;
FontWeight black = FontWeight.w900;
