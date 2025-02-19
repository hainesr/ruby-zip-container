# frozen_string_literal: true

# Copyright (c) 2014-2025 The University of Manchester, UK.
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

require 'zip-container/util'
require 'uri'

class TestUtil < Minitest::Test
  def test_entry_name_strings
    assert_equal('test', ZipContainer::Util.entry_name('test'))
    assert_equal('test', ZipContainer::Util.entry_name('test/'))
    assert_equal('test/test', ZipContainer::Util.entry_name('test/test'))
    assert_equal('test/test', ZipContainer::Util.entry_name('test/test/'))
  end

  def test_entry_name_entries
    assert_equal(
      'test', ZipContainer::Util.entry_name(Zip::Entry.new('fake.zip', 'test'))
    )
    assert_equal(
      'test', ZipContainer::Util.entry_name(Zip::Entry.new('fake.zip', 'test/'))
    )
    assert_equal(
      'test/test', ZipContainer::Util.entry_name(Zip::Entry.new('fake.zip', 'test/test'))
    )
    assert_equal(
      'test/test', ZipContainer::Util.entry_name(Zip::Entry.new('fake.zip', 'test/test/'))
    )
  end

  def test_entry_name_odd_things
    uri = URI.parse('http://www.example.com/path')

    assert_equal(uri, ZipContainer::Util.entry_name(uri))
  end
end
