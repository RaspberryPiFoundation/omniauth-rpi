# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.1] - 2025-7-17
### Changed
- jwt version constraint relaxed; see https://github.com/RaspberryPiFoundation/omniauth-rpi/pull/19 for context

## [1.4.0] - 2023-02-13
### Changed
- Fixes setting of uid from raw_info using sub (uid was previously blank)

## [1.3.1] - 2021-10-14
### Changed
- Removed Hydra v0 strategy, which is better handled in the `hydra-v0` branch and `v0.x.x` releases

## [1.3.0] - 2021-10-14
### Changed
- Replaced force_signup param with a more extensible login_options param

## [1.2.0] - 2021-09-30
### Added
- Added force_signup param to enable passing of custom param to the identity provider

## [1.1.0] - 2021-09-10
### Added
- Changelog in preparation for publishing app to rubygems.org
- Omniauth strategy for authenticating via RPI Hydra V1 endpoints
