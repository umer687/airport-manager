#!/usr/bin/env ruby
# frozen_string_literal: true
$LOAD_PATH.unshift(File.expand_path('../lib', __dir__))
require 'cli'

# Entry point for the Airport Management System console application.
# Keep this file minimal to make it easy to run.
CLI.new.run
