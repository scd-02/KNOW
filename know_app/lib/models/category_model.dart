import 'package:flutter/material.dart';

class CategoryModel {
  String name;
  String iconPath;
  Color boxColor;

  CategoryModel({
    required this.name,
    required this.iconPath,
    required this.boxColor,
  });

  static List<CategoryModel> getCategories() {
    List<CategoryModel> categories = [];

    categories.add(CategoryModel(
        name: 'tasks',
        iconPath: 'assets/icons/tasks.svg',
        boxColor: const Color(0xff92A3FD)));

    categories.add(CategoryModel(
        name: 'docs',
        iconPath: 'assets/icons/docs.svg',
        boxColor: const Color(0xffC58BF2)));

    categories.add(CategoryModel(
        name: 'health',
        iconPath: 'assets/icons/health.svg',
        boxColor: const Color(0xff92A3FD)));

    categories.add(CategoryModel(
        name: 'travel',
        iconPath: 'assets/icons/travel.svg',
        boxColor: const Color(0xffC58BF2)));

    categories.add(CategoryModel(
        name: 'invest',
        iconPath: 'assets/icons/invest.svg',
        boxColor: const Color(0xff92A3FD)));

    categories.add(CategoryModel(
        name: 'bills',
        iconPath: 'assets/icons/bills.svg',
        boxColor: const Color(0xffC58BF2)));

    return categories;
  }
}
