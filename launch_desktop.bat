@echo off
set JAVA_HOME=C:\Users\Hp\android-tools\jdk-17.0.10+7
set PATH=C:\Users\Hp\android-tools\flutter\bin;C:\Users\Hp\android-tools\jdk-17.0.10+7\bin;C:\Users\Hp\android-tools\platform-tools;%PATH%
adb -s ZA2233V8Q9 shell monkey -p com.example.riverside_flutter_app -c android.intent.category.LAUNCHER 1
