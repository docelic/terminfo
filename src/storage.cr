require "baked_file_system"

class Terminfo
  module Storage
    extend BakedFileSystem
    bake_folder "../filesystem/"

    # Checks whether *term* exists in the module's built-in storage.
    def self.has_internal?(term) !! get? term end

    # Retrieves *term* from module's built-in storage.
    #
    # It returns BakedFileSystem::BakedFile. To read full contents,
    # call `#read` on the object.
    def self.get_internal(term) get term end

    # Retrieves *term* from module's built-in storage or nil if
    # it is not found.
    #
    # It returns BakedFileSystem::BakedFile. To read full contents,
    # call `#read` on the object.
    def self.get_internal?(term) get? term end
  end
end
