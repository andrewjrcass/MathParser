# MathParser 2.0.7.139

This is the first public Windows x64 portable distribution candidate for the current MathParser 2.x line.

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

## Validation baseline

The sealed 2.0.7.139 development baseline completed the maintained canonical regression suite and focused Field regressions before public packaging. Release packaging is performed from the already built/staged Windows runtime and does not rebuild or modify the scientific source baseline.

## Package

Download:

`MathParser-2.0.7.139-Windows-x64-Portable.zip`

Verify it against the accompanying `SHA256SUMS.txt`.

Extract the whole ZIP to a writable folder and run `mathparser_gui.exe`. Keep the directory structure intact because offline Help, themes, extensions and rendering assets are loaded relative to the application folder.

## Distribution note

This GitHub repository is for public distribution and documentation. MathParser source code is not included in the repository or release package.

The public portable profile intentionally excludes internal development files and the external Python bridge source.
