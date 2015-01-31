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

require 'test/unit'
require 'zip-container'

class TestExceptions < Test::Unit::TestCase

  def test_rescue_container_errors
    assert_raise(ZipContainer::Error) do
      raise ZipContainer::ZipError.new
    end

    assert_raise(ZipContainer::Error) do
      raise ZipContainer::MalformedContainerError.new
    end

    assert_raise(ZipContainer::Error) do
      raise ZipContainer::ReservedNameClashError.new("test")
    end

    assert_raise(ZipContainer::Error) do
      raise Zip::ZipError.new
    end
  end

  def test_malformed_container_error_nil
    mce = nil

    assert_nothing_raised do
      mce = ZipContainer::MalformedContainerError.new(nil)
    end

    refute mce.message.empty?
    refute mce.message.include?(':')
  end

  def test_malformed_container_error_empty_string
    mce = nil

    assert_nothing_raised do
      mce = ZipContainer::MalformedContainerError.new("")
    end

    refute mce.message.empty?
    refute mce.message.include?(':')
  end

  def test_malformed_container_error_string
    mce = nil
    message = "test"

    assert_nothing_raised do
      mce = ZipContainer::MalformedContainerError.new(message)
    end

    refute mce.message.empty?
    assert mce.message.include?(':')
    assert mce.message.include?(message)
  end

  def test_malformed_container_error_list
    mce = nil
    message = %w(test1 test2)

    assert_nothing_raised do
      mce = ZipContainer::MalformedContainerError.new(message)
    end

    refute mce.message.empty?
    assert mce.message.include?(':')
    assert mce.message.include?(' * test1')
    assert mce.message.include?(' * test2')
  end

end
