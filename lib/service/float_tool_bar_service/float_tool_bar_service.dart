import 'package:wuchuheng_hooks/wuchuheng_hooks.dart';

class FloatingToolBarService {
  Hook<bool> isPreviewHook = Hook(false);
  Hook<bool> isSplittingPreviewHook = Hook(false);

  void onTapPreview() {
    final newValue = !isPreviewHook.value;
    setIsPreviewHook(newValue);
    if (newValue && isSplittingPreviewHook.value) setIsSplittingPreview(false);
  }

  void onTapSplittingPreview() {
    final newValue = !isSplittingPreviewHook.value;
    setIsSplittingPreview(newValue);
    if (newValue && isPreviewHook.value) setIsPreviewHook(false);
  }

  void setIsSplittingPreview(bool isSplitPreview) => isSplittingPreviewHook.set(isSplitPreview);

  void setIsPreviewHook(bool isPreview) => isPreviewHook.set(isPreview);
}
