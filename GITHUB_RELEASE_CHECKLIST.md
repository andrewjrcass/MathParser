# MathParser 2.0.7.139 — GitHub Release Checklist

- [x] Public GitHub repository `MathParser` exists and is public.
- [x] Repository remains distribution/documentation-only; MathParser source code is not committed here.
- [x] MathParser 2.0.7.139 source baseline is CLOSED / SEALED.
- [x] Release/version metadata is synchronized at 2.0.7.139.
- [x] `mathparser_gui.lpr` uses `{$AppType GUI}` for the Windows GUI target.
- [x] Full maintained canonical regression completed for the sealed baseline.
- [ ] Build MathParser 2.0.7.139 on the validated Windows environment.
- [ ] Run/stage the Windows runtime from that same build.
- [ ] Run `tools/package-public.ps1` against the sealed 2.0.7.139 root.
- [ ] Inspect the portable ZIP manually.
- [ ] Confirm no `*.pas`, `*.pp`, `*.inc`, `*.lpi`, `*.lpr`, `*.lfm`, `*.lpk`, `*.py` or nested source archives are present.
- [ ] Confirm README, ROADMAP, manual/offline Help and third-party notices/licenses are present in the public profile.
- [ ] Confirm executable version = runtime version = 2.0.7.139.
- [ ] Test the portable ZIP after extraction on Windows, preferably outside the development tree.
- [ ] Create GitHub release tag `v2.0.7.139`.
- [ ] Attach `MathParser-2.0.7.139-Windows-x64-Portable.zip` and `SHA256SUMS.txt`.
- [ ] Use `RELEASE_BODY_2.0.7.139.md` as the release notes.
- [ ] Publish as a normal release only after the packaged binary smoke test passes.
