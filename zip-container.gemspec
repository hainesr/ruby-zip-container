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

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "zip-container/version"

Gem::Specification.new do |s|
  s.name             = "zip-container"
  s.version          = ZipContainer::Version::STRING
  s.authors          = ["Robert Haines"]
  s.email            = ["support@mygrid.org.uk"]
  s.homepage         = "http://mygrid.github.io/ruby-zip-container/"
  s.platform         = Gem::Platform::RUBY
  s.summary          = "A ZIP Container for use by OCF and UCF implementations"
  s.description      = "A Ruby library for working with ZIP Container "\
    "Format files. See http://www.idpf.org/epub/30/spec/epub30-ocf.html for "\
    "the OCF specification and "\
    "https://learn.adobe.com/wiki/display/PDFNAV/Universal+Container+Format "\
    "for the UCF specification."
  s.license          = "BSD"
  s.require_path     = "lib"
  s.files            = `git ls-files`.split($/)
  s.test_files       = `git ls-files -- test/*`.split($/)
  s.has_rdoc         = true
  s.extra_rdoc_files = [ "Changes.rdoc", "Licence.rdoc", "ReadMe.rdoc" ]
  s.rdoc_options     = [ "-N", "--tab-width=2", "--main=ReadMe.rdoc" ]
  s.required_ruby_version = ">= 1.9.3"
  s.add_development_dependency("rake", "~> 10.0.4")
  s.add_development_dependency("bundler", "~> 1.5")
  s.add_development_dependency("rdoc", "~> 4.0.1")
  s.add_development_dependency('coveralls')
  s.add_runtime_dependency("rubyzip", "~> 1.1.6")
end

