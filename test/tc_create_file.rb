# Copyright (c) 2013, 2014 The University of Manchester, UK.
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

class TestCreateFile < Test::Unit::TestCase

  # Check creation of standard empty container files.
  def test_create_standard_file
    Dir.mktmpdir do |dir|
      filename = File.join(dir, "test.container")

      assert_nothing_raised do
        ZipContainer::File.create(filename, $mimetype) do |c|
          assert(c.on_disk?)
          refute(c.in_memory?)

          assert(c.find_entry("mimetype").local_header_offset == 0)
        end
      end

      assert_nothing_raised(ZipContainer::MalformedContainerError, ZipContainer::ZipError) do
        ZipContainer::File.verify!(filename)
      end
    end
  end

  # Check creation of empty container files with a different mimetype.
  def test_create_mimetype_file
    mimetype = "application/x-something-really-odd"

    Dir.mktmpdir do |dir|
      filename = File.join(dir, "test.container")

      assert_nothing_raised do
        ZipContainer::File.create(filename, mimetype) do |c|
          assert(c.on_disk?)
          refute(c.in_memory?)

          assert(c.find_entry("mimetype").local_header_offset == 0)
        end
      end

      assert_nothing_raised(ZipContainer::MalformedContainerError, ZipContainer::ZipError) do
        ZipContainer::File.verify!(filename)
      end
    end
  end

  # Check creation of stuff in container files. Check the commit status a few
  # times to ensure that what we expect to happen, happens.
  def test_create_contents_file
    Dir.mktmpdir do |dir|
      filename = File.join(dir, "test.container")

      assert_nothing_raised do
        ZipContainer::File.create(filename, $mimetype) do |c|
          assert(c.on_disk?)
          refute(c.in_memory?)

          c.file.open("test.txt", "w") do |f|
            f.print "testing"
          end

          assert(c.commit_required?)
          assert(c.commit)
          refute(c.commit_required?)
          refute(c.commit)

          c.dir.mkdir("dir1")
          c.mkdir("dir2")

          assert(c.commit_required?)
          assert(c.commit)
          refute(c.commit_required?)
          refute(c.commit)

          c.comment = "A comment!"

          assert(c.commit_required?)
          assert(c.commit)
          refute(c.commit_required?)
          refute(c.commit)
        end
      end

      assert_nothing_raised(ZipContainer::MalformedContainerError, ZipContainer::ZipError) do
        ZipContainer::File.open(filename) do |c|
          assert(c.on_disk?)
          refute(c.in_memory?)

          assert(c.file.exists?("test.txt"))
          assert(c.file.exists?("dir1"))
          assert(c.file.exists?("dir2"))
          refute(c.file.exists?("dir3"))

          text = c.file.read("test.txt")
          assert_equal("testing", text)

          assert_equal("A comment!", c.comment)

          refute(c.commit_required?)
          refute(c.commit)
        end
      end
    end
  end

end
