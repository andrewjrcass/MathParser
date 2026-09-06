# Distribution Notes

## Public repository policy

This repository contains public documentation and release metadata only.

It must not contain:

- Pascal/FPC source files (`*.pas`, `*.pp`, `*.inc`);
- Lazarus project/form sources (`*.lpi`, `*.lpr`, `*.lfm`, `*.lpk`);
- Python source files used internally by the engine;
- private build scripts or internal architecture/audit documents;
- private project ZIPs.

## Release assets

Public binaries are attached to GitHub Releases rather than committed to Git history.

For 2.0.7.139 the public Windows package is named:

```text
MathParser-2.0.7.139-Windows-x64-Portable.zip
SHA256SUMS.txt
```

A Windows installer may be added later after the portable distribution has accumulated clean-system validation.

## Portable package contract

The package is assembled only from the already built and staged 2.0.7.139 Windows runtime. The public packaging step must not compile or modify the scientific source baseline.

Required user-facing contents include the GUI executable, console executable when distributed, VERSION, locale files, offline runtime assets/themes/extensions, offline Help/manual material, README, ROADMAP and applicable third-party notices/licenses.

The packaging step must explicitly reject development/source extensions and nested source archives. The public profile excludes the external Python bridge source (`*.py`).

Before publication, verify that the executable and staged runtime both identify themselves as `2.0.7.139`, then smoke-test the ZIP after extracting it outside the development tree.
