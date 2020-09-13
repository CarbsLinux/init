CHANGELOG
================================================================================

This CHANGELOG is for the Carbs Linux init scheme. The format is based on
[Keep a Changelog], and it adheres to [Semantic Versioning].

[Keep a Changelog]:    https://keepachangelog.com/en/1.0.0/
[Semantic Versioning]: https://semver.org/spec/v2.0.0.html


1.1.0 - 2020-09-13
--------------------------------------------------------------------------------

### Added
- Added `*.umount` hook that runs after all file-systems are unmounted.


1.0.1 - 2020-08-16
--------------------------------------------------------------------------------

### Fixed
- Fixed creation of runit directories where we accidentally created a directory
  named '/0755' instead of setting the directory permissions.


1.0.0 - 2020-08-15
--------------------------------------------------------------------------------

### Added
- Support for mdev.
- Support for parsing the kernel command-line.
- Support for reading hooks from `/usr/lib/init/hooks`.
- Support for killing `sysmgr`.

### Changed
- We now hardcode `/usr/lib/init` to the script.
- Renamed `emergency_shell` to `shell`.
- If `runit` is not used, we don't kill them.
- Scripts now honour the kernel `quiet` value.
- Changed `shalt`'s argument parsing.

### Fixed
- We no longer try to kill runit services if none is available.
- Made `Makefile` calls POSIX compliant.

### Removed
- Crypttab functions.
- Removed the handling of `/etc/init/rc.local` file. You can use
  `/etc/init/local.boot` instead.


0.7.0 - 2020-03-24
--------------------------------------------------------------------------------

### Added
- Added a simple halt utility.
- Added parse_crypttab function.

### Removed
- Removed `dist` target from Makefile.


0.6.0/1 - 2020-02-14
--------------------------------------------------------------------------------

### Added
- Added getty.boot for unifying the control on every init process.
- Added runit.boot for unifying the control on every init process.

### Changed
- Now killing udevd before boot hooks.


0.5.0 - 2020-01-15
--------------------------------------------------------------------------------

### Changed
- Removed `run_hooks` and added the function manually for option parsing.

### Removed
- Removed inittab.
- Removed `halt` from `rc.shutdown`.


0.4.0 - 2020-01-13
--------------------------------------------------------------------------------

### Added
- Reading user hooks from the configuration directory.


0.3.0 - 2020-01-09
--------------------------------------------------------------------------------

### Changed
- Moved init configuration to /etc/init.


0.2.0 - 2019-12-27
--------------------------------------------------------------------------------

### Added
- Added Makefile.
- Added rc.conf.
- dmesg level can now be set on rc.conf.
- keymap settings can now be set from rc.conf.


0.1.1 - 2019-12-13
--------------------------------------------------------------------------------

### Added
- Get keymap settings.
