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

#
module ZipContainer

  # This module provides support for managed file and directory entries.
  #
  # <b>Note!</b> If you mix this module in you *must* call
  # +initialize_managed_entries+ in your constructor to ensure that the
  # internal lists of managed entries are correctly assigned.
  module ManagedEntries
    include Util

    # :call-seq:
    #   managed_directories -> Array
    #
    # Return the list of managed directories.
    def managed_directories
      dirs = @directories.values
      dirs + dirs.map { |d| d.managed_directories }.flatten
    end

    # :call-seq:
    #   managed_directory_names -> Array
    #
    # Return the list of managed directory names.
    def managed_directory_names
      managed_directories.map { |d| d.full_name }
    end

    # :call-seq:
    #   managed_directory?(entry) -> boolean
    #
    # Is the supplied entry/name a managed directory?
    def managed_directory?(entry)
      managed_entry?(entry, managed_directory_names)
    end

    # :call-seq:
    #   managed_entries -> Array
    #
    # Return the list of managed files and directories.
    def managed_entries
      managed_files + managed_directories
    end

    # :call-seq:
    #   managed_entry_names -> Array
    #
    # Return the list of managed file and directory names.
    def managed_entry_names
      managed_file_names + managed_directory_names
    end

    # :call-seq:
    #   managed_entry?(entry) -> boolean
    #
    # Is the supplied entry/name a managed entry?
    def managed_entry?(entry, list = managed_entry_names)
      name = entry_name(entry)
      list.map { |n| n.downcase }.include? name.downcase
    end

    # :call-seq:
    #   managed_file?(entry) -> boolean
    #
    # Is the supplied entry/name a managed file?
    def managed_file?(entry)
      managed_entry?(entry, managed_file_names)
    end

    # :call-seq:
    #   hidden_directory?(entry) -> boolean
    #
    # Is the supplied entry/name a hidden directory?
    def hidden_directory?(entry)
      name = entry_name(entry)
      managed_directory?(name) ? all_managed_entries[name].hidden? : false
    end

    # :call-seq:
    #   hidden_file?(entry) -> boolean
    #
    # Is the supplied entry/name a hidden file?
    def hidden_file?(entry)
      name = entry_name(entry)
      managed_file?(name) ? all_managed_entries[name].hidden? : false
    end

    # :call-seq:
    #   hidden_entry?(entry) -> boolean
    #
    # Is the supplied entry/name a hidden?
    def hidden_entry?(entry)
      hidden_directory?(entry) || hidden_file?(entry)
    end

    # :call-seq:
    #   managed_files -> Array
    #
    # Return the list of managed files.
    def managed_files
      @files.values + @directories.values.map { |d| d.managed_files }.flatten
    end

    # :call-seq:
    #   managed_file_names -> Array
    #
    # Return the list of managed file names.
    def managed_file_names
      managed_files.map { |f| f.full_name }
    end

    # :call-seq:
    #   verify_managed_entries!
    #
    # All managed files and directories are checked to make sure that they
    # exist, if required.
    def verify_managed_entries!
      @directories.each_value do |dir|
        dir.verify!
      end

      @files.each_value do |file|
        file.verify!
      end

      true
    end

    protected

    # :call-seq:
    #   initialize_managed_entries
    #   initialize_managed_entries(entry)
    #   initialize_managed_entries(entries)
    #
    # Initialize the managed entries and register any that are supplied. A
    # single ManagedFile or ManagedDirectory or a list of them can be
    # provided.
    def initialize_managed_entries(entries = [])
      list = [*entries]
      @directories ||= {}
      @files ||= {}

      list.each { |item| register_managed_entry(item) }
    end

    # :call-seq:
    #   register_managed_entry(entry)
    #
    # Register a ManagedFile or ManagedDirectory.
    #
    # A ManagedFile is used to reserve the name of a file in the container
    # namespace and can describe how to verify the contents of it if required.
    #
    # A ManagedDirectory is used to both reserve the name of a directory in
    # the container namespace and act as an interface to the (possibly)
    # managed files within it.
    def register_managed_entry(entry)
      unless entry.is_a?(ManagedDirectory) || entry.is_a?(ManagedFile)
        raise ArgumentError.new("The supplied entry must be of type "\
          "ManagedDirectory or ManagedFile or a subclass of either.")
      end

      entry.parent = self
      @directories[entry.name] = entry if entry.is_a? ManagedDirectory
      @files[entry.name] = entry if entry.is_a? ManagedFile
    end

    # :stopdoc:
    def all_managed_entries
      return @entries unless @entries.nil?

      all = {}
      managed_entries.each { |e| all[e.full_name] = e }
      @entries = all
    end
    # :startdoc:

  end
end
