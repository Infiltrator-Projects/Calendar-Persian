# Persian Solar Hijri Calendar

**InfiltratorOS calendar resource** · **Stable ID:** `persian` · **Module:** `Persian Solar Hijri Calendar.so`

Modern Solar Hijri arithmetic using the maintained ICU-compatible leap-correction rules.

**Historical scope/accuracy:** Iranian civil month lengths differed before 1304 AP (1925 CE); ancient projections are not historic civil records.

**Intended installation:** `/System/Resources/Calendars/Persian Solar Hijri Calendar.so` (case-sensitive)

The provider owns fields, localized formatting, period starts and navigation. Field extraction determines the supported date domain; every other operation must reject the same invalid input. Switching calendar presentation cannot rewrite canonical instants or event ordering.

## Status

**Independent source, native installation and releases.** This repository contains the implementation of `persian`, the supporting code it needs, a one-provider `Makefile` and focused regression fixtures. The initial extraction came from Common 1.19.78; current builds link the pinned Common 1.19.87 submodule. The original source remains available.

Run `make` to produce `build/Persian Solar Hijri Calendar.so` and `make check` to run this provider's checks. Initialise the pinned Common submodule with `git submodule update --init --recursive` before building. Current releases provide a portable amd64 Debian package and a lightweight native network installer.

See [source provenance and build details](SOURCE.md), [source manifest](SOURCE-MANIFEST.json) and [recorded validation](VALIDATION-RESULTS.json).

## Documentation

- [User manual source](docs/GUIDE.json) — calendar structure, history, examples and limits.
- [Model and evidence](docs/MODEL.md)
- [Architecture and ownership](docs/ARCHITECTURE.md)
- [Validation requirements](docs/VALIDATION.md)
- [Roadmap](docs/ROADMAP.md)
- [Documentation index](docs/README.md)

## Existing authoritative sources

- [Libraries/Common temporal sources](https://github.com/Infiltrator-Projects/Libraries/tree/main/resources/temporal)
- [Current canonical build catalogue](https://github.com/Infiltrator-Projects/Libraries/blob/main/resources/temporal/Makefile)
- [Calendar chronology and clock models](https://github.com/Infiltrator-Projects/Calendar/blob/main/docs/MODELS.md)
- [Historical fidelity audit](https://github.com/Infiltrator-Projects/Libraries/blob/main/docs/TEMPORAL_HISTORICAL_FIDELITY.md)
- [Temporal discovery and executable provider ABI](https://github.com/Infiltrator-Projects/Libraries/blob/main/docs/TEMPORAL_PROVIDERS.md)

## Independent forensic audit

See [audit findings](docs/FORENSIC-AUDIT.md) for corrections, numerical-model limits and unresolved authority disagreements. A successful build is not a historical-accuracy certificate.

## Release and installation

Run `make release` to qualify and create exactly two assets in `dist/`: a portable amd64 `.deb` and a `-native-installer.run`. The installer fetches the exact provider commit and pinned Common submodule, verifies their identities and builds locally; it embeds neither source nor binary payload. Linux releases are built and installed by GitHub Actions before publication.

Run the downloaded `.run --profile aggressive` as an ordinary user. It provisions missing build prerequisites, compiles for the local CPU with `-O3`, LTO and measured two-pass PGO, checks the final module, then installs a native Debian package through sudo. InfiltratorOS invokes `--profile aggressive --system-package-mode` from its serialized installation worker. `--build-only --output DIRECTORY` qualifies a native package without installing it.

Each package owns only this provider and its PDF manual under `/System/Resources/Documentation/`. `docs/GUIDE.json` is the structured manual source; the currently pinned Common renderer still uses the README summary and scope. Engineering documentation remains in the repository. Its `Replaces` declaration transfers this module from `infiltrator-calendar-resources` on existing machines; other modules and Common source remain intact. Native package versions use `+native1` so a same-version generic package does not replace a local optimized build. See [packaging details](docs/PACKAGING.md).
