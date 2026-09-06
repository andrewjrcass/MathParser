# MathParser 2.0.7.139

First public Windows x64 portable distribution for the current MathParser 2.x line.

MathParser is a compact scientific and engineering calculation environment written in Free Pascal/Lazarus. It combines physical-unit awareness, dimensional validation, numerical methods, scientific scripting, plotting, engineering-domain extensions and mathematical document rendering in a single desktop application.

## Highlights

- high-performance scientific/document rendering path consolidated in Gate8.6 / Gate8.6.1;
- canonical mathematical formatting for specialized scientific operations, including Tanh-Sinh integral presentation;
- Field visualization infrastructure for scalar and residual quantities in 1D, 2D and 3D;
- automatic Field plot dispatch with optional constraint overlays;
- vectors, matrices, complex numbers, derivatives, integrals, sums/products and numerical methods;
- structural/FEM, geotechnical, hydraulic, thermal, electrical and experimental-statistics extensions;
- offline Help in Portuguese and English;
- portable Windows x64 runtime with offline KaTeX/Plotly assets.

## Validation

The sealed 2.0.7.139 baseline completed the maintained canonical and focused regression suites before public packaging. The supplied Windows runtime was then audited independently:

- `VERSION` = `2.0.7.139`;
- `mathparser_gui.exe`, `console_app.exe` and `console_core.exe` contain `2.0.7.139` and do not contain `2.0.7.138`;
- all three executables are PE32+ x64;
- `mathparser_gui.exe` is Windows GUI subsystem; console executables are console subsystem;
- public package contains no Pascal/Lazarus/Python source or nested development archives;
- offline PT/EN Help and required runtime assets are present.

## Package

`MathParser-2.0.7.139-Windows-x64-Portable.zip`

SHA-256:

`8066f2ad8428eaac5ede15013dadbb482040ca5843a337398d5d5001fbf3291d`

Extract the whole ZIP to a writable folder and run `mathparser_gui.exe`. Keep the directory structure intact because offline Help, themes, extensions and rendering assets are loaded relative to the application folder.

Included executables:

- `mathparser_gui.exe`
- `console_app.exe`
- `console_core.exe`

## Documentation

- `README.md` — project overview and quick start;
- `MANUAL.md` — manual entry point;
- `help/pt/index.html` — complete Portuguese offline Help;
- `help/en/index.html` — complete English offline Help;
- `ROADMAP.md` — public development direction.

## Distribution note

This GitHub repository is for public distribution and documentation. MathParser source code is not included in the repository or release package.

The public portable profile intentionally excludes internal development files and the external Python bridge source.
