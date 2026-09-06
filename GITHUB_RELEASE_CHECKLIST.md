# MathParser 2.0.7.139 — GitHub Release Checklist

- [x] Public GitHub repository `MathParser` exists and is public.
- [x] Repository remains distribution/documentation-only; MathParser source code is not committed here.
- [x] MathParser 2.0.7.139 source baseline is CLOSED / SEALED.
- [x] Release/version metadata is synchronized at 2.0.7.139.
- [x] `mathparser_gui.lpr` uses `{$AppType GUI}` for the Windows GUI target.
- [x] Full maintained canonical regression completed for the sealed baseline.
- [x] Build MathParser 2.0.7.139 on the validated Windows environment.
- [x] Run/stage the Windows runtime from that same build.
- [x] Assemble the public portable package from the supplied staged Windows runtime.
- [x] Inspect the portable ZIP structurally.
- [x] Confirm no `*.pas`, `*.pp`, `*.inc`, `*.lpi`, `*.lpr`, `*.lfm`, `*.lpk`, `*.py`, `*.pyc` or nested source archives are present.
- [x] Confirm README, ROADMAP, manual/offline Help and third-party notices/licenses are present in the public profile.
- [x] Confirm curated native `examples/` directory is present; Python bridge and internal Integration regression examples are excluded.
- [x] Confirm executable version = runtime version = 2.0.7.139.
- [ ] Test the final portable ZIP after extraction on Windows, preferably outside the development tree.
- [ ] Create GitHub release tag `v2.0.7.139`.
- [ ] Attach `MathParser-2.0.7.139-Windows-x64-Portable.zip` and `SHA256SUMS.txt`.
- [ ] Use `RELEASE_BODY_2.0.7.139.md` as the release notes.
- [ ] Publish as a normal release only after the packaged binary smoke test passes.

Final portable SHA-256 (with native examples):

`09130c75cdb4f25a6cbb4ae7d0cc299c86a8f109ba5260e75e524bb86825baa4`
