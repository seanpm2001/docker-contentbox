# Changelog

## v2.5.0

* Optimize for size
* Remove static healthcheck and just rely on the CommandBox image healthcheck, which makes more sense
* Removed some debugging files
* Updated CommandBox to 4.0.0
* `ORM_DIALECT` was not being used in the right place.
* `EXPRESS` and `HEADLESS` was not evaluated to a boolean, just existence 
* Removed usage of lowercase `install`, `be`, and `express`, you must use uppercase env variables.

## v2.4.0

* Added Router to handle full rewrites, which it should by default
* Rewrites should be added by default if no server.json is defined

## v2.3.0

* Added ContentBox v4.0.0 support
* Added new `HEADLESS` environment setting so the admin does not get deployed if passed

## v2.2.0

* Updated config for conflicted distributed cache setting