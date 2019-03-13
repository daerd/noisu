#!/usr/bin/env ruby
# frozen_string_literal: true

ENV["RAILS_ENV"] ||= ENV["RACK_ENV"] || "development"
ENV["NODE_ENV"]  ||= "development"

require "pathname"
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile", Pathname.new(__FILE__).realpath)

require "rubygems"
require "bundler/setup"

require "webpacker"
require "webpacker/webpack_runner"
Webpacker::WebpackRunner.run(ARGV)
