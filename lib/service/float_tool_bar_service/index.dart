import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class FloatingToolBarService {
  static Hook<bool> isPreviewHook = Hook(false);
  static Hook<bool> isSplittingPreviewHook = Hook(false);

  static void onTapPreview() => setIsPreviewHook(!isPreviewHook.value);
  static void onTapSplittingPreview() => setIsSplittingPreview(!isSplittingPreviewHook.value);

  static void setIsSplittingPreview(bool isSplitPreview) => isSplittingPreviewHook.set(isSplitPreview);

  static void setIsPreviewHook(bool isPreview) => isPreviewHook.set(isPreview);
}
