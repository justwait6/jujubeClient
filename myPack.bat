set buildScriptPath=%~dp0/frameworks/runtime-src/proj.android

cd buildScriptPath
python build_native.py -a arm64-v8a
.\gradlew.bat assembleRelease
