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

#
module ZipContainer

  # The superclass of anything that represents a Zip Container. That
  # representation could be as a Zip file (most commonly), as a directory or
  # something else.
  class Container
    include ReservedNames
    include ManagedEntries

    private_class_method :new

    # The mime-type of this ZipContainer.
    attr_reader :mimetype

    # :stopdoc:
    # The reserved mimetype file name for standard ZipContainers.
    MIMETYPE_FILE = "mimetype"

    def initialize(location)
      @container = open_container(location)

      check_mimetype!
      @mimetype = read_mimetype

      # Reserved entry names. Just the mimetype file by default.
      register_reserved_name(MIMETYPE_FILE)

      # Initialize the managed entry tables.
      initialize_managed_entries
    end
    # :startdoc:

    # :call-seq:
    #   open(filename) -> container
    #   open(filename) {|container| ...}
    #
    # Open an existing ZipContainer. It will be checked for conformance upon
    # first access.
    def self.open(filename, &block)
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
    #   verify(filename) -> boolean
    #
    # Verify that the specified ZipContainer conforms to the specification.
    # This method returns +false+ if there are any problems at all with the
    # container (including if it cannot be found).
    def self.verify(filename)
      begin
        new(filename).verify!
      rescue
        return false
      end

      true
    end

    # :call-seq:
    #   verify!(filename)
    #
    # Verify that the specified ZipContainer conforms to the specification.
    # This method raises exceptions when errors are found or if there is
    # something fundamental wrong with the container itself (e.g. it cannot be
    # found).
    def self.verify!(filename)
      new(filename).verify!
    end

    # :call-seq:
    #   verify!
    #
    # Verify the contents of this ZipContainer file. All managed files and
    # directories are checked to make sure that they exist, if required.
    def verify!
      verify_managed_entries!
    end

    private

    def check_mimetype!
      message = verify_mimetype
      raise MalformedContainerError.new(message) unless message.nil?
    end

  end

end
