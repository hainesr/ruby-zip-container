# Copyright (c) 2013 The University of Manchester, UK.
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

require 'test/unit'
require 'tmpdir'
require 'zip-container'

# Classes to test managed entries.
class ManagedZipContainer < ZipContainer::File

  private_class_method :new

  def initialize(filename)
    super(filename)
    register_managed_entry(ZipContainer::ManagedDirectory.new("src", :required => true))
    register_managed_entry(ZipContainer::ManagedDirectory.new("test", :hidden => true))
    register_managed_entry(ZipContainer::ManagedDirectory.new("lib"))
    register_managed_entry(ZipContainer::ManagedFile.new("index.html", :required => true))
  end

end

class ExampleZipContainer < ZipContainer::File

  private_class_method :new

  def initialize(filename)
    super(filename)
    register_managed_entry(ZipContainer::ManagedDirectory.new("dir", :required => true))
    register_managed_entry(ZipContainer::ManagedFile.new("greeting.txt", :required => true))
  end

end

class ExampleZipContainer2 < ZipContainer::File

  private_class_method :new

  def initialize(filename)
    super(filename)

    valid = Proc.new { |contents| contents.match(/[Hh]ello/) }
    register_managed_entry(ZipContainer::ManagedFile.new("greeting.txt",
      :required => true, :validation_proc => valid))
  end

  def ExampleZipContainer2.create(filename, &block)
    super(filename, "application/example+zip", &block)
  end

end

class TestManagedEntries < Test::Unit::TestCase

  # Check that the example ZipContainer file does not validate as a
  # ManagedZipContainer.
  def test_fail_verification
    refute(ManagedZipContainer.verify($example))

    assert_raises(ZipContainer::MalformedContainerError) do
      ManagedZipContainer.verify!($example)
    end
  end

  # Check that the example ZipContainer file does validate as an
  # ExampleZipContainer.
  def test_pass_verification
    assert(ExampleZipContainer.verify($example))

    assert_nothing_raised(ZipContainer::MalformedContainerError) do
      ExampleZipContainer.verify!($example)
    end
  end

  # Check that the example ZipContainer file does validate as an
  # ExampleZipContainer2.
  def test_pass_verification_2
    assert(ExampleZipContainer2.verify($example))

    assert_nothing_raised(ZipContainer::MalformedContainerError) do
      ExampleZipContainer2.verify!($example)
    end
  end

  # Check that a standard Container can be created
  def test_create_standard_container
    Dir.mktmpdir do |dir|
      filename = File.join(dir, "test.container")

      assert_nothing_raised do
        ZipContainer::File.create(filename, $mimetype) do |c|
          c.mkdir("META-INF")
          assert(c.file.exists?("META-INF"))

          c.file.open("META-INF/container.xml", "w") do |f|
            f.puts "<?xml version=\"1.0\"?>"
          end
          assert(c.file.exists?("META-INF/container.xml"))
        end
      end

      assert_nothing_raised(ZipContainer::MalformedContainerError) do
        ZipContainer::File.verify!(filename)
      end
    end
  end

  # Check that a ManagedZipContainer does not verify immediately after
  # creation.
  def test_create_bad_subclassed_container
    Dir.mktmpdir do |dir|
      filename = File.join(dir, "test.container")

      assert_nothing_raised do
        ManagedZipContainer.create(filename, $mimetype) do |c|
          assert_raises(ZipContainer::MalformedContainerError) do
            c.verify!
          end
        end
      end

      refute(ManagedZipContainer.verify(filename))
      assert_raises(ZipContainer::MalformedContainerError) do
        ManagedZipContainer.verify!(filename)
      end
    end
  end

  # Check that a ManagedZipContainer does verify when required objects are
  # added.
  def test_create_subclassed_container
    Dir.mktmpdir do |dir|
      filename = File.join(dir, "test.container")

      assert_nothing_raised do
        ManagedZipContainer.create(filename, $mimetype) do |c|
          c.dir.mkdir("src")
          c.file.open("index.html", "w") do |f|
            f.puts "<html />"
          end

          # Test hidden entries
          refute(c.hidden_entry?("src"))
          refute(c.hidden_file?("src"))
          refute(c.hidden_directory?("src"))
          assert(c.hidden_entry?("test"))
          assert(c.hidden_directory?("test"))
          assert(c.hidden_entry?("test/"))
          assert(c.hidden_directory?("test/"))
          refute(c.hidden_file?("test"))
        end
      end

      assert(ManagedZipContainer.verify(filename))
      assert_nothing_raised(ZipContainer::MalformedContainerError) do
        ManagedZipContainer.verify!(filename)
      end
    end
  end

  def test_create_subclassed_mimetype
    Dir.mktmpdir do |dir|
      filename = File.join(dir, "test.container")

      assert_nothing_raised do
        ExampleZipContainer2.create(filename) do |c|
          assert(c.file.exists?("mimetype"))
          assert_equal("application/example+zip", c.file.read("mimetype"))
        end
      end
    end
  end

  # Check that a ExampleZipContainer2 will only verify when required objects
  # are added with the correct contents.
  def test_create_subclassed_container_with_content_verification
    Dir.mktmpdir do |dir|
      filename = File.join(dir, "test.container")

      assert_nothing_raised do
        ExampleZipContainer2.create(filename) do |c|
          assert_raises(ZipContainer::MalformedContainerError) do
            c.verify!
          end

          c.file.open("greeting.txt", "w") do |f|
            f.puts "Goodbye!"
          end

          assert_raises(ZipContainer::MalformedContainerError) do
            c.verify!
          end

          c.file.open("greeting.txt", "w") do |f|
            f.puts "Hello, Y'All!"
          end

          assert_nothing_raised(ZipContainer::MalformedContainerError) do
            c.verify!
          end
        end
      end

      assert(ExampleZipContainer2.verify(filename))
      assert_nothing_raised(ZipContainer::MalformedContainerError) do
        ExampleZipContainer2.verify!(filename)
      end
    end
  end

end
