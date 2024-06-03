import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:base_starter/src/features/initialization/model/environment.dart';
import 'package:flutter/material.dart';

const configMap = {
  "DEV": DevConfig(),
  "PROD": ProdConfig(),
};

@immutable
sealed class BaseConfig {
  final Environment environment;
  final String appName;
  final String flavor;

  const BaseConfig({
    required this.environment,
    required this.appName,
    required this.flavor,
  });

  Environment get getEnvironment => environment;

  String get getAppName => appName;

  bool get isDev => environment == Environment.dev;

  bool get isProd => environment == Environment.prod;
}

class DevConfig extends BaseConfig {
  const DevConfig()
      : super(
          environment: Environment.dev,
          appName: "[DEV] ${AppConstants.appName}",
          flavor: "DEV",
        );
}

class ProdConfig extends BaseConfig {
  const ProdConfig()
      : super(
          environment: Environment.prod,
          appName: AppConstants.appName,
          flavor: "PROD",
        );
}
