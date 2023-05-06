# Copyright (c) 2013-2023 The University of Manchester, UK.
#
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
#  * Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
#
#  * Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
#  * Neither the names of The University of Manchester nor the names of its
#    contributors may be used to endorse or promote products derived from this
#    software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# Author: Robert Haines

require_relative 'test_helper'
require 'tmpdir'
require 'zip-container'
require_relative 'helpers/entry_lists'

# Classes to test managed entries.
class ManagedZipContainer < ZipContainer::File
  private_class_method :new

  def initialize(filename)
    super(filename)
    test_file = ZipContainer::ManagedFile.new('test.txt')
    deep_file = ZipContainer::ManagedFile.new('deep.txt')
    deep_dir =
      ZipContainer::ManagedDirectory.new('deep', entries: [deep_file])
    register_managed_entry(
      ZipContainer::ManagedDirectory.new('src', required: true)
    )
    register_managed_entry(
      ZipContainer::ManagedDirectory.new(
        'test', hidden: true, entries: [deep_dir, test_file]
      )
    )
    register_managed_entry(ZipContainer::ManagedDirectory.new('lib'))
    register_managed_entry(ZipContainer::ManagedFile.new('index.html', required: true))
  end
end

class ExampleZipContainer < ZipContainer::File
  private_class_method :new

  def initialize(filename)
    super(filename)
    register_managed_entry(ZipContainer::ManagedDirectory.new('dir', required: true))
    register_managed_entry(ZipContainer::ManagedFile.new('greeting.txt', required: true))
  end
end

class ExampleZipContainer2 < ZipContainer::File
  private_class_method :new

  def initialize(filename)
    super(filename)

    valid = proc { |contents| contents.match(/[Hh]ello/) }
    register_managed_entry(
      ZipContainer::ManagedFile.new(
        'greeting.txt', required: true, validation_proc: valid
      )
    )

    deep_greet =
      ZipContainer::ManagedFile.new('greet.txt', validation_proc: valid)
    register_managed_entry(
      ZipContainer::ManagedDirectory.new('dir', entries: [deep_greet])
    )
  end

  def self.create(filename, &block)
    super(filename, 'application/example+zip', &block)
  end
end

class ExampleDirContainer < ZipContainer::Dir
  private_class_method :new

  def initialize(filename)
    super(filename)

    valid = proc { |contents| contents.match(/[Hh]ello/) }

    test_file = ZipContainer::ManagedFile.new('test.txt')
    register_managed_entry(
      ZipContainer::ManagedDirectory.new(
        'dir', required: true, entries: [test_file]
      )
    )
    register_managed_entry(
      ZipContainer::ManagedFile.new(
        'greeting.txt', required: true, validation_proc: valid
      )
    )
  end
end

