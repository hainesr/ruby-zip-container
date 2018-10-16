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

# Example default mimetype
$mimetype = 'application/epub+zip'

# Example data files
$dir_null = 'test/data/dirs/null'
$dir_empty = 'test/data/dirs/empty'
$dir_dir_mimetype = 'test/data/dirs/dir-mimetype'
$dir_managed = 'test/data/dirs/managed'
$file_null = 'test/data/null.file'
$empty = 'test/data/empty.container'
$empty_zip = 'test/data/empty.zip'
$compressed_mimetype = 'test/data/compressed_mimetype.container'
$example = 'test/data/example.container'
$subclass = 'test/data/subclassed.container'

# Run test cases.
require 'tc_util'
require 'tc_exceptions'
require 'tc_create_dir'
require 'tc_create_file'
require 'tc_read_dir'
require 'tc_read_file'
require 'tc_reserved_names'
require 'tc_managed_entries'
