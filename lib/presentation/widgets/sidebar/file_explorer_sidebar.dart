import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../application/file_explorer/file_explorer_bloc.dart';
import '../../../application/file_explorer/file_explorer_event.dart';
import '../../../application/file_explorer/file_explorer_state.dart';
import 'file_tree_item.dart';

class FileExplorerSidebar extends StatelessWidget {
  const FileExplorerSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border(right: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Column(
        children: [
          // Header
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white.withOpacity(0.06))),
            ),
            child: Row(
              children: [
                const Icon(Icons.folder_open, size: 16, color: Colors.white54),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'مستكشف الملفات',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70),
                  ),
                ),
                _IconBtn(
                  icon: Icons.refresh,
                  onPressed: () => context.read<FileExplorerBloc>().add(const RefreshDirectory()),
                ),
              ],
            ),
          ),
          // File tree
          Expanded(
            child: BlocBuilder<FileExplorerBloc, FileExplorerState>(
              builder: (context, state) {
                if (state is FileExplorerLoading) {
                  return const Center(child: CircularProgressIndicator(color: Colors.white24));
                }
                if (state is FileExplorerError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(state.message, style: const TextStyle(color: Colors.white38)),
                    ),
                  );
                }
                if (state is FileExplorerLoaded) {
                  if (state.nodes.isEmpty) {
                    return const Center(
                      child: Text('لا توجد ملفات مدعومة', style: TextStyle(color: Colors.white38, fontSize: 12)),
                    );
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: state.nodes.length,
                    itemBuilder: (context, index) => FileTreeItem(
                      node: state.nodes[index],
                      depth: 0,
                    ),
                  );
                }
                return const Center(
                  child: Text('اختر مجلداً لتصفحه', style: TextStyle(color: Colors.white38, fontSize: 12)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _IconBtn({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, size: 14, color: Colors.white38),
      ),
    );
  }
}
