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

require 'coveralls'
Coveralls.wear!

$LOAD_PATH.unshift ::File.expand_path('../lib', __dir__)
require 'zip-container'

require 'minitest/autorun'

# Example default mimetype
TEST_MIMETYPE = 'application/epub+zip'.freeze

# Example data files
DIR_NULL = 'test/data/dirs/null'.freeze
DIR_EMPTY = 'test/data/dirs/empty'.freeze
DIR_DIR_MIMETYPE = 'test/data/dirs/dir-mimetype'.freeze
DIR_MANAGED = 'test/data/dirs/managed'.freeze
FILE_NULL = 'test/data/null.file'.freeze
EMPTY_CONT = 'test/data/empty.container'.freeze
EMPTY_ZIP = 'test/data/empty.zip'.freeze
COMPRESSED_MIMETYPE = 'test/data/compressed_mimetype.container'.freeze
BAD_MIMETYPE_OFFSET = 'test/data/bad_mimetype_offset.container'.freeze
EXAMPLE = 'test/data/example.container'.freeze
SUBCLASS = 'test/data/subclassed.container'.freeze
