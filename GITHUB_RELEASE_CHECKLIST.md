# First GitHub Release Checklist

- [ ] Create public GitHub repository `MathParser`.
- [ ] Do not initialize it with generated source-code templates.
- [ ] Upload only the prepared public repository files.
- [ ] Choose repository description and visibility = Public.
- [ ] Keep source tree in the private development workspace only.
- [ ] Build MathParser 2.0.5.7 on Windows.
- [ ] Run the full regression suite.
- [ ] Run `tools/package-public.ps1` against the private MathParser root.
- [ ] Inspect the ZIP manually.
- [ ] Confirm no `*.pas`, `*.pp`, `*.inc`, `*.lpi`, `*.lpr`, `*.lfm`, `*.lpk`, or `*.py` files are present.
- [ ] Test the portable ZIP on a clean Windows machine/VM.
- [ ] Create GitHub release tag `v2.0.5.7`.
- [ ] Attach the portable ZIP and `SHA256SUMS.txt`.
- [ ] Paste `RELEASE_BODY_2.0.5.7.md` into the release notes.
- [ ] Publish as a normal release after clean-machine validation.
