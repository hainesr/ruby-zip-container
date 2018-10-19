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

require 'forwardable'

module ZipContainer

  # This class represents a ZipContainer file in PK Zip format. See the
  # {OCF}[http://www.idpf.org/epub/30/spec/epub30-ocf.html] and
  # {UCF}[https://learn.adobe.com/wiki/display/PDFNAV/Universal+Container+Format]
  # specifications for more details.
  #
  # This class provides most of the facilities of the <tt>Zip::File</tt>
  # class in the rubyzip gem. Please also consult the
  # {rubyzip documentation}[http://rubydoc.info/gems/rubyzip/1.1.0/frames]
  # alongside these pages.
  #
  # There are code examples available with the source code of this library.
  class File < Container

    extend Forwardable
    def_delegators :@container, :comment, :comment=, :commit_required?, :each,
                   :entries, :extract, :get_input_stream, :name, :read, :size

    private_class_method :new

    # :stopdoc:
    def initialize(location)
      super(location)

      @on_disk = true

      # Here we fake up the connection to the rubyzip filesystem classes so
      # that they also respect the reserved names that we define.
      mapped_zip = ::Zip::FileSystem::ZipFileNameMapper.new(self)
      @fs_dir  = ::Zip::FileSystem::ZipFsDir.new(mapped_zip)
      @fs_file = ::Zip::FileSystem::ZipFsFile.new(mapped_zip)
      @fs_dir.file = @fs_file
      @fs_file.dir = @fs_dir
    end
    # :startdoc:

    # :call-seq:
    #   File.create(filename, mimetype) -> container
    #   File.create(filename, mimetype) {|container| ...}
    #
    # Create a new ZipContainer file on disk with the specified mimetype.
    def self.create(filename, mimetype)
      ::Zip::OutputStream.open(filename) do |stream|
        stream.put_next_entry(MIMETYPE_FILE, nil, nil, ::Zip::Entry::STORED)
        stream.write mimetype
      end

      # Now open the newly created container.
      c = new(filename)

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
    #   File.each_entry {|entry| ...}
    #
    # Iterate over the entries in the ZipContainer file. The entry objects
    # returned by this method are Zip::Entry objects. Please see the
    # rubyzip documentation for details.
    def self.each_entry(filename, &block)
      c = new(filename)

      begin
        c.each(&block)
      ensure
        c.close
      end
    end

    # :call-seq:
    #   add(entry, src_path, &continue_on_exists_proc)
    #
    # Convenience method for adding the contents of a file to the ZipContainer
    # file. If asked to add a file with a reserved name, such as the special
    # mimetype header file, this method will raise a
    # ReservedNameClashError.
    #
    # See the rubyzip documentation for details of the
    # +continue_on_exists_proc+ parameter.
    def add(entry, src_path, &continue_on_exists_proc)
      if reserved_entry?(entry) || managed_directory?(entry)
        raise ReservedNameClashError, entry.to_s
      end

      @container.add(entry, src_path, &continue_on_exists_proc)
    end

    # :call-seq:
    #   commit -> boolean
    #   close -> boolean
    #
    # Commits changes that have been made since the previous commit to the
    # ZipContainer file. Returns +true+ if anything was actually done, +false+
    # otherwise.
    def commit
      return false unless commit_required?

      @container.commit if on_disk?
    end

    alias close commit

    # :call-seq:
    #   dir -> Zip::ZipFsDir
    #
    # Returns an object which can be used like ruby's built in +Dir+ (class)
    # object, except that it works on the ZipContainer file on which this
    # method is invoked.
    #
    # See the rubyzip documentation for details.
    def dir
      @fs_dir
    end

    # :call-seq:
    #   file -> Zip::ZipFsFile
    #
    # Returns an object which can be used like ruby's built in +File+ (class)
    # object, except that it works on the ZipContainer file on which this
    # method is invoked.
    #
    # See the rubyzip documentation for details.
    def file
      @fs_file
    end

    # :call-seq:
    #   find_entry(entry_name, options = {}) -> Zip::Entry or nil
    #
    # Searches for the entry with the specified name. Returns +nil+ if no
    # entry is found or if the specified entry is hidden for normal use. You
    # can specify <tt>:include_hidden => true</tt> to include hidden entries
    # in the search.
    def find_entry(entry_name, options = {})
      options = { include_hidden: false }.merge(options)

      unless options[:include_hidden]
        return if hidden_entry?(entry_name)
      end

      @container.find_entry(entry_name)
    end

    # :call-seq:
    #   get_entry(entry, options = {}) -> Zip::Entry or nil
    #
    # Searches for an entry like find_entry, but throws Errno::ENOENT if no
    # entry is found or if the specified entry is hidden for normal use. You
    # can specify <tt>:include_hidden => true</tt> to include hidden entries
    # in the search.
    def get_entry(entry, options = {})
      options = { include_hidden: false }.merge(options)

      unless options[:include_hidden]
        raise Errno::ENOENT, entry if hidden_entry?(entry)
      end

      @container.get_entry(entry)
    end

    # :call-seq:
    #   get_output_stream(entry, permission = nil) -> stream
    #   get_output_stream(entry, permission = nil) {|stream| ...}
    #
    # Returns an output stream to the specified entry. If a block is passed
    # the stream object is passed to the block and the stream is automatically
    # closed afterwards just as with ruby's built-in +File.open+ method.
    #
    # See the rubyzip documentation for details of the +permission_int+
    # parameter.
    def get_output_stream(entry, permission = nil, &block)
      if reserved_entry?(entry) || managed_directory?(entry)
        raise ReservedNameClashError, entry.to_s
      end

      @container.get_output_stream(entry, permission, &block)
    end

    # :call-seq:
    #   glob(pattern) -> Array
    #   glob(pattern) { |entry| ... }
    #   glob(pattern, *parameters) -> Array
    #   glob(pattern, *parameters) { |entry| ... }
    #
    # Searches for entries given a glob. Hidden files are ignored by default.
    #
    # The parameters that can be supplied are:
    # * +flags+ - A bitwise OR of the <tt>FNM_xxx</tt> parameters defined in
    #   File::Constants. The default value is
    #   <tt>::File::FNM_PATHNAME | ::File::FNM_DOTMATCH</tt>
    # * +options+ - <tt>:include_hidden => true</tt> will include hidden
    #   entries in the search.
    def glob(pattern, *params)
      flags = ::File::FNM_PATHNAME | ::File::FNM_DOTMATCH
      options = { include_hidden: false }

      params.each do |param|
        case param
        when Hash
          options = options.merge(param)
        else
          flags = param
        end
      end

      entries.map do |entry|
        next if !options[:include_hidden] && hidden_entry?(entry)
        next unless ::File.fnmatch(pattern, entry.name.chomp('/'), flags)

        yield(entry) if block_given?
        entry
      end.compact
    end

    # :call-seq:
    #   in_memory? -> boolean
    #
    # Is this ZipContainer file memory resident as opposed to stored on disk?
    def in_memory?
      !@on_disk
    end

    # :call-seq:
    #   mkdir(name, permission = 0755)
    #
    # Creates a directory in the ZipContainer file. If asked to create a
    # directory with a name reserved for use by a file this method will raise
    # a ReservedNameClashError.
    #
    # The new directory will be created with the supplied unix-style
    # permissions. The default (+0755+) is owner read, write and list; group
    # read and list; and world read and list.
    def mkdir(name, permission = 0o0755)
      if reserved_entry?(name) || managed_file?(name)
        raise ReservedNameClashError, name
      end

      @container.mkdir(name, permission)
    end

    # :call-seq:
    #   on_disk? -> boolean
    #
    # Is this ZipContainer file stored on disk as opposed to memory resident?
    def on_disk?
      @on_disk
    end

    # :call-seq:
    #   remove(entry)
    #
    # Removes the specified entry from the ZipContainer file. If asked to
    # remove any reserved files such as the special mimetype header file this
    # method will do nothing.
    def remove(entry)
      return if reserved_entry?(entry)

      @container.remove(entry)
    end

    # :call-seq:
    #   rename(entry, new_name, &continue_on_exists_proc)
    #
    # Renames the specified entry in the ZipContainer file. If asked to rename
    # any reserved files such as the special mimetype header file this method
    # will do nothing. If asked to rename a file _to_ one of the reserved
    # names a ReservedNameClashError is raised.
    #
    # See the rubyzip documentation for details of the
    # +continue_on_exists_proc+ parameter.
    def rename(entry, new_name, &continue_on_exists_proc)
      return if reserved_entry?(entry)
      raise ReservedNameClashError, new_name if reserved_entry?(new_name)

      @container.rename(entry, new_name, &continue_on_exists_proc)
    end

    # :call-seq:
    #   replace(entry, src_path)
    #
    # Replaces the specified entry of the ZipContainer file with the contents
    # of +src_path+ (from the file system). If asked to replace any reserved
    # files such as the special mimetype header file this method will do
    # nothing.
    def replace(entry, src_path)
      return if reserved_entry?(entry)

      @container.replace(entry, src_path)
    end

    # :call-seq:
    #   to_s -> String
    #
    # Return a textual summary of this ZipContainer file.
    def to_s
      @container.to_s + " - #{@mimetype}"
    end

    private

    def open_container(document)
      ::Zip::File.new(document)
    end

    def verify_mimetype
      # Check mimetype file is present and correct.
      entry = @container.find_entry(MIMETYPE_FILE)

      return "'mimetype' file is missing." if entry.nil?
      if entry.local_header_offset != 0
        return "'mimetype' file is not at offset 0 in the archive."
      end
      if entry.compression_method != ::Zip::Entry::STORED
        return "'mimetype' file is compressed."
      end
    end

    def read_mimetype
      @container.read(MIMETYPE_FILE)
    end

    public

    # Lots of extra docs out of the way at the end here...

    ##
    # :method: comment
    # :call-seq:
    #   comment -> String
    #
    # Returns the ZipContainer file comment, if it has one.

    ##
    # :method: comment=
    # :call-seq:
    #   comment = comment
    #
    # Set the ZipContainer file comment to the new value.

    ##
    # :method: commit_required?
    # :call-seq:
    #   commit_required? -> boolean
    #
    # Returns +true+ if any changes have been made to this ZipContainer file
    # since the last commit, +false+ otherwise.

    ##
    # :method: each
    # :call-seq:
    #   each -> Enumerator
    #   each {|entry| ...}
    #
    # Iterate over the entries in the ZipContainer file. The entry objects
    # returned by this method are Zip::Entry objects. Please see the
    # rubyzip documentation for details.

    ##
    # :method: entries
    # :call-seq:
    #   entries -> Enumerable
    #
    # Returns an Enumerable containing all the entries in the ZipContainer
    # file The entry objects returned by this method are Zip::Entry
    # objects. Please see the rubyzip documentation for details.

    ##
    # :method: extract
    # :call-seq:
    #   extract(entry, dest_path, &on_exists_proc)
    #
    # Extracts the specified entry of the ZipContainer file to +dest_path+.
    #
    # See the rubyzip documentation for details of the +on_exists_proc+
    # parameter.

    ##
    # :method: find_entry
    # :call-seq:
    #   find_entry(entry) -> Zip::Entry
    #
    # Searches for entries within the ZipContainer file with the specified
    # name. Returns +nil+ if no entry is found. See also +get_entry+.

    ##
    # :method: get_entry
    # :call-seq:
    #   get_entry(entry) -> Zip::Entry
    #
    # Searches for an entry within the ZipContainer file in a similar manner
    # to +find_entry+, but throws +Errno::ENOENT+ if no entry is found.

    ##
    # :method: get_input_stream
    # :call-seq:
    #   get_input_stream(entry) -> stream
    #   get_input_stream(entry) {|stream| ...}
    #
    # Returns an input stream to the specified entry. If a block is passed the
    # stream object is passed to the block and the stream is automatically
    # closed afterwards just as with ruby's built in +File.open+ method.

    ##
    # :method: glob
    # :call-seq:
    #   glob(*args) -> Array of Zip::Entry
    #   glob(*args) {|entry| ...}
    #
    # Searches for entries within the ZipContainer file that match the given
    # glob.
    #
    # See the rubyzip documentation for details of the parameters that can be
    # passed in.

    ##
    # :method: name
    # :call-seq:
    #   name -> String
    #
    # Returns the filename of this ZipContainer file.

    ##
    # :method: read
    # :call-seq:
    #   read(entry) -> String
    #
    # Returns a string containing the contents of the specified entry.

    ##
    # :method: size
    # :call-seq:
    #   size -> int
    #
    # Returns the number of entries in the ZipContainer file.
  end
end
