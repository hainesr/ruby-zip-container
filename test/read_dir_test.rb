# Copyright (c) 2014 The University of Manchester, UK.
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

require 'test_helper'
require 'tmpdir'

class TestReadDir < MiniTest::Test

  # Check that the empty directory does not verify.
  def test_verify_empty_directory
    assert_raises(ZipContainer::MalformedContainerError) do
      ZipContainer::Dir.verify!(DIR_NULL)
    end

    refute(ZipContainer::Dir.verify(DIR_NULL).empty?)
    refute(ZipContainer::Dir.verify?(DIR_NULL))
  end

  # Check that the empty container directory does verify.
  def test_verify_empty_container
    ZipContainer::Dir.verify!(DIR_EMPTY)

    assert(ZipContainer::Dir.verify(DIR_EMPTY).empty?)
    assert(ZipContainer::Dir.verify?(DIR_EMPTY))
  end

  # Check that a mimetype entry that is a directory does not verify.
  def test_verify_mimetype_directory
    assert_raises(ZipContainer::MalformedContainerError) do
      ZipContainer::Dir.verify!(DIR_DIR_MIMETYPE)
    end

    refute(ZipContainer::Dir.verify(DIR_DIR_MIMETYPE).empty?)
    refute(ZipContainer::Dir.verify?(DIR_DIR_MIMETYPE))
  end

  # Check that a mimetype which is not readable does not verify. We have to
  # build this fixture programmatically as there's no way to add a file
  # without read permissions into git.
  def test_verify_unreadable_mimetype
    Dir.mktmpdir do |dir|
      container = File.join(dir, 'unreadable.container')
      Dir.mkdir(container)
      mime_path = File.join(container, ZipContainer::Container::MIMETYPE_FILE)
      File.open(mime_path, 'w') { |file| file.write 'MIMETYPE' }
      File.chmod(0o0000, mime_path)

      refute File.readable?(mime_path)
      assert_raises(ZipContainer::MalformedContainerError) do
        ZipContainer::Dir.verify!(container)
      end

      refute(ZipContainer::Dir.verify(container).empty?)
      refute(ZipContainer::Dir.verify?(container))
    end
  end
end
