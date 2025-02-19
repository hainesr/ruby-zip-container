# frozen_string_literal: true

# Copyright (c) 2013-2025 The University of Manchester, UK.
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

##
module ZipContainer
  # ManagedEntry is the superclass of ManagedDirectory and ManagedFile. It
  # should not be used directly but may be subclassed if necessary.
  class ManagedEntry
    # The name of the ManagedEntry. For the full path name of this entry use
    # full_name.
    attr_reader :name

    # Allows the object in which this entry has been registered to tell it
    # who it is.
    attr_writer :parent # :nodoc:

    # :call-seq:
    #   new(name, required) -> ManagedEntry
    #
    # Create a new ManagedEntry with the supplied name. The entry should also
    # be marked as required or not and whether it is hidden for normal
    # operations.
    def initialize(name, required, hidden)
      @parent = nil
      @name = name
      @required = required
      @hidden = hidden
    end

    # :call-seq:
    #   full_name -> string
    #
    # The fully qualified name of this ManagedEntry.
    def full_name
      if @parent.is_a?(ZipContainer::Container)
        @name
      else
        "#{@parent.full_name}/#{@name}"
      end
    end

    # :call-seq:
    #   required? -> true or false
    #
    # Is this ManagedEntry required to be present according to the
    # specification of its Container?
    def required?
      @required
    end

    # :call-seq:
    #   hidden? -> true or false
    #
    # Is this ManagedEntry hidden for normal operations?
    def hidden?
      # An entry is hidden if its parent is hidden.
      if @parent.is_a?(ZipContainer::Container)
        @hidden
      else
        @hidden || @parent.hidden?
      end
    end

    # :call-seq:
    #   exists? -> true or false
    #
    # Does this ManagedEntry exist in the Container?
    def exists?
      container.entries.each do |entry|
        test = entry.ftype == :directory ? "#{full_name}/" : full_name
        return true if entry.name == test
      end

      false
    end

    # :call-seq:
    #   verify -> Array
    #
    # Verify this ManagedEntry returning a list of reasons why it fails if it
    # does so. The empty list is returned if verification passes.
    #
    # Subclasses should override this method if they require more complex
    # verification to be done.
    def verify
      if @required && !exists?
        ["Entry '#{full_name}' is required but missing."]
      else
        []
      end
    end

    # :call-seq:
    #   verify? -> true or false
    #
    # Verify this ManagedEntry by checking that it exists if it is required
    # according to its Container specification and validating its contents if
    # necessary.
    def verify?
      verify.empty?
    end

    # :call-seq:
    #   verify!
    #
    # Verify this ManagedEntry raising a MalformedContainerError if it
    # fails.
    def verify!
      messages = verify
      raise MalformedContainerError, messages unless messages.empty?
    end

    protected

    # :call-seq:
    #   container -> Container
    #
    # Return the Container that this ManagedEntry resides in.
    def container
      @parent.is_a?(ZipContainer::Container) ? @parent : @parent.container
    end
  end
end
