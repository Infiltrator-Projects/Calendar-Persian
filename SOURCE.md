# Persian Solar Hijri Calendar — source copy record

The initial source extraction created an independent implementation of provider `persian`, its required supporting C code and headers, a one-provider build, and copy-regression fixtures.

## Origin and scope

- **Source:** [Libraries/Common 1.19.78](https://github.com/Infiltrator-Projects/Libraries/tree/8d60662114e3052380f6f88ad3cacd9732ae7131).
- **Source revision:** `8d60662114e3052380f6f88ad3cacd9732ae7131`.
- **Original entry:** `resources/temporal/src/calendars/persian.c`.
- **Local entry:** `src/provider.c`.
- **Output:** `Persian Solar Hijri Calendar.so`.
- **Native resource path:** `/System/Resources/Calendars/Persian Solar Hijri Calendar.so`.
- **Original Common code:** retained unchanged. The original extraction was a copy, not a removal. Independent packaging now transfers only this installed module through dpkg; Common source remains retained.

Combined source files were selected for this provider and split by keeping its existing operations, data and required helper definitions. Inactive provider branches and unreachable definitions were removed. Shared helpers were copied during the initial extraction. Current builds instead compile and link the exact Common 1.19.89 submodule; copied Common headers are forbidden.

Public Common ABI headers retain compatibility declarations. Those declarations do not install or implement the other providers. The built module exports only its metadata entry and its `calendar` operation-table entry. Existing notices and the original GPL license are retained.

`SOURCE-MANIFEST.json` records original paths, original/copy hashes, selected definitions and the build configuration. Its hashes identify this initial extraction; later local edits legitimately change the copied hashes.

## Build and check

Use C11 and C++20 compilers, GNU Make and pkg-config, with glib-2.0 and icu-i18n development packages. Initialise the pinned Common submodule before building.

```sh
make
make check
```

The build directly creates `build/Persian Solar Hijri Calendar.so`. The current provider uses ICU/CLDR data and the Common build and validation tools; see `docs/PACKAGING.md`.

## Historical extraction checks

- Independent build with strict C11 warnings treated as errors.
- Metadata, stable ID, canonical name, callback ABI and export checks.
- **883** observations matched the original Common-built provider, including applicable conversion, formatting, navigation, timing and invalid-input cases.
- **84** provider-specific regression fixtures are retained under `tests/`.
- Common's existing calendar and clock module suites passed against the complete set of 54 independently built copies: **6 calendar tests and 16 clock tests**.

See `VALIDATION-RESULTS.json` for the tested host and exact source revision. This verifies the copy against the existing implementation; it is not an additional historical-fidelity audit or a cross-platform release qualification.
