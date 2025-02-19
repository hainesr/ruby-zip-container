# Changes log for the ZIP Container Ruby Gem

## Version 5.0.0

* Fix warnings about uninitialized instance variables.
* Set ManagedEntries#all_managed_entries to private.
* Add a code of conduct.
* Add contributing guidelines.
* Move to README.md (and update).
* Update minimum ruby version required to 2.7.
* Update RubyZip version to v2.4.
* Ensure 'managed_directory' is required at the top-level.
* Add note README about ruby and RubyZip versions.
* Apply frozen_string_literal magic comment to all files.

### Internal/tooling:

* Update Rake version.
* Update and add metadata in the gemspec.
* Just use a constant for the gem version string.
* Add a script to start IRB with ZipContainer loaded.
* Switch from Coveralls to Simplecov.
* Switch to use minitest for unit tests.
* Switch from Travis CI to GitHub Actions.
* Update Rubocop.
* Skip certain tests in non-POSIX environments.
* Fix managed directory test on Windows.
* Ensure simplecov is required first with MiniTest.

## Version 4.0.2

* Bump rubyzip version again.

## Version 4.0.1

* Don't package test files in the gem.
* Add rubocop configuration.
* Configure and fix many rubocop issues.
* Updated rubyzip to fix vulnerability.

## Version 3.0.2

* Update rubyzip dependency to fix security vulnerability.

## Version 3.0.1

* Fix deep content verification bug.

## Version 3.0.0

* Refactor the malformed container error constructor.
* Verifying entries only raises errors at the last moment.
* Redesign the verification system.
* Update badges to use SVG versions.
* Fix the documentation for updated verify methods.
* Fix Container#verify so that it returns consistent types.
* Rename ContainerError -> Error.
* Reword the exceptions so they don't specify "file".
* Add ruby 2.2.0 to the Travis test matrix.
* Add a compatibility note about ContainerError.
* Improve the Usage information in the ReadMe.

## Version 2.2.0

* Fix pathname bug in ZipContainer::Dir.
* Fixup docs to refer to containers rather than documents.
* Fix the base class in the recursive methods.
* Add an internal compatibility method Dir#entries.
* Add a compatibility method Dir#read.

## Version 2.1.0

* Set up the Container superclass.
* Open the container from the superclass.
* Check and read the mimetype file in the superclass.
* Initialize reserved names and managed entries in the superclass.
* Refactor mimetype verification.
* Move container verification into the superclass.
* Update the example scripts to the new API.
* Move ::open to the Container superclass.
* Move ::verify and ::verify! to the superclass.
* Add the ZipContainer::Dir class.
* Add a test for a mimetype entry that is a directory.
* Add a test for an unreadable mimetype file.
* Update dependencies.
* Disambiguate the two test classes for File and Dir.

## Version 2.0.0

* Change API: Container => File.
* Refactor exceptions so we can shadow rubyzip exceptions.
* Use the shadowed ZipError in the tests.
* Use the shadowed ZipError in the example scripts.
* Update the exceptions to use Zip::Error.
* Refactor managed file and directory initializers.
* Add the new Util module with a helper method.
* Toggle managed files as hidden in normal use.
* Update find_entry to take hidden files into account.
* Fix the managed files and directories lists.
* Update the hidden file detection code.
* Cache managed entry lists.
* Split up the hidden entry/find_entry tests.
* Update get_entry to take hidden files into account.
* Mixin the Util module to the ManagedEntry class.
* Update glob to take hidden files into account.
* Improve Util::entry_name to be more robust.
* Remove old Container compatibility.
* Document removal of ZipContainer::Container in the ReadMe.
* Update rubyzip version to latest (1.1.6).

## Version 1.1.0

* Bump version of rubyzip to 1.1.4.

## Version 1.0.0

* Update to use version 1.0.0 of rubyzip.

## Version 0.9.0

* Generalize the Container Error class names.
* Polish example scripts.

## Version 0.8.0

* Abstract out all the underlying zip functionality and turn this library
  into a basic ZIP Container provider.

## Version 0.5.0

* Add support for managed entries in the container.
* Verify and "optional" functionality for ManagedEntry.
* Use reserved and managed entry mixins for managed directories.
* Better initialization of managed entry support.
* Fix creation of subclassed Container objects.
* Add extra tests for managed entries.
* Make file validation more flexible.
* Fix the source of failing validation messages.

## Version 0.1.0

* Improvements to the reserved names code to allow sub-classing.
* Move exceptions to a new source file.
* Use a base class for UCF exceptions.
* Standardize the MalformedUCFError exception messages.
* Add an exception for clashes with reserved names.
* Implement Container#add to avoid using reserved names.
* Raise an exception if renaming to a reserved name.
* Implement Container#mkdir to avoid using reserved names.
* Make sure testing reserved names copes with trailing slashes.
* Fake up the connection to ZipFileSystem.
* Implement Container#get_output_stream to respect reserved names.
* Can now set comments on the UCF document.
* Implement the close and commit methods.
* Forward the commit_required? method.
* Separate the opening and checking of a UCF document.
* Documentation improvements and cleanup.

## Version 0.0.2

* Update the main ReadMe file.
* Add support for multiple reserved names and fix checks.
* Ensure UCF document is closed after verifying it.
* Expose the "each" method for enumerating UCF entries.
* Expose the "size" method to count UCF entries.
* Add an example program to list UCF contents.
* Add a method to directly iterate over UCF entries.

## Version 0.0.1

* Very basic UCF facilities complete (plus examples).
* Two ways of verifying UCF files.
* API documentation added.
* Add tests.

## About this Changes file

This file is, at least in part, generated by the following command:

```shell
$ git log --pretty=format:"* %s" --reverse --no-merges <commit-hash>..
```
