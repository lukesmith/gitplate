@echo off
set FRAMEWORK_PATH=C:/WINDOWS/Microsoft.NET/Framework/v4.0.30319
set PATH=%PATH%;%FRAMEWORK_PATH%;
SET SOLUTION_DIR="%~dp0\\"
SET BUILD_DIR="%~dp0build\\"
SET BUILD_OUTPUT_DIR="%BUILD_DIR%output\\"

IF EXIST %BUILD_DIR% (RD %BUILD_DIR% /S /Q)

mkdir %BUILD_OUTPUT_DIR%


SET CONFIGURATIONS=(Release)
SET SERVICES=()
SET WEBSITES=()

FOR %%c in %CONFIGURATIONS% do (
   FOR %%i in %SERVICES% do (
      @ECHO Packaging %%i with configuration %%c
      msbuild /nologo src\%%~ni\%%i /p:Configuration=%%c /t:Build;TransformWebConfig /p:SolutionDir=%SOLUTION_DIR% /p:OutputPath=%BUILD_OUTPUT_DIR%%%c\%%~ni\
   )
)
