# ZIP Container Ruby Library
## Robert Haines

A Ruby library for creating, editing and validating ZIP Container files.

[![Gem Version](https://badge.fury.io/rb/zip-container.svg)](https://badge.fury.io/rb/zip-container)
[![Tests](https://github.com/hainesr/ruby-zip-container/actions/workflows/tests.yml/badge.svg)](https://github.com/hainesr/ruby-zip-container/actions/workflows/tests.yml)
[![Linter](https://github.com/hainesr/ruby-zip-container/actions/workflows/lint.yml/badge.svg)](https://github.com/hainesr/ruby-zip-container/actions/workflows/lint.yml)
[![Ruby Style Guide](https://img.shields.io/badge/code_style-rubocop-brightgreen.svg)](https://github.com/rubocop/rubocop)
[![Maintainability](https://api.codeclimate.com/v1/badges/208195ace7c8f86e98d8/maintainability)](https://codeclimate.com/github/hainesr/ruby-zip-container/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/hainesr/ruby-zip-container/badge.svg)](https://coveralls.io/github/hainesr/ruby-zip-container)

### Synopsis

This is a Ruby library for working with ZIP Container files. See the [ODF](http://www.idpf.org/epub/30/spec/epub30-ocf.html) and [UCF](https://learn.adobe.com/wiki/display/PDFNAV/Universal+Container+Format) specifications for more details.

If you are wanting to work with UCF files specifically, there is a Ruby Gem that builds on this one specifically for that. Please see:
 * [GitHub](https://github.com/hainesr/ruby-ucf)
 * [Rubygems](https://rubygems.org/gems/ucf)

### Usage

This library has two entry points.

The main `ZipContainer::File` class largely mimics the rubyzip [Zip::File](http://www.rubydoc.info/gems/rubyzip/1.1.6/Zip/File) and [Zip::FileSystem](http://www.rubydoc.info/gems/rubyzip/1.1.6/Zip/FileSystem) APIs so much of what you can do with them are supported for ZIP Containers. There is also [API documentation](http://hainesr.github.io/ruby-zip-container/) with much more detail and any differences explained.

The `ZipContainer::Dir` class mimics, where possible, the core ruby [Dir API](http://ruby-doc.org/core-1.9.3/Dir.html).

There are some examples of how to use the library provided in the examples directory. See the contents of the tests directory for even more.

### What this library can not do yet

The basic requirements of a ZIP Container are all implemented but memory resident ZIP Container files are not yet supported. Presently all operations are performed on files that are resident on disk.

### Developing ZIP Container Ruby Library

Please see our [Code of Conduct](https://github.com/hainesr/ruby-zip-container/blob/main/CODE_OF_CONDUCT.md) and our [contributor guidelines](https://github.com/hainesr/ruby-zip-container/blob/main/CONTRIBUTING.md).

### Licence

[3-Clause BSD Licence](https://opensource.org/license/bsd-3-clause). See LICENCE for details.
