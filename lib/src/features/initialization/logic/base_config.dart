import 'package:base_starter/src/common/constants/app_constants.dart';
import 'package:base_starter/src/features/initialization/model/env_type.dart';
import 'package:flutter/material.dart';

const configMap = {
  "DEV": DevConfig(),
  "PROD": ProdConfig(),
};

@immutable
sealed class InternalEnvConfig {
  final EnvType environment;
  final String appName;
  final String flavor;

  const InternalEnvConfig({
    required this.environment,
    required this.appName,
    required this.flavor,
  });

  EnvType get getEnvironment => environment;

  String get getAppName => appName;

  bool get isDev => environment == EnvType.dev;

  bool get isProd => environment == EnvType.prod;
}

class DevConfig extends InternalEnvConfig {
  const DevConfig()
      : super(
          environment: EnvType.dev,
          appName: "[DEV] ${AppConstants.appName}",
          flavor: "DEV",
        );
}

class ProdConfig extends InternalEnvConfig {
  const ProdConfig()
      : super(
          environment: EnvType.prod,
          appName: AppConstants.appName,
          flavor: "PROD",
        );
}
