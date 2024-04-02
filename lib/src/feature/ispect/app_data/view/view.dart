part of '../app_data.dart';

class _AppDataView extends StatelessWidget {
  final AppDataController controller;
  final void Function() deleteFiles;
  final void Function(int) deleteFile;
  const _AppDataView({
    required this.controller,
    required this.deleteFiles,
    required this.deleteFile,
  });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget? child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Gap(10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.app_data,
                          style: context.theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          context.l10n
                              .total_files_count(controller.files.length),
                          style: context.theme.textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    Visibility(
                      visible: controller.files.isNotEmpty,
                      child: IconButton(
                        onPressed: deleteFiles,
                        icon: Icon(
                          Icons.delete_outline_rounded,
                          color: context.colors.error,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(top: 10.0),
                  itemCount: controller.files.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 0),
                  itemBuilder: (BuildContext ctx, i) {
                    final f = controller.files[i];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 10,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "$i. File:\n ${f.path}",
                              style: context.theme.textTheme.labelMedium,
                            ),
                          ),
                          IconButton(
                            onPressed: () => deleteFile(i),
                            icon: Icon(
                              Icons.delete_outline_rounded,
                              color: context.colors.error,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
}
