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

Public binaries should be attached to GitHub Releases rather than committed to the Git history.

Recommended naming:

```text
MathParser-2.0.5.7-Windows-x64-Portable.zip
SHA256SUMS.txt
```

A Windows installer may be added later after the portable package has been validated on clean systems.

## Portable package contract

The package is assembled from the already staged runtime in `build/bin`.

The public packaging step must copy only runtime assets needed by users and must explicitly reject development/source extensions.

The initial public profile excludes the external Python bridge source file.
