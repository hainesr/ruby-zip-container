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

  # The base of all exceptions raised by this library.
  module ContainerError
  end

  # Shadow Zip::Error so the rubyzip API doesn't leak out.
  ZipError = ::Zip::Error
  ZipError.send(:include, ContainerError)

  # This exception is raised when a bad Container is detected.
  class MalformedContainerError < RuntimeError
    include ContainerError

    # :call-seq:
    #   new(reason = "")
    #
    # Create a new MalformedContainerError with an optional reason for why
    # the Container file is malformed.
    def initialize(reason = nil)
      if reason.nil?
        super("Malformed Container File.")
      else
        super("Malformed Container File: #{reason}")
      end
    end
  end

  # This exception is raised when a clash occurs with a reserved or managed
  # name.
  class ReservedNameClashError < RuntimeError
    include ContainerError

    # :call-seq:
    #   new(name)
    #
    # Create a new ReservedNameClashError with the name of the clash supplied.
    def initialize(name)
      super("'#{name}' is reserved for internal use in this ZipContainer file.")
    end
  end

end
