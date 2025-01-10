import 'dart:ffi';
import 'package:win32/win32.dart';
import 'package:ffi/ffi.dart';

// Define the function types

typedef SetWindowDisplayAffinityC = Int32 Function(
    IntPtr hwnd, Uint32 affinity);
typedef SetWindowDisplayAffinityDart = int Function(int hwnd, int affinity);

typedef EnumWindowsProcC = Int32 Function(IntPtr hwnd, IntPtr lParam);
typedef EnumWindowsProcDart = int Function(int hwnd, int lParam);

typedef EnumWindowsC = Int32 Function(
    Pointer<NativeFunction<EnumWindowsProcC>> lpEnumFunc, IntPtr lParam);
typedef EnumWindowsDart = int Function(
    Pointer<NativeFunction<EnumWindowsProcC>> lpEnumFunc, int lParam);

typedef GetWindowThreadProcessIdC = Uint32 Function(
    IntPtr hwnd, Pointer<Uint32> lpdwProcessId);
typedef GetWindowThreadProcessIdDart = int Function(
    int hwnd, Pointer<Uint32> lpdwProcessId);

// Top-level callback function
int enumWindowsProc(int hwnd, int lParam) {
  final processIdPointer = calloc<Uint32>();
  GetWindowThreadProcessId(hwnd, processIdPointer);
  final windowProcessId = processIdPointer.value;
  calloc.free(processIdPointer);

  final currentProcessId = GetCurrentProcessId();

  if (windowProcessId == currentProcessId) {
    // Store the hwnd in the location pointed to by lParam
    final windowHandlePointer = Pointer<IntPtr>.fromAddress(lParam);
    windowHandlePointer.value = hwnd;

    return 0; // Stop enumeration
  }
  return 1; // Continue enumeration
}

// Function to set the window display affinity
void setWindowDisplayAffinity() {
  // Load user32.dll
  final user32 = DynamicLibrary.open('user32.dll');

  // Look up necessary functions
  final EnumWindows =
      user32.lookupFunction<EnumWindowsC, EnumWindowsDart>('EnumWindows');

  final GetWindowThreadProcessId = user32.lookupFunction<
      GetWindowThreadProcessIdC,
      GetWindowThreadProcessIdDart>('GetWindowThreadProcessId');

  final SetWindowDisplayAffinity = user32.lookupFunction<
      SetWindowDisplayAffinityC,
      SetWindowDisplayAffinityDart>('SetWindowDisplayAffinity');

  // Allocate memory to store the window handle
  final windowHandlePointer = calloc<IntPtr>();
  windowHandlePointer.value = 0;

  // Create a function pointer for the callback
  final enumWindowsProcPointer =
      Pointer.fromFunction<EnumWindowsProcC>(enumWindowsProc, 1);

  // Enumerate windows to find the window handle
  EnumWindows(enumWindowsProcPointer, windowHandlePointer.address);

  final windowHandle = windowHandlePointer.value;
  calloc.free(windowHandlePointer); // Free the allocated memory

  if (windowHandle != 0) {
    const WDA_MONITOR = 1;

    final result = SetWindowDisplayAffinity(windowHandle, WDA_MONITOR);

    if (result == 0) {
      final errorCode = GetLastError();
      print('SetWindowDisplayAffinity failed with error: $errorCode');
    } else {
      print('SetWindowDisplayAffinity succeeded');
    }
  } else {
    print('Could not get window handle');
  }
}