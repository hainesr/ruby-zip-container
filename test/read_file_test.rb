# frozen_string_literal: true

# Copyright (c) 2013-2025 The University of Manchester, UK.
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

require 'zip-container/file'

class TestReadFile < Minitest::Test
  # Check that the null file does not verify.
  def test_verify_null_file
    assert_raises(ZipContainer::ZipError) do
      ZipContainer::File.verify(FILE_NULL)
    end

    assert_raises(ZipContainer::ZipError) do
      ZipContainer::File.verify!(FILE_NULL)
    end

    assert_raises(ZipContainer::ZipError) do
      ZipContainer::File.verify?(FILE_NULL)
    end
  end

  # Check that the empty container file does verify.
  def test_verify_empty_container
    ZipContainer::File.verify!(EMPTY_CNTR)

    assert_predicate(ZipContainer::File.verify(EMPTY_CNTR), :empty?)
    assert(ZipContainer::File.verify?(EMPTY_CNTR))
  end

  # Check that the empty zip file does not verify.
  def test_verify_empty_zip
    assert_raises(ZipContainer::MalformedContainerError) do
      ZipContainer::File.verify!(EMPTY_ZIP)
    end

    refute_predicate(ZipContainer::File.verify(EMPTY_ZIP), :empty?)
    refute(ZipContainer::File.verify?(EMPTY_ZIP))
  end

  # Check that a compressed mimetype file is detected.
  def test_verify_compressed_mimetype
    assert_raises(ZipContainer::MalformedContainerError) do
      ZipContainer::File.verify!(COMPRESSED_MIMETYPE)
    end

    refute_predicate(ZipContainer::File.verify(COMPRESSED_MIMETYPE), :empty?)
    refute(ZipContainer::File.verify?(COMPRESSED_MIMETYPE))
  end

  # Check the raw mimetype bytes
  def test_raw_mimetypes
    empty_container = File.read(EMPTY_CNTR)
    compressed_mimetype = File.read(COMPRESSED_MIMETYPE)

    assert_equal('application/epub+zip', empty_container[38..57])
    refute_equal('application/epub+zip', compressed_mimetype[38..57])
  end

  # Check reading files out of a container file and make sure we don't change
  # it.
  def test_read_files_from_container
    ZipContainer::File.open(EXAMPLE_CNTR) do |c|
      assert_predicate(c, :on_disk?)
      refute_predicate(c, :in_memory?)

      assert(c.file.exists?('greeting.txt'))

      greeting = c.file.read('greeting.txt')

      assert_equal("Hello, World!\n", greeting)

      assert(c.file.exists?('dir'))
      assert(c.file.directory?('dir'))
      assert(c.file.exists?('dir/code.rb'))

      assert_equal('This is an example Container file!', c.comment)

      refute_predicate(c, :commit_required?)
      refute(c.commit)
    end
  end
end
