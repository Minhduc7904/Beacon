import 'package:flutter/material.dart';

import 'test/test_post_media.dart';

class DevTestRunnerSheet extends StatelessWidget {
  const DevTestRunnerSheet({
    super.key,
    required this.stepLogs,
    required this.isContinueBlocked,
    required this.isFlowCompleted,
    required this.isRunAllRunning,
    required this.onContinue,
    required this.onRunAll,
    required this.onRestart,
    required this.onStop,
  });

  final List<TestPostMediaLogEntry> stepLogs;
  final bool isContinueBlocked;
  final bool isFlowCompleted;
  final bool isRunAllRunning;
  final VoidCallback onContinue;
  final VoidCallback onRunAll;
  final VoidCallback onRestart;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.28),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      children: [
                        IgnorePointer(
                          ignoring:
                              isContinueBlocked || isFlowCompleted || isRunAllRunning,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              minimumSize: const Size(36, 36),
                              maximumSize: const Size(36, 36),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: isFlowCompleted
                                  ? Colors.green.shade600
                                  : isContinueBlocked
                                  ? Colors.red.shade600
                                  : isRunAllRunning
                                  ? Colors.amber.shade700
                                  : null,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: onContinue,
                            iconSize: 18,
                            icon: const Icon(Icons.play_arrow_rounded),
                          ),
                        ),
                        IgnorePointer(
                          ignoring:
                              isContinueBlocked || isFlowCompleted || isRunAllRunning,
                          child: IconButton.filled(
                            style: IconButton.styleFrom(
                              minimumSize: const Size(36, 36),
                              maximumSize: const Size(36, 36),
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: isRunAllRunning
                                  ? Colors.amber.shade700
                                  : null,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: onRunAll,
                            iconSize: 18,
                            icon: const Icon(Icons.playlist_play_rounded),
                          ),
                        ),
                        IconButton.filled(
                          style: IconButton.styleFrom(
                            minimumSize: const Size(36, 36),
                            maximumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: onRestart,
                          iconSize: 18,
                          icon: const Icon(Icons.restart_alt_rounded),
                        ),
                        IconButton.filledTonal(
                          style: IconButton.styleFrom(
                            minimumSize: const Size(36, 36),
                            maximumSize: const Size(36, 36),
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: onStop,
                          iconSize: 18,
                          icon: const Icon(Icons.stop_rounded),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Log các step',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black87, blurRadius: 8)],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.35),
                    ),
                  ),
                  child: stepLogs.isEmpty
                      ? Center(
                          child: Text(
                            'Chưa có step nào',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.white),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: stepLogs.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final entry = stepLogs[index];
                            return Text(
                              entry.message,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: entry.isError
                                        ? Colors.red.shade300
                                        : Colors.white,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black87,
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
