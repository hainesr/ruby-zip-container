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

require 'forwardable'

module ZipContainer

  # This class represents a ZipContainer in directory format. See the
  # {OCF}[http://www.idpf.org/epub/30/spec/epub30-ocf.html] and
  # {UCF}[https://learn.adobe.com/wiki/display/PDFNAV/Universal+Container+Format]
  # specifications for more details.
  #
  # This class provides most of the facilities of the standard <tt>::Dir</tt>
  # class. Please also consult the
  # {ruby Dir documentation}[http://ruby-doc.org/core-1.9.3/Dir.html]
  # alongside these pages.
  #
  # There are code examples available with the source code of this library.
  class Dir < Container

    extend Forwardable
    def_delegators :@container, :close, :each, :path, :pos, :pos=, :rewind,
      :seek, :tell

    private_class_method :new

    # :stopdoc:
    def initialize(location)
      super(location)
    end
    # :startdoc:

    # :call-seq:
    #   create(pathname, mimetype) -> container
    #   create(pathname, mimetype) {|container| ...}
    #
    # Create a new (or convert an existing) directory as a ZipContainer with
    # the specified mimetype.
    def self.create(pathname, mimetype, &block)
      ::Dir.mkdir(pathname) unless ::File.directory?(pathname)
      ::File.write(::File.join(pathname, MIMETYPE_FILE), mimetype)

      # Now open the newly created container.
      c = new(pathname)

      if block_given?
        begin
          yield c
        ensure
          c.close
        end
      end

      c
    end

    # :call-seq:
    #   read
    #   read(path) -> file contents
    #
    # Provides compatibility between directory and zip containers. If called
    # without any parameters it acts like
    # {::Dir.read}[http://ruby-doc.org/core-1.9.3/Dir.html#method-i-read] but
    # if called with a path then it acts like
    # {Zip::File#read}[http://www.rubydoc.info/gems/rubyzip/1.1.6/Zip/File#read-instance_method].
    #
    # Please see the documentation of the relevant method for more details.
    def read(name = nil)
      return @container.read if name.nil?

      ::File.read(full_path(name))
    end

    # :stopdoc:
    # For internal use only!
    # This method and the Entry and Entries classes provide compatibility
    # between zip-style and dir-style entries
    def entries
      Entries.new(@container)
    end

    class Entries

      include Enumerable

      Entry = Struct.new(:name, :ftype)

      def initialize(dir)
        @entries = []

        dir.each do |name|
          type = ::File.directory?(name) ? :directory : :file
          @entries << Entry.new(name, type)
        end
      end

      def each(&block)
        @entries.each do |entry|
          yield entry
        end
      end
    end
    # :startdoc:

    private

    # Prepend the full path of the directory name to whatever is passed in
    # here. This is for internal use to ensure we are always operating on
    # files within our container directory.
    def full_path(path)
      ::File.join(@container.path, path)
    end

    def open_container(location)
      ::Dir.new(location)
    end

    def verify_mimetype
      mime_path = full_path(MIMETYPE_FILE)
      if ::File.exist?(mime_path)
        return "'mimetype' is not a regular file" unless ::File.file?(mime_path)
        return "'mimetype' is not readable." unless ::File.readable?(mime_path)
      else
        return "'mimetype' file is missing."
      end
    end

    def read_mimetype
      ::File.read(full_path(MIMETYPE_FILE))
    end

    public

    # Lots of extra docs out of the way at the end here...

    ##
    # :method: close
    # :call-seq:
    #   close -> nil
    #
    # Equal to
    # {::Dir.close}[http://ruby-doc.org/core-1.9.3/Dir.html#method-i-close]

    ##
    # :method: each
    # :call-seq:
    #   each { |filename| ... } -> dir
    #   each -> an_enumerator
    #
    # Equal to
    # {::Dir.each}[http://ruby-doc.org/core-1.9.3/Dir.html#method-i-each]

    ##
    # :method: path
    # :call-seq:
    #   path -> string or nil
    #
    # Equal to
    # {::Dir.path}[http://ruby-doc.org/core-1.9.3/Dir.html#method-i-path]

    ##
    # :method: pos
    # :call-seq:
    #   pos -> integer
    #
    # Equal to
    # {::Dir.pos}[http://ruby-doc.org/core-1.9.3/Dir.html#method-i-pos]

    ##
    # :method: pos=
    # :call-seq:
    #   pos = integer -> integer
    #
    # Equal to
    # {::Dir.pos=}[http://ruby-doc.org/core-1.9.3/Dir.html#method-i-pos-3D]

    ##
    # :method: rewind
    # :call-seq:
    #   rewind -> dir
    #
    # Equal to
    # {::Dir.rewind}[http://ruby-doc.org/core-1.9.3/Dir.html#method-i-rewind]

    ##
    # :method: seek
    # :call-seq:
    #   seek(integer) -> dir
    #
    # Equal to
    # {::Dir.seek}[http://ruby-doc.org/core-1.9.3/Dir.html#method-i-seek]

    ##
    # :method: tell
    # :call-seq:
    #   tell -> integer
    #
    # Equal to
    # {::Dir.tell}[http://ruby-doc.org/core-1.9.3/Dir.html#method-i-tell]
  end

end
