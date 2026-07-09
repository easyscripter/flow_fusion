import 'dart:io';

import 'package:flow_fusion/ui/constants/app_sizes.dart';
import 'package:flow_fusion/ui/l10n/l10n_context.dart';
import 'package:flow_fusion/ui/theme/theme_context.dart';
import 'package:flow_fusion/ui/views/session_editor_view/session_editor_view_model.dart';
import 'package:flow_fusion/ui/views/session_editor_view/widgets/blocked_site_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BlockedSitesSection extends StatefulWidget {
  const BlockedSitesSection({super.key, required this.viewModel});

  final SessionEditorViewModel viewModel;

  @override
  State<BlockedSitesSection> createState() => _BlockedSitesSectionState();
}

class _BlockedSitesSectionState extends State<BlockedSitesSection> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final String value = _controller.text.trim();
    if (value.isEmpty) return;
    widget.viewModel.addBlockedSite(value);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isWindows) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.sessionEditorBlockedSitesTitle,
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSizes.paddingSmall / 2),
        Text(
          context.l10n.sessionEditorBlockedSitesSubtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: context.fusionColors.mutedForeground,
              ),
        ),
        const SizedBox(height: AppSizes.paddingSmall),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _controller,
                autocorrect: false,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  hintText: context.l10n.sessionEditorBlockedSitesHint,
                ),
              ),
            ),
            const SizedBox(width: AppSizes.paddingSmall),
            IconButton.filledTonal(
              onPressed: _submit,
              tooltip: context.l10n.sessionEditorAddBlockedSite,
              icon: const Icon(Icons.add_rounded),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.paddingMedium),
        Observer(
          builder: (_) {
            if (widget.viewModel.blockedSites.isEmpty) {
              return Text(
                context.l10n.sessionEditorNoBlockedSites,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: context.fusionColors.mutedForeground,
                    ),
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.viewModel.blockedSites.length,
              separatorBuilder: (_, _) =>
                  const SizedBox(height: AppSizes.paddingSmall),
              itemBuilder: (BuildContext context, int index) {
                final String domain = widget.viewModel.blockedSites[index];
                return BlockedSiteTile(
                  domain: domain,
                  onRemove: () => widget.viewModel.removeBlockedSite(domain),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
