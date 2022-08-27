import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class FloatingToolBarService {
  static Hook<bool> isPreviewHook = Hook(false);
  static Hook<bool> isSplittingPreviewHook = Hook(false);

  static void onTapPreview() {
    final newValue = !isPreviewHook.value;
    setIsPreviewHook(newValue);
    if (newValue && isSplittingPreviewHook.value) setIsSplittingPreview(false);
  }

  static void onTapSplittingPreview() {
    final newValue = !isSplittingPreviewHook.value;
    setIsSplittingPreview(newValue);
    if (newValue && isPreviewHook.value) setIsPreviewHook(false);
  }

  static void setIsSplittingPreview(bool isSplitPreview) => isSplittingPreviewHook.set(isSplitPreview);

  static void setIsPreviewHook(bool isPreview) => isPreviewHook.set(isPreview);
}
