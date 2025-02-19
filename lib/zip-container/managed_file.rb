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

require_relative 'managed_entry'

##
module ZipContainer
  # A ManagedFile is used to reserve a filename in a Container namespace.
  class ManagedFile < ManagedEntry
    # :call-seq:
    #   new(name, required = false, validation_proc = nil) -> ManagedFile
    #
    # Create a new ManagedFile with the supplied name. Options that can
    # be passed in are:
    # * <tt>:required</tt> whether it is required to exist or not (default
    #   false).
    # * <tt>:hidden</tt> whether it is hidden for normal operations.
    # * <tt>:validation_proc</tt> should be a Proc that takes a single
    #   parameter, to which will be supplied the contents of the file, and
    #   returns +true+ or +false+ depending on whether the contents of the
    #   file were validated or not (default nil).
    #
    # For more complex content validation subclasses may override the validate
    # method.
    #
    # The following example creates a ManagedFile that is not required to be
    # present in the container, but if it is, its contents must be the single
    # word "Boo!".
    #
    #  valid = Proc.new { |contents| contents == "Boo!" }
    #  ManagedFile.new("Surprize.txt", required: false,
    #    validation_proc: valid)
    def initialize(name, options = {})
      options = {
        required: false,
        hidden: false,
        validation_proc: nil
      }.merge(options)

      super(name, options[:required], options[:hidden])

      @validation_proc =
        options[:validation_proc].is_a?(Proc) ? options[:validation_proc] : nil
    end

    # :call-seq:
    #   verify -> Array
    #
    # Verify this ManagedFile for correctness. The contents are validated if
    # required.
    #
    # If it does not pass verification a list of reasons why it fails is
    # returned. The empty list is returned if verification passes.
    def verify
      messages = super

      valid = exists? ? validate : true
      unless valid
        messages <<
          "The contents of file '#{full_name}' do not pass validation."
      end

      messages
    end

    protected

    # :call-seq:
    #   validate -> boolean
    #
    # Validate the contents of this ManagedFile. By default this methods uses
    # the validation Proc supplied on object initialization if there is one.
    # If not it simply returns true (no validation was required).
    #
    # For complex validations of content subclasses can override this method.
    def validate
      @validation_proc.nil? ? true : @validation_proc.call(contents)
    end

    private

    # Grab the contents of this ManagedFile
    def contents
      container.read(full_name)
    end
  end
end
