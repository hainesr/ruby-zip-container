# Copyright (c) 2013-2015 The University of Manchester, UK.
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
  # A ManagedDirectory acts as the interface to a set of (possibly) managed
  # files within it and also reserves the directory name in the Container
  # namespace.
  #
  # Once a ManagedDirectory is registered in a Container then only it can be
  # used to write to its contents.
  class ManagedDirectory < ManagedEntry
    include ReservedNames
    include ManagedEntries

    # :call-seq:
    #   new(name, options = {}) -> ManagedDirectory
    #
    # Create a new ManagedDirectory with the supplied name. Options that can
    # be passed in are:
    # * <tt>:required</tt> whether it is required to exist or not (default
    #   false).
    # * <tt>:hidden</tt> whether it is hidden for normal operations.
    # * <tt>:entries</tt> a list of ManagedFile and ManagedDirectory objects
    #   that are within this directory (default []).
    def initialize(name, options = {})
      options = {
        required: false,
        hidden: false,
        entries: []
      }.merge(options)

      super(name, options[:required], options[:hidden])

      initialize_managed_entries(options[:entries])
    end

    # :call-seq:
    #   verify -> Array
    #
    # Verify this ManagedDirectory for correctness. ManagedFiles registered
    # within it are verified recursively.
    #
    # If it does not pass verification a list of reasons why it fails is
    # returned. The empty list is returned if verification passes.
    def verify
      messages = super

      @files.each_value { |f| messages += f.verify }

      messages
    end
  end
end
