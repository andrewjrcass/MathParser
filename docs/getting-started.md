# Getting Started

## Windows x64 portable package

1. Download the latest portable ZIP from GitHub Releases.
2. Extract the **whole archive**. Do not run the program from inside the ZIP viewer.
3. Open the extracted folder.
4. Run `mathparser_gui.exe`.

The package must remain intact because the application uses runtime resources located beside the executable.

Expected runtime folders include:

- `assets/`
- `themes/`
- `extensions/`
- `help/`

Expected runtime files include:

- `mathparser_gui.exe`
- `eval1.exe`
- `WebView2Loader.dll`
- `locale_pt.ini`
- `locale_en.ini`
- `VERSION`

## Console

From a terminal opened in the extracted folder:

```text
eval1.exe --version
```

A script can be executed with:

```text
eval1.exe path\to\script.mps
```

## Help

The desktop application includes offline Help in Portuguese and English.

## Python integration

The initial **Public Portable** profile does not distribute the external Python bridge source file. Python integration is therefore not part of the first public portable profile.

This limitation is intentional so that the public package contains compiled/runtime assets only.
