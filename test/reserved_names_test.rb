# Copyright (c) 2013-2024 The University of Manchester, UK.
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

require 'zip-container/errors'
require 'zip-container/file'
require 'zip-container/managed_directory'
require 'zip-container/managed_file'

# A class to test the overriding of reserved and managed names.
class NewZipContainer < ZipContainer::File
  private_class_method :new

  def initialize(filename)
    super(filename)
    register_managed_entry(ZipContainer::ManagedDirectory.new('src'))
    register_managed_entry(ZipContainer::ManagedDirectory.new('test'))
    register_managed_entry(ZipContainer::ManagedDirectory.new('lib'))
    register_managed_entry(ZipContainer::ManagedFile.new('index.html'))
    register_managed_entry(ZipContainer::ManagedFile.new('greeting.txt'))

    register_reserved_name('META-INF')
    register_reserved_name('reserved_dir')
  end
end

class TestReservedNames < Minitest::Test
  # Check that the reserved names verify correctly.
  def test_verify_reserved_name
    assert(NewZipContainer.verify?(EXAMPLE_CNTR))
    NewZipContainer.verify!(EXAMPLE_CNTR)
  end

  # Check the reserved names stuff all works correctly, baring in mind that
  # such comparisons for ZipContainer file should be case sensitive.
  def test_reserved_names
    ZipContainer::File.open(EXAMPLE_CNTR) do |c|
      assert_equal(1, c.reserved_names.length)
      assert_equal(['mimetype'], c.reserved_names)

      assert_equal(0, c.managed_files.length)
      assert_empty(c.managed_file_names)
      assert(c.reserved_entry?('mimetype'))
      assert(c.reserved_entry?('mimetype/'))
      assert(c.reserved_entry?('MimeType'))

      assert_equal(0, c.managed_directories.length)
      assert_empty(c.managed_directory_names)
      refute(c.reserved_entry?('META-INF'))

      assert_equal(0, c.managed_entries.length)
      assert_empty(c.managed_entry_names)
      refute(c.managed_entry?('This_should_fail'))
    end
  end

  # Check that overriding the reserved names in a sub-class works correctly
  def test_subclass_reserved_names
    NewZipContainer.open(EXAMPLE_CNTR) do |c|
      assert_equal(3, c.reserved_names.length)
      assert_equal(
        ['mimetype', 'META-INF', 'reserved_dir'], c.reserved_names
      )

      assert_equal(2, c.managed_files.length)
      assert_equal(['index.html', 'greeting.txt'], c.managed_file_names)
      assert(c.reserved_entry?('mimetype'))
      assert(c.reserved_entry?('mimetype/'))
      assert(c.reserved_entry?('MimeType'))
      assert(c.managed_entry?('index.html'))
      assert(c.managed_entry?('Index.HTML'))
      refute(c.reserved_entry?('index.html'))

      assert_equal(3, c.managed_directories.length)
      assert_equal(%w[src test lib], c.managed_directory_names)
      assert(c.managed_entry?('src'))
      assert(c.managed_entry?('SRC'))
      assert(c.managed_entry?('test'))
      assert(c.managed_entry?('lib'))
      assert(c.managed_entry?('lIb/'))
      refute(c.managed_entry?('META-INF'))
      assert(c.reserved_entry?('META-INF'))
      refute(c.reserved_entry?('src'))
      refute(c.reserved_entry?('test'))
      refute(c.reserved_entry?('lib'))

      assert_equal(5, c.managed_entries.length)
      assert_equal(
        ['index.html', 'greeting.txt', 'src', 'test', 'lib'],
        c.managed_entry_names
      )

      refute(c.managed_entry?('This_should_fail'))
      refute(c.reserved_entry?('META_INF'))
      refute(c.reserved_entry?('META_INF/'))
      refute(c.managed_entry?('index.htm'))
      refute(c.reserved_entry?('index.html'))
    end
  end

  # Check that nothing happens when trying to delete the mimetype file.
  def test_delete_mimetype
    ZipContainer::File.open(EXAMPLE_CNTR) do |c|
      assert(c.file.exists?('mimetype'))
      assert_nil(c.remove('mimetype'))
      assert(c.file.exists?('mimetype'))
    end
  end

  # Check that nothing happens when trying to rename the mimetype file.
  def test_rename_mimetype
    ZipContainer::File.open(EXAMPLE_CNTR) do |c|
      assert(c.file.exists?('mimetype'))
      assert_nil(c.rename('mimetype', 'something-else'))
      assert(c.file.exists?('mimetype'))
      refute(c.file.exists?('something-else'))
    end
  end

  # Check that nothing happens when trying to replace the contents of the
  # mimetype file.
  def test_replace_mimetype
    ZipContainer::File.open(EXAMPLE_CNTR) do |c|
      assert(c.file.exists?('mimetype'))
      assert_nil(c.replace('mimetype', EMPTY_ZIP))
      assert_equal('application/epub+zip', c.file.read('mimetype'))
    end
  end

  # Check that an error is raised when trying to add file with a reserved
  # name.
  def test_add_reserved
    ZipContainer::File.open(EMPTY_CNTR) do |c|
      assert_raises(ZipContainer::ReservedNameClashError) do
        c.add('mimetype', EMPTY_ZIP)
      end
    end
  end

  # Check that an error is raised when trying to add file with a reserved
  # name to a subclassed container.
  def test_subclass_add_reserved
    NewZipContainer.open(EMPTY_CNTR) do |c|
      assert_raises(ZipContainer::ReservedNameClashError) do
        c.add('mimetype', EMPTY_ZIP)
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.add('reserved_dir', EMPTY_ZIP)
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.add('MimeType', EMPTY_ZIP)
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.add('Reserved_Dir', EMPTY_ZIP)
      end
    end
  end

  # Check that the META-INF directory is detected as non-existent when trying
  # to delete it.
  def test_delete_metainf
    ZipContainer::File.open(EXAMPLE_CNTR) do |c|
      assert_raises(Errno::ENOENT) do
        c.remove('META-INF')
      end
    end
  end

  # Check that the META-INF directory is detected as non-existent when trying
  # to rename it.
  def test_rename_metainf
    ZipContainer::File.open(EXAMPLE_CNTR) do |c|
      assert_raises(Errno::ENOENT) do
        c.rename('META-INF', 'something-else')
      end
    end
  end

  # Check that an error is raised when trying to create a directory with a
  # reserved name.
  def test_mkdir_reserved
    ZipContainer::File.open(EMPTY_CNTR) do |c|
      assert_raises(ZipContainer::ReservedNameClashError) do
        c.mkdir('mimetype')
      end
    end
  end

  # Check that an error is raised when trying to create a directory with a
  # reserved name in a subclassed container.
  def test_subclass_mkdir_reserved
    NewZipContainer.open(EMPTY_CNTR) do |c|
      assert_raises(ZipContainer::ReservedNameClashError) do
        c.mkdir('mimetype')
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.mkdir('index.html')
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.mkdir('reserved_dir')
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.mkdir('Reserved_Dir')
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.mkdir('META-INF')
      end
    end
  end

  # Check that a file cannot be renamed to one of the reserved names.
  def test_rename_to_reserved
    ZipContainer::File.open(EXAMPLE_CNTR) do |c|
      assert_raises(ZipContainer::ReservedNameClashError) do
        c.rename('dir/code.rb', 'mimetype')
      end
    end
  end

  # Check that a file cannot be renamed to one of the reserved names in a
  # subclassed container.
  def test_subclass_rename_to_reserved
    NewZipContainer.open(EXAMPLE_CNTR) do |c|
      assert_raises(ZipContainer::ReservedNameClashError) do
        c.rename('dir/code.rb', 'mimetype')
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.rename('dir', 'reserved_dir')
      end
    end
  end

  # Check that the ruby-like File and Dir classes respect reserved and managed
  # names.
  def test_file_dir_ops_reserved
    ZipContainer::File.open(EMPTY_CNTR) do |c|
      assert_raises(ZipContainer::ReservedNameClashError) do
        c.file.open('mimetype', 'w') do |f|
          f.puts 'TESTING'
        end
      end

      c.file.open('mimetype') do |f|
        assert_equal('application/epub+zip', f.read)
      end

      c.file.delete('mimetype')

      assert(c.file.exists?('mimetype'))
    end
  end

  # Check that the ruby-like File and Dir classes respect reserved names in a
  # subclassed container.
  def test_subclass_file_dir_ops_reserved
    NewZipContainer.open(EMPTY_CNTR) do |c|
      assert_raises(ZipContainer::ReservedNameClashError) do
        c.file.open('META-INF', 'w') do |f|
          f.puts 'TESTING'
        end
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.file.open('TEST', 'w') do |f|
          f.puts 'TESTING'
        end
      end

      c.file.open('mimetype') do |f|
        assert_equal('application/epub+zip', f.read)
      end

      c.file.delete('mimetype')

      assert(c.file.exists?('mimetype'))

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.dir.mkdir('index.html')
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.dir.mkdir('reserved_dir')
      end

      assert_raises(ZipContainer::ReservedNameClashError) do
        c.dir.mkdir('Reserved_Dir')
      end
    end
  end
end
