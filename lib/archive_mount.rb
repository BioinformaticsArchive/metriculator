#!/usr/bin/env ruby

# System dependent locations
if ENV["HOME"][/\/home\//] == '/home/'
	Orbi_drive = "#{ENV["HOME"]}/chem/orbitrap/"
	Jtp_drive = "#{ENV["HOME"]}/chem/lab/RAW/"
	Database = "#{ENV["HOME"]}/chem/lab/"
elsif ENV["OS"][/Windows/] == 'Windows'
	Orbi_drive = "O:\\"
	Jtp_drive = "S:\\RAW\\"
	Database = "S:\\"
end
Jtp_mount = MountedServer::MountMapper.new(Jtp_drive)
Orbi_mount = MountedServer::MountMapper.new(Orbi_drive)
Db_mount = MountedServer::MountMapper.new(Database)
	# I'm thinking that we can have a smart mount that knows your windows/linux location and thereby knows the actual location of every file you might need within the file structure.
=begin
	root = ..group/user/YYYYMM/experiment_name/
	./init/ Files pertinent to the initialization of the data such as the TUNE and METHOD and UPLC files, and the UPLC pressure trace graph.
	./metrics/ All the metrics stuff (Contains the comparison sets)
	./ident/ identification analysis
	./quant/ quantification analysis
	./results/ Results of the analysis
	./samplename(s).RAW
	./mzML/ The mzXML and mzML files
	./config.yml
	./archive/ 	ANY other log files, or previous config files that might be stored

=end


class ArchiveMount
  attr_accessor :base_path, :location 
	def initialize(msrun)
		@msrun = msrun
	end
@@build_directories = ['init', 'metrics', 'ident', 'quant', 'results', 'mzML', 'archive']
#@location = [group, user, mtime, experiment_name]
	def build_archive # @location == LOCATION(group, user, mtime, experiment_id)
#		Dir.chdir(@location)
		@@build_directories.each do |dir|
			mkdir dir
# mdir File.join(@location, dir)
		end
    @location 
	end

	def sys_check? # Returns an indication of the system you are on
		out = "Windows" if ENV["OS"][/Windows/] == 'Windows'
		out = "Linux" if ENV["HOME"][/\/home\//] == '/home/'
		out
	end

	def to_mount
		define_location
		build_archive
		
	end

	def load_config
		@config = YAML.load_file(@settings)
	end

# @location == LOCATION(group, user, mtime, experiment_name)
	def define_location
		@location = [@msrun.group, @msrun.user, File.mtime(@msrun.rawfile), @msrun.rawid]
	end



end

CygBin = "C:\\cygwin\\bin"
CygHome = "C:\\cygwin\\home\\LTQ2"
UserHost = 'ryanmt@jp1'
ProgramLocale = '/home/ryanmt/Dropbox/coding/ms/archiver/lib/archiver.rb'
Tmp_filename
def send_msruninfo_to_linux_via_ssh(object)
	File.open(Tmp_filename, 'w') {|out| YAML.dump(object, out)}
	file_move = %Q[#{CygBin}\\scp #{Tmp_filename} #{UserHost}:/tmp/]
	kick = %Q[#{CygBin}\\ssh #{UserHost} -C '#{ProgramLocale} --linux /tmp/#{Tmp_filename} ']
	%x[#{kick}]
	kick
end
