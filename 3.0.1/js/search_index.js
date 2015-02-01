var search_data = {"index":{"searchIndex":["zipcontainer","container","dir","entries","error","file","malformedcontainererror","manageddirectory","managedentries","managedentry","managedfile","reservednameclasherror","reservednames","util","version","add()","close()","close()","comment()","comment=()","commit()","commit_required?()","container()","create()","create()","dir()","each()","each()","each_entry()","entries()","entry_name()","exists?()","extract()","file()","find_entry()","full_name()","get_entry()","get_input_stream()","get_output_stream()","glob()","hidden?()","hidden_directory?()","hidden_entry?()","hidden_file?()","in_memory?()","initialize_managed_entries()","managed_directories()","managed_directory?()","managed_directory_names()","managed_entries()","managed_entry?()","managed_entry_names()","managed_file?()","managed_file_names()","managed_files()","mkdir()","name()","new()","new()","new()","new()","new()","on_disk?()","open()","path()","pos()","pos=()","read()","read()","register_managed_entry()","register_reserved_name()","remove()","rename()","replace()","required?()","reserved_entry?()","reserved_names()","rewind()","seek()","size()","tell()","to_s()","validate()","verify()","verify()","verify()","verify()","verify()","verify!()","verify!()","verify!()","verify?()","verify?()","verify?()","verify_managed_entries()","verify_managed_entries!()","changes","licence","readme"],"longSearchIndex":["zipcontainer","zipcontainer::container","zipcontainer::dir","zipcontainer::dir::entries","zipcontainer::error","zipcontainer::file","zipcontainer::malformedcontainererror","zipcontainer::manageddirectory","zipcontainer::managedentries","zipcontainer::managedentry","zipcontainer::managedfile","zipcontainer::reservednameclasherror","zipcontainer::reservednames","zipcontainer::util","zipcontainer::version","zipcontainer::file#add()","zipcontainer::dir#close()","zipcontainer::file#close()","zipcontainer::file#comment()","zipcontainer::file#comment=()","zipcontainer::file#commit()","zipcontainer::file#commit_required?()","zipcontainer::managedentry#container()","zipcontainer::dir::create()","zipcontainer::file::create()","zipcontainer::file#dir()","zipcontainer::dir#each()","zipcontainer::file#each()","zipcontainer::file::each_entry()","zipcontainer::file#entries()","zipcontainer::util#entry_name()","zipcontainer::managedentry#exists?()","zipcontainer::file#extract()","zipcontainer::file#file()","zipcontainer::file#find_entry()","zipcontainer::managedentry#full_name()","zipcontainer::file#get_entry()","zipcontainer::file#get_input_stream()","zipcontainer::file#get_output_stream()","zipcontainer::file#glob()","zipcontainer::managedentry#hidden?()","zipcontainer::managedentries#hidden_directory?()","zipcontainer::managedentries#hidden_entry?()","zipcontainer::managedentries#hidden_file?()","zipcontainer::file#in_memory?()","zipcontainer::managedentries#initialize_managed_entries()","zipcontainer::managedentries#managed_directories()","zipcontainer::managedentries#managed_directory?()","zipcontainer::managedentries#managed_directory_names()","zipcontainer::managedentries#managed_entries()","zipcontainer::managedentries#managed_entry?()","zipcontainer::managedentries#managed_entry_names()","zipcontainer::managedentries#managed_file?()","zipcontainer::managedentries#managed_file_names()","zipcontainer::managedentries#managed_files()","zipcontainer::file#mkdir()","zipcontainer::file#name()","zipcontainer::malformedcontainererror::new()","zipcontainer::manageddirectory::new()","zipcontainer::managedentry::new()","zipcontainer::managedfile::new()","zipcontainer::reservednameclasherror::new()","zipcontainer::file#on_disk?()","zipcontainer::container::open()","zipcontainer::dir#path()","zipcontainer::dir#pos()","zipcontainer::dir#pos=()","zipcontainer::dir#read()","zipcontainer::file#read()","zipcontainer::managedentries#register_managed_entry()","zipcontainer::reservednames#register_reserved_name()","zipcontainer::file#remove()","zipcontainer::file#rename()","zipcontainer::file#replace()","zipcontainer::managedentry#required?()","zipcontainer::reservednames#reserved_entry?()","zipcontainer::reservednames#reserved_names()","zipcontainer::dir#rewind()","zipcontainer::dir#seek()","zipcontainer::file#size()","zipcontainer::dir#tell()","zipcontainer::file#to_s()","zipcontainer::managedfile#validate()","zipcontainer::container#verify()","zipcontainer::container::verify()","zipcontainer::manageddirectory#verify()","zipcontainer::managedentry#verify()","zipcontainer::managedfile#verify()","zipcontainer::container::verify!()","zipcontainer::container#verify!()","zipcontainer::managedentry#verify!()","zipcontainer::container::verify?()","zipcontainer::container#verify?()","zipcontainer::managedentry#verify?()","zipcontainer::managedentries#verify_managed_entries()","zipcontainer::managedentries#verify_managed_entries!()","","",""],"info":[["ZipContainer","","ZipContainer.html","","<p>This is a ruby library to read and write ZIP Container Format files. See\nthe ZipContainer::Container …\n"],["ZipContainer::Container","","ZipContainer/Container.html","","<p>The superclass of anything that represents a Zip Container. That\nrepresentation could be as a Zip file …\n"],["ZipContainer::Dir","","ZipContainer/Dir.html","","<p>This class represents a ZipContainer in directory format. See the OCF and\nUCF specifications for more …\n"],["ZipContainer::Dir::Entries","","ZipContainer/Dir/Entries.html","",""],["ZipContainer::Error","","ZipContainer/Error.html","","<p>The base of all exceptions raised by this library.\n"],["ZipContainer::File","","ZipContainer/File.html","","<p>This class represents a ZipContainer file in PK Zip format. See the OCF and\nUCF specifications for more …\n"],["ZipContainer::MalformedContainerError","","ZipContainer/MalformedContainerError.html","","<p>This exception is raised when a bad Container is detected.\n"],["ZipContainer::ManagedDirectory","","ZipContainer/ManagedDirectory.html","","<p>A ManagedDirectory acts as the interface to a set of (possibly) managed\nfiles within it and also reserves …\n"],["ZipContainer::ManagedEntries","","ZipContainer/ManagedEntries.html","","<p>This module provides support for managed file and directory entries.\n<p><strong>Note!</strong> If you mix this module in you ...\n"],["ZipContainer::ManagedEntry","","ZipContainer/ManagedEntry.html","","<p>ManagedEntry is the superclass of ManagedDirectory and ManagedFile. It\nshould not be used directly but …\n"],["ZipContainer::ManagedFile","","ZipContainer/ManagedFile.html","","<p>A ManagedFile is used to reserve a filename in a Container namespace.\n"],["ZipContainer::ReservedNameClashError","","ZipContainer/ReservedNameClashError.html","","<p>This exception is raised when a clash occurs with a reserved or managed\nname.\n"],["ZipContainer::ReservedNames","","ZipContainer/ReservedNames.html","","<p>This module provides support for reserved names.\n"],["ZipContainer::Util","","ZipContainer/Util.html","","<p>Utility methods useful throughout the rest of the ZipContainer library.\n"],["ZipContainer::Version","","ZipContainer/Version.html","","<p>Library version information.\n"],["add","ZipContainer::File","ZipContainer/File.html#method-i-add","(entry, src_path, &continue_on_exists_proc)","<p>Convenience method for adding the contents of a file to the ZipContainer\nfile. If asked to add a file …\n"],["close","ZipContainer::Dir","ZipContainer/Dir.html#method-i-close","","<p>Equal to ::Dir.close\n"],["close","ZipContainer::File","ZipContainer/File.html#method-i-close","()",""],["comment","ZipContainer::File","ZipContainer/File.html#method-i-comment","","<p>Returns the ZipContainer file comment, if it has one.\n"],["comment=","ZipContainer::File","ZipContainer/File.html#method-i-comment-3D","","<p>Set the ZipContainer file comment to the new value.\n"],["commit","ZipContainer::File","ZipContainer/File.html#method-i-commit","()","<p>Commits changes that have been made since the previous commit to the\nZipContainer file. Returns <code>true</code> …\n"],["commit_required?","ZipContainer::File","ZipContainer/File.html#method-i-commit_required-3F","","<p>Returns <code>true</code> if any changes have been made to this\nZipContainer file since the last commit, <code>false</code> otherwise. …\n"],["container","ZipContainer::ManagedEntry","ZipContainer/ManagedEntry.html#method-i-container","()","<p>Return the Container that this ManagedEntry resides in.\n"],["create","ZipContainer::Dir","ZipContainer/Dir.html#method-c-create","(pathname, mimetype, &block)","<p>Create a new (or convert an existing) directory as a ZipContainer with the\nspecified mimetype.\n"],["create","ZipContainer::File","ZipContainer/File.html#method-c-create","(filename, mimetype, &block)","<p>Create a new ZipContainer file on disk with the specified mimetype.\n"],["dir","ZipContainer::File","ZipContainer/File.html#method-i-dir","()","<p>Returns an object which can be used like ruby’s built in <code>Dir</code>\n(class) object, except that it works on …\n"],["each","ZipContainer::Dir","ZipContainer/Dir.html#method-i-each","","<p>Equal to ::Dir.each\n"],["each","ZipContainer::File","ZipContainer/File.html#method-i-each","","<p>Iterate over the entries in the ZipContainer file. The entry objects\nreturned by this method are Zip::Entry …\n"],["each_entry","ZipContainer::File","ZipContainer/File.html#method-c-each_entry","(filename, &block)","<p>Iterate over the entries in the ZipContainer file. The entry objects\nreturned by this method are Zip::Entry …\n"],["entries","ZipContainer::File","ZipContainer/File.html#method-i-entries","","<p>Returns an Enumerable containing all the entries in the ZipContainer file\nThe entry objects returned …\n"],["entry_name","ZipContainer::Util","ZipContainer/Util.html#method-i-entry_name","(entry)","<p>A lot of methods can take either a String or a Zip::Entry object to\nrepresent an item in a Zip file so …\n"],["exists?","ZipContainer::ManagedEntry","ZipContainer/ManagedEntry.html#method-i-exists-3F","()","<p>Does this ManagedEntry exist in the Container?\n"],["extract","ZipContainer::File","ZipContainer/File.html#method-i-extract","","<p>Extracts the specified entry of the ZipContainer file to\n<code>dest_path</code>.\n<p>See the rubyzip documentation for …\n"],["file","ZipContainer::File","ZipContainer/File.html#method-i-file","()","<p>Returns an object which can be used like ruby’s built in <code>File</code>\n(class) object, except that it works on …\n"],["find_entry","ZipContainer::File","ZipContainer/File.html#method-i-find_entry","(entry_name, options = {})","<p>Searches for the entry with the specified name. Returns <code>nil</code> if\nno entry is found or if the specified …\n"],["full_name","ZipContainer::ManagedEntry","ZipContainer/ManagedEntry.html#method-i-full_name","()","<p>The fully qualified name of this ManagedEntry.\n"],["get_entry","ZipContainer::File","ZipContainer/File.html#method-i-get_entry","(entry, options = {})","<p>Searches for an entry like find_entry, but throws Errno::ENOENT if no entry\nis found or if the specified …\n"],["get_input_stream","ZipContainer::File","ZipContainer/File.html#method-i-get_input_stream","","<p>Returns an input stream to the specified entry. If a block is passed the\nstream object is passed to the …\n"],["get_output_stream","ZipContainer::File","ZipContainer/File.html#method-i-get_output_stream","(entry, permission = nil, &block)","<p>Returns an output stream to the specified entry. If a block is passed the\nstream object is passed to …\n"],["glob","ZipContainer::File","ZipContainer/File.html#method-i-glob","(pattern, *params, &block)","<p>Searches for entries given a glob. Hidden files are ignored by default.\n<p>The parameters that can be supplied …\n"],["hidden?","ZipContainer::ManagedEntry","ZipContainer/ManagedEntry.html#method-i-hidden-3F","()","<p>Is this ManagedEntry hidden for normal operations?\n"],["hidden_directory?","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-hidden_directory-3F","(entry)","<p>Is the supplied entry/name a hidden directory?\n"],["hidden_entry?","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-hidden_entry-3F","(entry)","<p>Is the supplied entry/name a hidden?\n"],["hidden_file?","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-hidden_file-3F","(entry)","<p>Is the supplied entry/name a hidden file?\n"],["in_memory?","ZipContainer::File","ZipContainer/File.html#method-i-in_memory-3F","()","<p>Is this ZipContainer file memory resident as opposed to stored on disk?\n"],["initialize_managed_entries","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-initialize_managed_entries","(entries = [])","<p>Initialize the managed entries and register any that are supplied. A single\nManagedFile or ManagedDirectory …\n"],["managed_directories","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-managed_directories","()","<p>Return the list of managed directories.\n"],["managed_directory?","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-managed_directory-3F","(entry)","<p>Is the supplied entry/name a managed directory?\n"],["managed_directory_names","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-managed_directory_names","()","<p>Return the list of managed directory names.\n"],["managed_entries","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-managed_entries","()","<p>Return the list of managed files and directories.\n"],["managed_entry?","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-managed_entry-3F","(entry, list = managed_entry_names)","<p>Is the supplied entry/name a managed entry?\n"],["managed_entry_names","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-managed_entry_names","()","<p>Return the list of managed file and directory names.\n"],["managed_file?","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-managed_file-3F","(entry)","<p>Is the supplied entry/name a managed file?\n"],["managed_file_names","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-managed_file_names","()","<p>Return the list of managed file names.\n"],["managed_files","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-managed_files","()","<p>Return the list of managed files.\n"],["mkdir","ZipContainer::File","ZipContainer/File.html#method-i-mkdir","(name, permission = 0755)","<p>Creates a directory in the ZipContainer file. If asked to create a\ndirectory with a name reserved for …\n"],["name","ZipContainer::File","ZipContainer/File.html#method-i-name","","<p>Returns the filename of this ZipContainer file.\n"],["new","ZipContainer::MalformedContainerError","ZipContainer/MalformedContainerError.html#method-c-new","(reason = nil)","<p>Create a new MalformedContainerError with an optional reason or list of\nreasons for why the Container …\n"],["new","ZipContainer::ManagedDirectory","ZipContainer/ManagedDirectory.html#method-c-new","(name, options = {})","<p>Create a new ManagedDirectory with the supplied name. Options that can be\npassed in are:\n<p><code>:required</code> whether ...\n"],["new","ZipContainer::ManagedEntry","ZipContainer/ManagedEntry.html#method-c-new","(name, required, hidden)","<p>Create a new ManagedEntry with the supplied name. The entry should also be\nmarked as required or not …\n"],["new","ZipContainer::ManagedFile","ZipContainer/ManagedFile.html#method-c-new","(name, options = {})","<p>Create a new ManagedFile with the supplied name. Options that can be passed\nin are:\n<p><code>:required</code> whether ...\n"],["new","ZipContainer::ReservedNameClashError","ZipContainer/ReservedNameClashError.html#method-c-new","(name)","<p>Create a new ReservedNameClashError with the name of the clash supplied.\n"],["on_disk?","ZipContainer::File","ZipContainer/File.html#method-i-on_disk-3F","()","<p>Is this ZipContainer file stored on disk as opposed to memory resident?\n"],["open","ZipContainer::Container","ZipContainer/Container.html#method-c-open","(filename, &block)","<p>Open an existing ZipContainer. It will be checked for conformance upon\nfirst access.\n"],["path","ZipContainer::Dir","ZipContainer/Dir.html#method-i-path","","<p>Equal to ::Dir.path\n"],["pos","ZipContainer::Dir","ZipContainer/Dir.html#method-i-pos","","<p>Equal to ::Dir.pos\n"],["pos=","ZipContainer::Dir","ZipContainer/Dir.html#method-i-pos-3D","","<p>Equal to ::Dir.pos=\n"],["read","ZipContainer::Dir","ZipContainer/Dir.html#method-i-read","(name = nil)","<p>Provides compatibility between directory and zip containers. If called\nwithout any parameters it acts …\n"],["read","ZipContainer::File","ZipContainer/File.html#method-i-read","","<p>Returns a string containing the contents of the specified entry.\n"],["register_managed_entry","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-register_managed_entry","(entry)","<p>Register a ManagedFile or ManagedDirectory.\n<p>A ManagedFile is used to reserve the name of a file in the …\n"],["register_reserved_name","ZipContainer::ReservedNames","ZipContainer/ReservedNames.html#method-i-register_reserved_name","(name)","<p>Add a reserved name to the list.\n"],["remove","ZipContainer::File","ZipContainer/File.html#method-i-remove","(entry)","<p>Removes the specified entry from the ZipContainer file. If asked to remove\nany reserved files such as …\n"],["rename","ZipContainer::File","ZipContainer/File.html#method-i-rename","(entry, new_name, &continue_on_exists_proc)","<p>Renames the specified entry in the ZipContainer file. If asked to rename\nany reserved files such as the …\n"],["replace","ZipContainer::File","ZipContainer/File.html#method-i-replace","(entry, src_path)","<p>Replaces the specified entry of the ZipContainer file with the contents of\n<code>src_path</code> (from the file system). …\n"],["required?","ZipContainer::ManagedEntry","ZipContainer/ManagedEntry.html#method-i-required-3F","()","<p>Is this ManagedEntry required to be present according to the specification\nof its Container?\n"],["reserved_entry?","ZipContainer::ReservedNames","ZipContainer/ReservedNames.html#method-i-reserved_entry-3F","(entry)","<p>Is the given entry in the reserved list of names? A String or a Zip::Entry\nobject can be passed in here. …\n"],["reserved_names","ZipContainer::ReservedNames","ZipContainer/ReservedNames.html#method-i-reserved_names","()","<p>Return a list of reserved file and directory names for this ZipContainer\nfile.\n<p>Reserved files and directories …\n"],["rewind","ZipContainer::Dir","ZipContainer/Dir.html#method-i-rewind","","<p>Equal to ::Dir.rewind\n"],["seek","ZipContainer::Dir","ZipContainer/Dir.html#method-i-seek","","<p>Equal to ::Dir.seek\n"],["size","ZipContainer::File","ZipContainer/File.html#method-i-size","","<p>Returns the number of entries in the ZipContainer file.\n"],["tell","ZipContainer::Dir","ZipContainer/Dir.html#method-i-tell","","<p>Equal to ::Dir.tell\n"],["to_s","ZipContainer::File","ZipContainer/File.html#method-i-to_s","()","<p>Return a textual summary of this ZipContainer file.\n"],["validate","ZipContainer::ManagedFile","ZipContainer/ManagedFile.html#method-i-validate","()","<p>Validate the contents of this ManagedFile. By default this methods uses the\nvalidation Proc supplied …\n"],["verify","ZipContainer::Container","ZipContainer/Container.html#method-i-verify","()","<p>Verify the contents of this ZipContainer file. All managed files and\ndirectories are checked to make …\n"],["verify","ZipContainer::Container","ZipContainer/Container.html#method-c-verify","(filename)","<p>Verify that the specified ZipContainer conforms to the specification. This\nmethod returns a list of problems …\n"],["verify","ZipContainer::ManagedDirectory","ZipContainer/ManagedDirectory.html#method-i-verify","()","<p>Verify this ManagedDirectory for correctness. ManagedFiles registered\nwithin it are verified recursively. …\n"],["verify","ZipContainer::ManagedEntry","ZipContainer/ManagedEntry.html#method-i-verify","()","<p>Verify this ManagedEntry returning a list of reasons why it fails if it\ndoes so. The empty list is returned …\n"],["verify","ZipContainer::ManagedFile","ZipContainer/ManagedFile.html#method-i-verify","()","<p>Verify this ManagedFile for correctness. The contents are validated if\nrequired.\n<p>If it does not pass verification …\n"],["verify!","ZipContainer::Container","ZipContainer/Container.html#method-c-verify-21","(filename)","<p>Verify that the specified ZipContainer conforms to the specification. This\nmethod raises exceptions when …\n"],["verify!","ZipContainer::Container","ZipContainer/Container.html#method-i-verify-21","()","<p>Verify the contents of this ZipContainer file. All managed files and\ndirectories are checked to make …\n"],["verify!","ZipContainer::ManagedEntry","ZipContainer/ManagedEntry.html#method-i-verify-21","()","<p>Verify this ManagedEntry raising a MalformedContainerError if it fails.\n"],["verify?","ZipContainer::Container","ZipContainer/Container.html#method-c-verify-3F","(filename)","<p>Verify that the specified ZipContainer conforms to the specification. This\nmethod returns <code>false</code> if there …\n"],["verify?","ZipContainer::Container","ZipContainer/Container.html#method-i-verify-3F","()","<p>Verify the contents of this ZipContainer file. All managed files and\ndirectories are checked to make …\n"],["verify?","ZipContainer::ManagedEntry","ZipContainer/ManagedEntry.html#method-i-verify-3F","()","<p>Verify this ManagedEntry by checking that it exists if it is required\naccording to its Container specification …\n"],["verify_managed_entries","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-verify_managed_entries","()","<p>All managed files and directories are checked to make sure that they exist\nand validate, if required. …\n"],["verify_managed_entries!","ZipContainer::ManagedEntries","ZipContainer/ManagedEntries.html#method-i-verify_managed_entries-21","()","<p>All managed files and directories are checked to make sure that they exist\nand validate, if required. …\n"],["Changes","","Changes_rdoc.html","","<p>Changes log for the ZIP Container Ruby Gem\n<p>Version 3.0.1\n<p>Fix deep content verification bug.\n"],["Licence","","Licence_rdoc.html","","<p>Copyright © 2013-2015 The University of Manchester, UK.\n<p>All rights reserved.\n<p>Redistribution and use in …\n"],["ReadMe","","ReadMe_rdoc.html","","<p>ZIP Container Format Ruby Library\n<p>Authors &mdash; Robert Haines\n<p>Contact &mdash; support@mygrid.org.uk\n"]]}}