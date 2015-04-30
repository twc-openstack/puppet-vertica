# vertica

#### Table of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Usage](#usage)
4. [Limitations](#limitations)

## Overview

This module installs and configures the vertica database.

## Module Description

This module will install vertica from a specified url location, and sets
up the basic users and groups required by vertica.

## Usage

include ::vertica (see init.pp for default args)

## Limitations

This module does not bootstrap a vertica cluster, simply configures nodes
with vertica.