class TestManagedEntries < Minitest::Test
  # Check that the example ZipContainer file does not validate as a
  # ManagedZipContainer.
  def test_fail_verification
    refute(ManagedZipContainer.verify?(EXAMPLE_CNTR))

    assert_raises(ZipContainer::MalformedContainerError) do
      ManagedZipContainer.verify!(EXAMPLE_CNTR)
    end
  end

  # Check that the example ZipContainer file does validate as an
  # ExampleZipContainer.
  def test_pass_verification
    assert(ExampleZipContainer.verify?(EXAMPLE_CNTR))
    ExampleZipContainer.verify!(EXAMPLE_CNTR)
  end

  # Check that the example ZipContainer file does validate as an
  # ExampleZipContainer2.
  def test_pass_verification2
    assert(ExampleZipContainer2.verify?(EXAMPLE_CNTR))
    ExampleZipContainer2.verify!(EXAMPLE_CNTR)
  end

  # Check that a standard Container can be created
  def test_create_standard_container
    Dir.mktmpdir do |dir|
      filename = File.join(dir, 'test.container')

      ZipContainer::File.create(filename, MIMETYPE) do |c|
        c.mkdir('META-INF')
        assert(c.file.exists?('META-INF'))

        c.file.open('META-INF/container.xml', 'w') do |f|
          f.puts '<?xml version="1.0"?>'
        end
        assert(c.file.exists?('META-INF/container.xml'))
      end

      ZipContainer::File.verify!(filename)
    end
  end

  # Check that a subclassed container with managed files verifies correctly.
  def test_verify_subclassed_dir_container
    ExampleDirContainer.verify!(DIR_MANAGED)
  end

  # Create a subclassed container. Check it doesn't verify at first; satisfy
  # the conditions; then assert that it verifies correctly.
  def test_create_subclassed_dir_container
    Dir.mktmpdir do |dir|
      filename = File.join(dir, 'test.container')

      ExampleDirContainer.create(filename, MIMETYPE) do |c|
        assert_raises(ZipContainer::MalformedContainerError) do
          c.verify!
        end

        Dir.mkdir(File.join(filename, 'dir'))
        File.open(File.join(filename, 'greeting.txt'), 'w') do |f|
          f.puts 'Yo means hello.'
        end

        c.verify!
      end
    end
  end

  # Check that a ManagedZipContainer does not verify immediately after
  # creation.
  def test_create_bad_subclassed_container
    Dir.mktmpdir do |dir|
      filename = File.join(dir, 'test.container')

      ManagedZipContainer.create(filename, MIMETYPE) do |c|
        assert_raises(ZipContainer::MalformedContainerError) do
          c.verify!
        end
      end

      refute(ManagedZipContainer.verify?(filename))
      assert_raises(ZipContainer::MalformedContainerError) do
        ManagedZipContainer.verify!(filename)
      end
    end
  end

  # Check that a ManagedZipContainer does verify when required objects are
  # added.
  def test_create_subclassed_container
    Dir.mktmpdir do |dir|
      filename = File.join(dir, 'test.container')

      ManagedZipContainer.create(filename, MIMETYPE) do |c|
        c.dir.mkdir('src')
        c.file.open('index.html', 'w') do |f|
          f.puts '<html />'
        end

        # Test hidden entries before and after creation.
        assert_nil(c.find_entry('test', include_hidden: true))
        assert_nil(c.find_entry('test/test.txt', include_hidden: true))
        c.dir.mkdir('test')
        c.file.open('test/test.txt', 'w') do |f|
          f.puts 'A test!'
        end
        refute_nil(c.find_entry('test', include_hidden: true))
        refute_nil(c.find_entry('test/test.txt', include_hidden: true))

        # Test deep hidden entries before and after creation.
        assert_nil(c.find_entry('test/deep', include_hidden: true))
        assert_nil(c.find_entry('test/deep/deep.txt', include_hidden: true))
        c.dir.mkdir('test/deep')
        c.file.open('test/deep/deep.txt', 'w') do |f|
          f.puts 'A deep test!'
        end
        refute_nil(c.find_entry('test/deep', include_hidden: true))
        refute_nil(c.find_entry('test/deep/deep.txt', include_hidden: true))
      end

      assert(ManagedZipContainer.verify?(filename))
      ManagedZipContainer.verify!(filename)
    end
  end

  def test_hidden_entries
    ManagedZipContainer.open(SUBCLASS_CNTR) do |c|
      refute(c.hidden_entry?('src'))
      refute(c.hidden_file?('src'))
      refute(c.hidden_directory?('src'))

      assert(c.hidden_entry?('test'))
      assert(c.hidden_directory?('test'))
      assert(c.hidden_entry?('test/'))
      assert(c.hidden_directory?('test/'))
      refute(c.hidden_file?('test'))

      assert(c.hidden_entry?('test/deep'))
      assert(c.hidden_directory?('test/deep'))
      assert(c.hidden_entry?('test/deep/deep.txt'))
      assert(c.hidden_file?('test/deep/deep.txt'))
    end
  end

  def test_find_entry
    ManagedZipContainer.open(SUBCLASS_CNTR) do |c|
      refute_nil(c.find_entry('src'))
      refute_nil(c.find_entry('src', include_hidden: true))

      assert_nil(c.find_entry('test'))
      assert_nil(c.find_entry('test/test.txt'))
      refute_nil(c.find_entry('test', include_hidden: true))
      refute_nil(c.find_entry('test/test.txt', include_hidden: true))

      assert_nil(c.find_entry('test/deep'))
      assert_nil(c.find_entry('test/deep/deep.txt'))
      refute_nil(c.find_entry('test/deep', include_hidden: true))
      refute_nil(c.find_entry('test/deep/deep.txt', include_hidden: true))
    end
  end

  def test_get_entry
    ManagedZipContainer.open(SUBCLASS_CNTR) do |c|
      c.get_entry('src')
      c.get_entry('src', include_hidden: true)

      assert_raises(Errno::ENOENT) do
        c.get_entry('test')
      end
      assert_raises(Errno::ENOENT) do
        c.get_entry('test/test.txt')
      end

      c.get_entry('test', include_hidden: true)
      c.get_entry('test/test.txt', include_hidden: true)

      assert_raises(Errno::ENOENT) do
        c.get_entry('test/deep')
      end
      assert_raises(Errno::ENOENT) do
        c.get_entry('test/deep/deep.txt')
      end

      c.get_entry('test/deep', include_hidden: true)
      c.get_entry('test/deep/deep.txt', include_hidden: true)
    end
  end

  def test_glob
    ManagedZipContainer.open(SUBCLASS_CNTR) do |c|
      assert_equal(['index.html'], entry_list_names(c.glob('in*')))
      assert_equal([], c.glob('test/**/*'))
      assert_equal(
        ['test/test.txt', 'test/deep', 'test/deep/deep.txt'],
        entry_list_names(c.glob('test/**/*', include_hidden: true))
      )
      assert_equal(
        ['test/test.txt', 'test/deep/deep.txt'],
        entry_list_names(c.glob('**/*.TXT', ::File::FNM_CASEFOLD,
                                include_hidden: true))
      )
    end
  end

  def test_create_subclassed_mimetype
    Dir.mktmpdir do |dir|
      filename = File.join(dir, 'test.container')

      ExampleZipContainer2.create(filename) do |c|
        assert(c.file.exists?('mimetype'))
        assert_equal('application/example+zip', c.file.read('mimetype'))
      end
    end
  end

  # Check that an ExampleZipContainer2 will only verify when required objects
  # are added with the correct contents.
  def test_create_subclassed_container_with_content_verification
    Dir.mktmpdir do |dir|
      filename = File.join(dir, 'test.container')

      ExampleZipContainer2.create(filename) do |c|
        assert_raises(ZipContainer::MalformedContainerError) do
          c.verify!
        end

        c.file.open('greeting.txt', 'w') do |f|
          f.puts 'Goodbye!'
        end

        assert_raises(ZipContainer::MalformedContainerError) do
          c.verify!
        end

        c.file.open('greeting.txt', 'w') do |f|
          f.puts "Hello, Y'All!"
        end

        c.verify!
      end

      assert(ExampleZipContainer2.verify?(filename))
      ExampleZipContainer2.verify!(filename)
    end
  end

  # Check that an ExampleZipContainer2 will verify when deep objects are added
  # with the correct contents.
  def test_create_subclassed_container_with_deep_content_verification
    Dir.mktmpdir do |dir|
      filename = File.join(dir, 'test.container')

      ExampleZipContainer2.create(filename) do |c|
        assert_raises(ZipContainer::MalformedContainerError) do
          c.verify!
        end

        c.file.open('greeting.txt', 'w') do |f|
          f.puts "Hello, Y'All!"
        end

        c.verify!

        c.mkdir('dir')
        c.file.open('dir/greet.txt', 'w') do |f|
          f.puts 'Goodbye!'
        end

        assert_raises(ZipContainer::MalformedContainerError) do
          c.verify!
        end

        c.file.open('dir/greet.txt', 'w') do |f|
          f.puts 'hello everyone.'
        end

        c.verify!
      end

      assert(ExampleZipContainer2.verify?(filename))
      ExampleZipContainer2.verify!(filename)
    end
  end
end
